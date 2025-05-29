const User = require("../models/User");

exports.createUser = async (req, res) => {
  const { user_uuid, user_family_email, user_date } = req.body;
  try {
    const newUser = new User({
      _id: user_uuid,
      user_uuid,
      user_family_email,
      user_date,
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

exports.updateEmail = async (req, res) => {
  const { user_uuid, user_family_email } = req.body;

  if (!user_uuid || !user_family_email) {
    return res
      .status(400)
      .json({ message: "user_uuid와 user_family_email은 필수입니다." });
  }

  try {
    const result = await User.updateOne(
      { user_uuid: user_uuid },
      { $set: { user_family_email: user_family_email } }
    );

    if (result.matchedCount === 0) {
      return res
        .status(404)
        .json({ message: "해당 UUID를 가진 사용자를 찾을 수 없습니다." });
    }

    res
      .status(200)
      .json({ message: "이메일이 성공적으로 업데이트되었습니다." });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
