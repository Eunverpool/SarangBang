const mongoose = require("mongoose");

const dairySchema = new mongoose.Schema({
  user_uuid: String,
  emoji: String,
  title: String,
  date: Date,
  summary: String,
  emotionRatio: {
    type: Map,
    of: Number,
  },
  cognitiveAnalysis: String, // 예: "Negative (0.21)"
  depressionResult: String, // 예: "Normal"
  cognitiveResult: [
    {
      question: String, // 질문
      area: String, // 인지 영역
      accuracy: String, // 정확성
    },
  ],
});

const Dairy = mongoose.model("Dairy", dairySchema, "Dairy");
module.exports = Dairy;
