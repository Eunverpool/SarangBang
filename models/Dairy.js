const mongoose = require("mongoose");

const dairySchema = new mongoose.Schema({
  user_uuid: String,
  emoji: String,
  title: String,
  date: Date,
  summary: String,
  cognitiveResult: String,
  emotionRatio: {
    type: Map,
    of: Number,
  },
});

const Dairy = mongoose.model("Dairy", dairySchema, "Dairy");
module.exports = Dairy;
