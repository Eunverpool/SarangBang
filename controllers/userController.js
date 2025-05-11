const User = require("../models/User");

exports.createUser = async (req, res) => {
  const { user_uuid, user_family_email, user_date } = req.body;
  try {
    const newUser = new User({
      _id: user_uuid,
      user_uuid,
      user_family_email,
      user_date: new Date(user_date),
    });
    await newUser.save();
    res.status(200).json({ message: "User saved successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
