// const Chat = require("../models/Chat");

// exports.saveChat = async (req, res) => {
//   const { user_uuid, user_message, bot_response, chat_date } = req.body;

//   try {
//     const chat = new Chat({
//       user_uuid,
//       user_message,
//       bot_response,
//       chat_date,
//     });
//     await chat.save();
//     res.status(201).json({ message: "Chat saved successfully" });
//   } catch (err) {
//     res.status(500).json({ meesage: err.message });
//   }
// };

const Chat = require("../models/Chat");

exports.saveChat = async (req, res) => {
  const { user_uuid, user_message, bot_response, chat_date } = req.body;

  try {
    const session_id = `${chat_date.slice(0, 10)}-${user_uuid}`; // ex) 2025-05-22-UUID

    const chat = new Chat({
      user_uuid,
      session_id,
      chat_date,
      messages: [
        { role: "user", content: user_message },
        { role: "assistant", content: bot_response },
      ],
    });

    // await chat.save();
    res.status(201).json({ message: "Chat saved successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message }); // 오타 meesage → message
  }
};
