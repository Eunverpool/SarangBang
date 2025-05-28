require("dotenv").config();

const axios = require("axios");

const GPT_MODEL = "gpt-4-turbo";
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

//GPT 프롬프트
function buildCognitiveEvaluationPrompt(pairs) {
  let prompt = `다음은 시니어와의 대화 중 인지 기능 질문과 그에 대한 응답입니다.

각 질문에 대해:
1. MMSE-DS 검사 기준에 따라 어떤 인지 기능 영역인지 분류하세요.
2. 응답이 정확한지 부정확한지 판단하세요.

출력 형식은 다음과 같이 JSON 배열로 하세요:
[
  { "question": "...", "area": "시간 지남력", "accuracy": "정확" },
  ...
]

데이터:
`;
  pairs.forEach(({ question, answer }, i) => {
    prompt += `\n[질문]: ${question}\n[답변]: ${answer}\n`;
  });
  return prompt;
}

//GPT 분석 함수
async function analyzeCognitiveAnswersWithGPT(pairs) {
  const prompt = buildCognitiveEvaluationPrompt(pairs);

  try {
    const response = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: GPT_MODEL,
        messages: [{ role: "user", content: prompt }],
        temperature: 0.3,
      },
      {
        headers: {
          Authorization: `Bearer ${OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    const result = response.data.choices[0].message.content;

    // JSON 파싱
    const jsonStart = result.indexOf("[");
    const jsonEnd = result.lastIndexOf("]");
    const jsonString = result.slice(jsonStart, jsonEnd + 1);

    return JSON.parse(jsonString);
  } catch (err) {
    console.error(
      "X GPT 인지 평가 분석 실패:",
      err.response?.data || err.message
    );
    return [];
  }
}

module.exports = { analyzeCognitiveAnswersWithGPT };
