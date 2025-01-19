const express = require("express");
const userRouter=express.Router();
const User=require("../models/user");
const auth=require("../middlewares/auth")
const { Product } = require("../models/product");
const { mongoose } = require("mongoose");
const Order = require("../models/order");
const moment = require('moment');

//fetch all orders based on shopcode
//fetch all orders based on shopId
userRouter.get("/api/get-orders", auth, async (req, res) => {
    try {
      const { shopId, date } = req.query;
      const startDate = moment(date).startOf('day').valueOf();
  const endDate = moment(date).endOf('day').valueOf();
  
  const orders = await Order.find({
    shopId,
    orderedAt: { $gte: startDate, $lte: endDate }
  });
  
  
      console.log(`Fetched Orders for shopId ${shopId} and date ${date}:`, orders);
      res.json(orders);
    } catch (e) {
      console.error("Error fetching orders:", e);
      res.status(500).json({ error: e.message });
    }
  });
  