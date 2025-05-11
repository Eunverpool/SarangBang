const express = require("express");
const router = express.Router();
const diaryController = require("../controllers/diaryController");

router.post("/", diaryController.creatediary);

module.exports = router;
