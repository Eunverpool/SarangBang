const express = require("express");
const router = express.Router();
const diaryController = require("../controllers/diaryController");

router.post("/", diaryController.createDiary);
router.get("/", diaryController.getUsers);
module.exports = router;
