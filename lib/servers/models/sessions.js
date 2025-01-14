const mongoose = require("mongoose");

const screenVisitSchema = mongoose.Schema({
  screen: {
    type: String,
    required: true,
  },
  timestamp: {
    type: Date,
    required: true,
    default: Date.now,
  },
  shopId: {
    type: String,
    required: false,
  },
});

const actionSchema = mongoose.Schema({
  action: {
    type: String,
    required: true,
  },
  item: {
    type: String,
    required: false,
  },
  timestamp: {
    type: Date,
    required: true,
    default: Date.now,
  },
  shopId: {
    type: String,
    required: false,
  },
});

const deviceInfoSchema = mongoose.Schema({
  deviceType: {
    type: String,
    required: true,
  },
  os: {
    type: String,
    required: true,
  },
  osVersion: {
    type: String,
    required: true,
  },
});

const networkInfoSchema = mongoose.Schema({
  networkType: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: false,
  },
});

module.exports = {
  screenVisitSchema,
  actionSchema,
  deviceInfoSchema,
  networkInfoSchema,
}