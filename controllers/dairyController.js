require("dotenv").config();
const Chat = require("../models/Chat");
const User = require("../models/User");
const Dairy = require("../models/Dairy");
const nodemailer = require("nodemailer");

const { extractCognitivePairs } = require("../utils/cognitiveUtils");
const {
  analyzeCognitiveAnswersWithGPT,
} = require("../utils/gptCognitiveAnalyzer");

const axios = require("axios");

const GPT_MODEL = "gpt-4-turbo";

// 감정 → 이모지 매핑
const EMOTION_EMOJI_MAP = {
  기쁨: "😄",
  슬픔: "😭",
  놀람: "😲",
  분노: "😡",
  공포: "😱",
  혐오: "🤢",
  중립: "😐",
};

const ALLOWED_EMOTIONS = Object.keys(EMOTION_EMOJI_MAP);

exports.getDairy = async (req, res) => {
  try {
    const { user_uuid } = req.query; // body → query
    const users = await Dairy.find({ user_uuid });
    res.json(users);
  } catch (err) {
    //
    res.status(500).json({ message: err.message });
  }
};

// 프롬프트 생성 함수
function createDiaryPrompt(messages) {
  const chatText = messages
    .filter((msg) => msg.role === "user" || msg.role === "assistant")
    .map((msg) => `${msg.role === "user" ? "사용자" : "AI"}: ${msg.content}`)
    .join("\n");

  return `
다음은 사용자와 AI의 하루 대화입니다. 이를 바탕으로 아래 3가지를 생성해주세요:

1. 📘 일기 요약: 3~5줄로 하루를 요약
2. 🎭 감정 분석: 다음 7가지 감정의 백분율 비율 (기쁨, 슬픔, 놀람, 분노, 공포, 혐오, 중립)
3. 🏷️ 제목: 위 요약을 바탕으로 1줄짜리 일기 제목 생성

대화 내용:
${chatText}

결과 형식 예시:
일기 요약: 오늘은 친구와 통화를 하며 기분이 좋아졌고, 날씨도 맑아서 산책을 즐겼다. 전반적으로 긍정적인 감정이 우세한 하루였다.
감정 분석: 기쁨 50%, 슬픔 10%, 놀람 5%, 분노 10%, 공포 5%, 혐오 5%, 중립 15%
제목: 친구와의 대화로 따뜻했던 하루
`;
}

// 감정 분석 결과 문자열 → 상위 3개만 Map 변환
function parseTop3Emotions(str) {
  const parts = str.split(",").map((p) => p.trim());
  const fullMap = {};

  parts.forEach((p) => {
    const [emotion, percent] = p.split(" ");
    if (ALLOWED_EMOTIONS.includes(emotion)) {
      fullMap[emotion] = parseFloat(percent.replace("%", "")) || 0;
    }
  });

  // 상위 3개 감정만 추출
  const top3 = Object.entries(fullMap)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3);

  const result = {};
  top3.forEach(([emotion, percent]) => {
    result[emotion] = percent;
  });

  return result;
}

// 가장 높은 감정 추출 → 이모지
function getDominantEmotionEmoji(emotionRatio) {
  let max = -1;
  let dominant = "중립"; // 기본값
  for (const [emotion, value] of Object.entries(emotionRatio)) {
    if (value > max && EMOTION_EMOJI_MAP[emotion]) {
      max = value;
      dominant = emotion;
    }
  }
  return EMOTION_EMOJI_MAP[dominant] || "😐";
}

// 요약에서 제목 추출 (첫 문장 or 20자 이내)
function extractTitle(summary) {
  return summary.split(".")[0].trim().slice(0, 20); // 마침표 전까지 or 20자
}

exports.generateDairy = async (req, res) => {
  const { user_uuid } = req.body;

  if (!user_uuid)
    return res.status(400).json({ error: "user_uuid가 필요합니다." });

  const today = new Date().toISOString().slice(0, 10);
  const sessionId = `${today}-${user_uuid}`;
  try {
    // 1. 기존 일기 확인
    const existingDiary = await Dairy.findOne({
      user_uuid,
      date: new Date(today),
    });
    if (existingDiary) {
      return res.status(200).json({
        alreadyExists: true,
        message: "이미 오늘의 일기가 작성되었습니다.",
      });
    }

    // 2. 세션 대화 가져오기
    const chat = await Chat.findOne({ session_id: sessionId });
    if (!chat || !chat.messages.length) {
      return res.status(404).json({ error: "해당 세션 대화가 없습니다." });
    }

    // 3. GPT에 프롬프트 전송
    const prompt = createDiaryPrompt(chat.messages);
    const gptResponse = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: GPT_MODEL,
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    const result = gptResponse.data.choices[0].message.content;

    // 4. 응답 파싱
    const summaryMatch = result.match(/일기 요약:\s*(.+)/);
    const emotionMatch = result.match(/감정 분석:\s*(.+)/);
    const titleMatch = result.match(/제목:\s*(.+)/);

    const summary = summaryMatch?.[1]?.trim() || "요약 없음";
    const emotionRatio = parseTop3Emotions(emotionMatch?.[1] || "");
    const emoji = getDominantEmotionEmoji(emotionRatio);

    const title = titleMatch?.[1]?.trim().slice(0, 30) || "제목 없음"; // 30자 제한

    // 5 인지 질문 쌍 추출 및 GPT 평가
    const cognitivePairs = extractCognitivePairs(chat.messages);
    const cognitiveResult = await analyzeCognitiveAnswersWithGPT(
      cognitivePairs
    );

    // 6. DB 저장
    const diary = new Dairy({
      user_uuid,
      title,
      summary,
      emoji,
      emotionRatio,
      date: new Date(today),
      cognitiveResult,
    });

    await diary.save();
    const user = await User.findOne({ user_uuid });
    if (user && user.user_family_email) {
      // 이메일 있을 때만 전송
      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS,
        },
      });

      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: user.user_family_email,
        subject: `📘 오늘의 일기 저장 알림 - ${today}`,
        text: `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border:1px solid #ddd; padding:20px; border-radius: 10px;">
      <h2 style="color: #1A8917;">오늘의 일기</h2>
      <p><strong>📅 날짜:</strong> ${today}</p>

      <h3>💬 대화 내용 요약</h3>
      <div style="border-left: 4px solid #1A8917; padding-left: 12px; background: #f9f9f9; border-radius: 5px; margin-bottom: 20px;">
        ${summary}
      </div>

      <h3>📊 감정 분석</h3>
      <ul style="list-style:none; padding:0;">
        ${Object.entries(emotionRatio)
          .map(
            ([emotion, percent]) =>
              `<li><strong>${emotion}:</strong> ${percent}%</li>`
          )
          .join("")}
      </ul>

      <h3>🧠 정신 건강 상태</h3>
      <p>우울증 검사: <strong>${
        cognitiveResult?.depressionScore || "N/A"
      }%</strong></p>
      <p>결과: <strong>${
        cognitiveResult?.depressionScore > 60 ? "높음" : "정상"
      }</strong></p>

      <h3>📝 인지 테스트 결과</h3>
      <ul>
        ${(cognitiveResult?.tests || [])
          .map(
            (test) =>
              `<li>${test.label}: <strong style="color: ${
                test.result === "정상" ? "green" : "red"
              };">${test.result}</strong></li>`
          )
          .join("")}
      </ul>

      <hr>
    </div>
  `,
      };

      await transporter.sendMail(mailOptions);
    }
    res.status(201).json({ message: "일기 저장 완료", diary });
  } catch (err) {
    console.error("❌ 일기 생성 오류:", err.response?.data || err.message);
    res.status(500).json({ error: "일기 생성 실패" });
  }
};

exports.getRandomDairy = async (req, res) => {
  try {
    const { user_uuid } = req.query;

    const diaries = await Dairy.find({ user_uuid });

    if (diaries.length === 0) {
      return res.status(404).json({ message: "No diary entries found." });
    }

    const randomIndex = Math.floor(Math.random() * diaries.length);
    const randomDiary = diaries[randomIndex];

    res.json(randomDiary);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updateAnalysisResult = async (req, res) => {
  const { user_uuid, dementiaResult, depressionResult } = req.body;

  if (!user_uuid || !dementiaResult || !depressionResult) {
    return res.status(400).json({ error: "필수 항목 누락" });
  }

  const today = new Date.toISOString().slice(0, 10);
  const todayDate = new Date(today);

  try {
    const result = await Dairy.updateOne(
      { user_uuid, date: todayDate },
      {
        $set: {
          cognitiveAnalysis: dementiaResult,
          depressionResult: depressionResult,
        },
      },
      { upsert: true }
    );
    res.status(200).json({
      message: "✅ 분석 결과 저장 성공",
      result,
    });
  } catch (err) {
    console.error("❌ 저장 오류:", err);
    res.status(500).json({ error: "분석 결과 저장 실패" });
  }
};
