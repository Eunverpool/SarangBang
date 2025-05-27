const Dairy = require("../models/Dairy");

exports.getDairy = async (req, res) => {
  try {
    const { user_uuid } = req.query; // body → query
    const users = await Dairy.find({ user_uuid });
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getRandomDairy = async (req, res) => {
  try {
    const { user_uuid } = req.query;

    const diaries = await Dairy.find({ user_uuid });

    if (diaries.length === 0) {
      return res.status(404).json({ message: "No diary entries found." });
    }

    const randomIndex = Math.floor(Math.random() * diaries.length);
    const randomDiary = diaries[randomIndex];

    res.json(randomDiary);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
