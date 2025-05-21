const Dairy = require("../models/Dairy");

exports.getDairy = async (req, res) => {
  try {
    const { uuid } = req.body;
    const users = await Dairy.find({ uuid });
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
