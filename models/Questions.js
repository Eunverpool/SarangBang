const mongoose = require("mongoose");

const answerSchema = new mongoose.Schema({
  answer_id: String,
  answer_content: String,
});

const questionSchema = new mongoose.Schema({
  _id: String,
  questions_title: String,
  questions_content: String,
  answers: [answerSchema],
});

const Question = mongoose.model("Questions", questionSchema, "Questions");
module.exports = Question;
