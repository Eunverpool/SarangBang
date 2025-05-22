const express = require("express");
const router = express.Router();
const dairyController = require("../controllers/dairyController");

router.post("/", dairyController.generateDiary);
router.get("/", dairyController.getDairy);
module.exports = router;
