const mongoose = require("mongoose");
const { screenVisitSchema } = require("./sessions");
const { actionSchema } = require("./sessions");
const { deviceInfoSchema } = require("./sessions");
const { networkInfoSchema } = require("./sessions");


const userSessionSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  sessionId: {
    type: String,
    required: true,
  },
  shopId: {
    type: String,
    required: true,
  },
  sessionStart: {
    type: Date,
    required: true,
    default: Date.now,
  },
  screensVisited: [screenVisitSchema],
  actions: [actionSchema],
  deviceInfo: deviceInfoSchema,
  networkInfo: networkInfoSchema,
});

const UserSession = mongoose.model("UserSession", userSessionSchema);
module.exports = { UserSession, userSessionSchema };  // Export both model and schema
