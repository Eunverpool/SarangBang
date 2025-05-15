const mongoose = require("mongoose");

const Daily_ReportSchema = new mongoose.Schema({
  _id: String,
  user_id: String,
  diary_id: String,
  report_date: Date,
  daily_emotion: Boolean,
});

const Daily_Report = mongoose.model(
  "Daily_Report",
  Daily_ReportSchema,
  "Daily_Report"
);
module.exports = Daily_Report;
