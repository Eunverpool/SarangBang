const mongoose = require("mongoose");

const storeSchema = new mongoose.Schema({
  _id: String,
  product_name: String,
  img_url: String,
  price: String,
});

const Store = mongoose.model("Store", storeSchema, "Store");
module.exports = Store;
