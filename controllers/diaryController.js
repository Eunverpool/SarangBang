const Diary = require("../models/Diary");

exports.createDiary = async (req, res) => {};

exports.getUsers = async (req, res) => {
  try {
    const users = await Diary.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
