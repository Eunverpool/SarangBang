const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  _id: String,
  user_uuid: String,
  user_family_email: String,
  user_date: String,
});

const User = mongoose.model("User", userSchema, "User");
module.exports = User;
