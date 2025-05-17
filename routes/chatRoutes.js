// routes/chatRoutes.js

const express = require("express");
const router = express.Router();
const chatController = require("../controllers/chatController");

router.post("/", chatController.saveChat); //POST /chat

module.exports = router;
