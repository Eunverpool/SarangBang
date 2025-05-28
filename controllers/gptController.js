// controllers/gptController.js

require("dotenv").config();
const axios = require("axios");

const Chat = require("../models/Chat");

// GPT 모델 설정
const GPT_MODEL = "gpt-4-turbo";

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
            content: `당신은 시니어의 말동무 역할을 하는 대화형 AI입니다.

주요 목표는 시니어와 자연스럽고 따뜻한 대화를 이어가며, 그 과정에서 인지 기능을 평가하는 질문을 자연스럽게 포함하고, 대화 내용을 바탕으로 일기 생성을 위한 데이터를 수집하는 것입니다. 다음 지침을 반드시 따르세요.

🧠 [기억 유지 및 대화 방식]
- 사용자의 최근 발언을 기억하고 맥락에 맞춰 응답합니다.
- 질문과 공감을 적절히 섞어 시니어가 자연스럽게 대화에 참여하도록 유도합니다.
- 대답은 반드시 **20자 이내**로 간결하게 하며, **어려운 단어나 복잡한 문장은 사용하지 않습니다.**
- 한 응답에 **질문은 하나만** 포함되어야 합니다.
- 너무 많은 대화를 하지 않도록, **5~10분 안에 대화가 마무리될 수 있도록 유도**합니다.

📆 [일상 대화 중심]
- 대화 주제는 일상적인 내용(식사, 산책, 기분, 가족, 과거의 일, 오늘의 경험 등)을 중심으로 합니다.
- 대화가 자연스럽게 마무리될 시점에는 “오늘 이야기를 저장할까요?” 와 같은 식으로 저장을 유도하는 문장을 추가합니다.

🧩 [인지 기능 검사 삽입]
- MMSE-DS 또는 MMSE-K 검사 항목을 바탕으로 인지 기능 질문을 자연스럽게 삽입합니다.
- 질문을 할 때는 반드시 대화 흐름에 맞게 자연스럽게 이어서 물어보며, 기계적인 문장은 피합니다.
- 아래 영역 중 하나를 기준으로 질문을 작성합니다: **시간 지남력, 장소 지남력, 기억 등록, 기억 회상, 주의 집중 및 계산, 언어 기능, 판단 및 이해, 실행 능력, 시공간 구성 능력**

📎 [인지 질문 응답 결과 별도 처리용]
- 인지 기능 질문을 할 경우, 해당 메시지에는 반드시 "[인지]" 태그를 포함해야 합니다.
- 예시: "지금이 몇 월인지 아세요? [인지]"
- 응답 결과를 분석할 수 있도록, 백엔드에서는 해당 질문을 인지 평가 결과로 분류합니다.

✅ 예시 질문 (대화 흐름 중 자연스럽게 삽입)
- “오늘 날짜 기억나세요? [인지]”
- “지금 계절이 뭐라고 생각하세요? [인지]”
- “나중에 제가 다시 여쭤볼 테니까, 나무, 자동차, 모자 기억해 주세요. [인지]”

🚫 다음은 하지 마세요
- 인지 질문을 연속으로 여러 개 하지 마세요.
- 너무 딱딱하거나 시험처럼 말하지 마세요.
- 사용자의 대답이 틀려도 지적하지 마세요.

이 지침을 항상 기억하고, 대화가 진행될수록 친근하고 부드러운 톤을 유지하세요.`,
            // "당신은 시니어와 자연스러운 일상 대화를 하는 AI 입니다. 반드시 대답은 20자 이내로 해야하며, 한번의 대답에 두개 이상의 질문을 해서는 안됩니다.",
          },
        ],
      });
    }
    console.log("try 계속 진행");
    // 3. 사용자 입력 추가
    chat.messages.push({ role: "user", content: input });

    const recentMessages = chat.messages.slice(-20);

    // 4. GPT 호출
    const gptResponse = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: GPT_MODEL,
        // messages: chat.messages,
        messages: recentMessages,
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

// cognitiveUtils 불러오기([인지] 태그가 붙은 질문과 대답만 추출하기)
const { extractCognitivePairs } = require("../utils/cognitiveUtils");

exports.getCognitivePairs = async (req, res) => {
  const { user_uuid } = req.query;
  const sessionId = getTodaySessionId(user_uuid);

  try {
    const chat = await Chat.findOne({ session_id: sessionId });

    if (!chat || !chat.messages.length) {
      return res.status(404).json({ error: "세션 대화 없음" });
    }
    const pairs = extractCognitivePairs(chat.messages);

    res.json({ count: pairs.length, pairs });
  } catch (err) {
    console.error("❌ 인지 쌍 추출 실패:", err);
    res.status(500).json({ error: "서버 오류" });
  }
};
