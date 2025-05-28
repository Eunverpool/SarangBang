// utils/congitiveUtils.js

function extractCognitivePairs(messages) {
  const result = [];

  for (let i = 0; i < messages.length - 1; i++) {
    const q = messages[i];
    const a = messages[i + 1];

    if (
      q.role === "assistant" &&
      q.content.includes("[인지]") &&
      a.role === "user"
    ) {
      result.push({
        question: q.content.replace("[인지]", "").trim(),
        answer: a.content.trim(),
      });
    }
  }
  return result;
}
module.exports = { extractCognitivePairs };
