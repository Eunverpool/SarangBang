const Dairy = require("../models/Dairy");

exports.getDairy = async (req, res) => {
  try {
    const users = await Dairy.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
