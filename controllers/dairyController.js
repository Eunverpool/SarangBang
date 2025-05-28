require("dotenv").config();
const Chat = require("../models/Chat");
const Dairy = require("../models/Dairy");

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

    // 3.1 인지 질문 쌍 추출 및 GPT 평가
    const cognitivePairs = extractCognitivePairs(chat.messages);
    const cognitiveResult = await analyzeCognitiveAnswersWithGPT(
      cognitivePairs
    );

    // 5. DB 저장
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

    res.status(201).json({ message: "일기 저장 완료", diary });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
