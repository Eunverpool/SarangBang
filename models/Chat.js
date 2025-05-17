const mongoose = require("mongoose");

// const chatSchema = new mongoose.Schema({
//   _id: String,
//   user_id: String,
//   chat_url: String,
//   chat_content: String,
//   chat_date: Date,
// });
const chatSchema = new mongoose.Schema({
  user_uuid: String,
  user_message: String,
  bot_response: String,
  chat_date: String,
});

const Chat = mongoose.model("Chat", chatSchema, "Chat");
module.exports = Chat;
