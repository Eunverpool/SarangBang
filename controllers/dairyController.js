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
