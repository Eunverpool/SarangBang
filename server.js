const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const bodyParser = require("body-parser");
const connectDB = require("./config/db");

//Routes 상수 생성
const userRoutes = require("./routes/userRoutes");
const dairyRoutes = require("./routes/dairyRoutes");
const chatRoutes = require("./routes/chatRoutes");
const gptRoutes = require("./routes/gptRoutes");

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
app.use("/dairy", dairyRoutes);
app.use("/chat", chatRoutes);
app.use("/gpt", gptRoutes);
app.listen(port, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
// app.listen(3000, "0.0.0.0", () => {
//   console.log(`🚀 Server running at http://localhost:3000`);
// });
