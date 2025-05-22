const mongoose = require("mongoose");

// const chatSchema = new mongoose.Schema({
//   _id: String,
//   user_id: String,
//   chat_url: String,
//   chat_content: String,
//   chat_date: Date,
// });

const messageSchema = new mongoose.Schema({
  role: String,
  content: String,
});

const chatSchema = new mongoose.Schema({
  user_uuid: String,
  session_id: String,
  messages: [messageSchema],
  chat_date: String,
});

const Chat = mongoose.model("Chat", chatSchema, "Chat");
module.exports = Chat;
