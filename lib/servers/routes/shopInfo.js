const express = require("express");
const shopInfoRouter = express.Router();
const auth = require("../middlewares/auth");
const User = require('../models/user'); 
const { ShopInfo } = require("../models/shopInfo");

shopInfoRouter.post("/api/add-to-shopcodes", auth, async (req, res) => {
  try {
    const { shopCode } = req.body;

    if (!shopCode) {
      return res.status(400).json({ error: "shopCode is required" });
    }

    // Find shopInfo by shopCode
    const shopInfo = await ShopInfo.findOne({ shopCode: shopCode });
    if (!shopInfo) {
      return res.status(404).json({ error: "Shop not found" });
    }

    // Find user
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Check if the shopInfo is already in the user's shopCodes
    const isShopInfoFound = user.shopCodes.some(shopCodeEntry =>
      shopCodeEntry.shopInfo._id.equals(shopInfo._id)
    );

    // If not found, add it to the user's shopCodes
    if (!isShopInfoFound) {
      user.shopCodes.push({ shopInfo });
      await user.save();
    }

    res.json(user);
  } catch (e) {
    console.error("Error adding shop code:", e);
    res.status(500).json({ error: e.message });
  }
});


//fetch shop info
shopInfoRouter.get("/api/user/:userId/shopCodes", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.userId).populate('shopCodes.shopInfo');
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(user.shopCodes);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = shopInfoRouter;
