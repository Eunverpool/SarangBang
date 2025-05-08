const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const dotenv = require("dotenv");
const User = require("./models/User");
const cors = require("cors");

dotenv.config(); // .env 파일을 읽어서 process.env에 설정

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());
// MongoDB 연결
mongoose.connect(process.env.Mongo_URL);

const db = mongoose.connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
  console.log("Current DB Name:", mongoose.connection.name);
});
app.post("/users", async (req, res) => {
  const { user_uuid, user_family_email, user_date } = req.body;

  try {
    const newUser = new User({
      _id: user_uuid, // UUID를 _id로 사용
      user_uuid: user_uuid,
      user_family_email: user_family_email,
      user_date: new Date(user_date), // 받은 date를 Date 객체로 변환
    });

    await newUser.save();
    res.status(200).json({ message: "User saved successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.get("/", (req, res) => {
  res.send("Hello from the backend!");
});
app.get("/users", async (req, res) => {
  try {
    const users = await User.find(); // 전체 문서 조회
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
