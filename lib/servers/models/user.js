const mongoose = require("mongoose");
const { productSchema } = require("./product");



const userSchema = mongoose.Schema({
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
    default: "user",
  },

  cart :[
    {
      product: productSchema,
      quantity:{
        type:Number,
        default:1
      }
    }
  ],

  likedProducts: [
    {
      product: productSchema, 
      likedAt: {
        type: Date,
        default: Date.now 
      }
    }
  ],

  shopCode: {
    type: String,
    default: null,
  },

  // shopCodes:[
  //   {
  //     shopInfo: shopInfoSchema,
  //   }
  // ],

  shopCodes: [
    {
      type: String,
      required: false,
    },
  ],


  time: {
    type: String,
    default: null,
  },
  

  location: {
    latitude: {
      type: Number,
      default: 0,
    },
    longitude: {
      type: Number,
      default: 0,
    },
  },

});

const User = mongoose.model("User", userSchema);
module.exports = User;

