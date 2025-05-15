const mongoose = require("mongoose");

const chatSchema = new mongoose.Schema({
  _id: String,
  user_id: String,
  chat_url: String,
  chat_content: String,
  chat_date: Date,
});

const Chat = mongoose.model("Chat", chatSchema, "Chat");
module.exports = Chat;
