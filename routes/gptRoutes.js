// routes/gptRoutes.js

const express = require("express");
const router = express.Router();
const gptController = require("../controllers/gptController");

//gpt 응답 라우터
router.post("/", gptController.getGptResponse);

// [인지] 질문/응답 추출 라우터
router.get("/cognitive", gptController.getCognitivePairs);

module.exports = router;
