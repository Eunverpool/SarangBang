const mongoose = require("mongoose");

const reportSchema = new mongoose.Schema({
  _id: String,
  user_id: String,
  daily__id: String,
  total_cognitive_score: int,
  report_date: Date,
});

const Report = mongoose.model("Report", reportSchema, "Report");
module.exports = Report;
