const Chat = require("../models/Chat");

exports.saveChat = async (req, res) => {
  const { user_uuid, user_message, bot_response, chat_date } = req.body;

  try {
    const chat = new Chat({
      user_uuid,
      user_message,
      bot_response,
      chat_date,
    });
    await chat.save();
    res.status(201).json({ message: "Chat saved successfully" });
  } catch (err) {
    res.status(500).json({ meesage: err.message });
  }
};
