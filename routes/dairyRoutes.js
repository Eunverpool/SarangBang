const express = require("express");
const router = express.Router();
const dairyController = require("../controllers/dairyController");

router.post("/", dairyController.generateDairy);
router.post("/analysis", dairyController.updateAnalysisResult);

router.get("/", dairyController.getDairy);
router.get("/random-diary", dairyController.getRandomDairy);

module.exports = router;
