// // const Dairy = require("../models/Dairy");
// require("dotenv").config();
// const Chat = require("../models/Chat");
// const Dairy = require("../models/Dairy");
// const axios = require("axios");

// const GPT_MODEL = "gpt-3.5-turbo";

// exports.getDairy = async (req, res) => {
//   try {
//     const { user_uuid } = req.query; // body → query
//     const users = await Dairy.find({ user_uuid });
//     res.json(users);
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//   }
// };

// // GPT에 보낼 프롬프트 생성 함수
// function createDiaryPrompt(messages) {
//   const chatText = messages
//     .filter((msg) => msg.role === "user" || msg.role === "assistant")
//     .map((msg) => `${msg.role === "user" ? "사용자" : "AI"}: ${msg.content}`)
//     .join("\n");

//   return `
// 다음은 사용자와 AI의 하루 대화입니다. 이를 기반으로 일기 형식의 요약을 작성해주세요.
// 일기는 3~5줄 이내로 작성되어야 하며, 전체적인 감정 상태(예: 분노, 기쁨, 슬픔 등)의 비율도 함께 출력해주세요.

// 대화 내용:
// ${chatText}

// 결과 형식 예시:
// 일기 요약: 오늘은 친구와의 통화에서 기쁨을 느꼈고, 날씨가 좋아 산책도 다녀왔다. 기분이 전반적으로 좋았다.
// 감정 분석: 기쁨 60%, 슬픔 30%, 분노 10%
// `;
// }

// exports.generateDiary = async (req, res) => {
//   const { user_uuid } = req.body;

//   if (!user_uuid)
//     return res.status(400).json({ error: "user_uuid가 필요합니다." });

//   const today = new Date().toISOString().slice(0, 10);
//   const sessionId = `${today}-${user_uuid}`;

//   try {
//     // 이미 작성된 일기 있는지 확인
//     const existingDiary = await Dairy.findOne({
//       user_uuid,
//       date: new Date(today),
//     });

//     if (existingDiary) {
//       return res.status(200).json({
//         alreadyExists: true,
//         message: "이미 오늘의 일기가 작성되었습니다.",
//       });
//     }

//     const chat = await Chat.findOne({ session_id: sessionId });
//     if (!chat || !chat.messages.length) {
//       return res.status(404).json({ error: "해당 세션 대화가 없습니다." });
//     }

//     const prompt = createDiaryPrompt(chat.messages);

//     const gptResponse = await axios.post(
//       "https://api.openai.com/v1/chat/completions",
//       {
//         model: GPT_MODEL,
//         messages: [{ role: "user", content: prompt }],
//         temperature: 0.7,
//       },
//       {
//         headers: {
//           Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
//           "Content-Type": "application/json",
//         },
//       }
//     );

//     const result = gptResponse.data.choices[0].message.content;

//     // 결과 파싱 (일기 요약 + 감정 분석)
//     const summaryMatch = result.match(/일기 요약:\s*(.+)/);
//     const emotionMatch = result.match(/감정 분석:\s*(.+)/);

//     const diary = new Dairy({
//       user_uuid,
//       title: summaryMatch?.[1].slice(0, 20) || "일기",
//       summary: summaryMatch?.[1] || "요약 없음",
//       emotionRatio: parseEmotionString(emotionMatch?.[1] || ""),
//       date: new Date(today),
//     });

//     await diary.save();

//     res.status(201).json({ message: "일기 저장 완료", diary });
//   } catch (err) {
//     console.error("❌ 일기 생성 오류:", err.response?.data || err.message);
//     res.status(500).json({ error: "일기 생성 실패" });
//   }
// };

// // 감정 분석 결과 문자열을 Map 형태로 파싱
// function parseEmotionString(str) {
//   const parts = str.split(",").map((p) => p.trim());
//   const result = {};
//   parts.forEach((p) => {
//     const [emotion, percent] = p.split(" ");
//     if (emotion && percent) {
//       result[emotion] = parseFloat(percent.replace("%", "")) || 0;
//     }
//   });
//   return result;
// }
require("dotenv").config();
const Chat = require("../models/Chat");
const Dairy = require("../models/Dairy");
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
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
