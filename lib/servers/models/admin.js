const mongoose = require("mongoose");
const { productSchema } = require("./product");
const { shopDetailsSchema } = require("./shopDetails");
const { userSessionSchema } = require("./userSession");


const adminSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "Pune, Maharashtra",
  },
  type: {
    type: String,
    default: "admin",
  },

  productsInfo :[
    {
      product: productSchema,
    }
  ],

  shopDetails: [shopDetailsSchema],

  shopCode:{
    type: String,
    default: '123456'
  },

  sessions: [userSessionSchema]

});

const Admin = mongoose.model("Admin", adminSchema);
module.exports = Admin;

