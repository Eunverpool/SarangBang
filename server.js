const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const dotenv = require("dotenv");
const User = require("./models/User");
dotenv.config(); // .env 파일을 읽어서 process.env에 설정

const app = express();
const port = 3000;

app.use(bodyParser.json());

// MongoDB 연결
mongoose.connect(process.env.Mongo_URL);

const db = mongoose.connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
  console.log("Current DB Name:", mongoose.connection.name);
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
