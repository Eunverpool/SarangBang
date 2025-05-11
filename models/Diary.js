const mongoose = require("mongoose");

const diarySchema = new mongoose.Schema({
  _id: String,
  user_uuid: String,
  diary_title: String,
  diary_content: String,
  user_date: Date,
});

const Diary = mongoose.model("Dairy", diarySchema, "Dairy");
module.exports = Diary;
