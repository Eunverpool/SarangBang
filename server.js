const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const bodyParser = require("body-parser");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const diaryRoutes = require("./routes/diaryRoutes");

dotenv.config();
const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

connectDB();

app.get("/", (req, res) => {
  res.send("Hello from the backend!");
});
app.use("/users", userRoutes);
app.use("/diary", diaryRoutes);
app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
