// controllers/gptController.js

console.log("🧪 현재 사용 중인 API 키:", process.env.OPENAI_API_KEY);
require("dotenv").config();
const axios = require("axios");

console.log("🧪 현재 사용 중인 API 키:", process.env.OPENAI_API_KEY);
const Chat = require("../models/Chat");

// GPT 모델 설정
const GPT_MODEL = "gpt-3.5-turbo";

// 세션 ID 생성 함수 (하루 단위 + 유저별)
function getTodaySessionId(user_uuid) {
  console.log("세션생성");
  const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
  return `${today}-${user_uuid}`;
}

// GPT 응답 컨트롤러
exports.getGptResponse = async (req, res) => {
  console.log("gpt호출");
  const { input, user_uuid } = req.body;

  if (!input || !user_uuid) {
    return res.status(400).json({ error: "user_uuid와 input은 필수입니다." });
  }

  const sessionId = getTodaySessionId(user_uuid);

  try {
    console.log("try진입");
    // 1. 기존 세션 조회
    let chat = await Chat.findOne({ session_id: sessionId });

    // 2. 없으면 새로 생성
    if (!chat) {
      console.log("세션 못찾음");
      chat = new Chat({
        user_uuid,
        session_id: sessionId,
        chat_date: new Date().toISOString(),
        messages: [
          {
            role: "system",
            content:
              "당신은 시니어와 자연스러운 일상 대화를 하는 AI 입니다. 반드시 대답은 20자 이내로 해야하며, 한번의 대답에 두개 이상의 질문을 해서는 안됩니다.",
          },
        ],
      });
    }
    console.log("try 계속 진행");
    // 3. 사용자 입력 추가
    chat.messages.push({ role: "user", content: input });

    // 4. GPT 호출
    const gptResponse = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: GPT_MODEL,
        messages: chat.messages,
        temperature: 0.7,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    const reply = gptResponse.data.choices[0].message.content;

    // 5. GPT 응답 추가 후 DB 저장
    chat.messages.push({ role: "assistant", content: reply });

    console.log("🧪 저장 직전 메시지 수:", chat.messages.length);
    await chat.save();
    console.log("✅ Chat 저장 완료!");

    // 6. 클라이언트에 응답 전송
    res.json({ response: reply });
  } catch (error) {
    console.error("❌ GPT 호출 실패:", error.response?.data || error.message);
    res.status(500).json({ error: "GPT API 호출 실패" });
  }
};
