const mongoose = require("mongoose");
const { categorySchema } = require("./category");
const { couponSchema } = require("./coupon");
const { offerDescriptionSchema } = require("./offerDes");
const { chargesSchema } = require("./charges");
const { orderSettingsSchema } = require("./orderSettings");
const ratingSchema = require("./ratings");

const shopDetailsSchema = mongoose.Schema({
  shopName: {
    required: false,
    type: String,
  },
  number: {
    required: false,
    type: String,
  },
  address: {
    required: false,
    type: String,
    default: "",
  },

  shopCode: {
    required: false,
    type: String,
    // unique: true,
  },

  categories: [categorySchema],

  delPrice: {
    type: Number,
    required: false,
    default: 0,
  },

  coupon: {
    type: [couponSchema],
    validate: {
      validator: function(coupons) {
        return coupons.length <= 6;  // Validates max 6 coupons as per UI
      },
      message: 'A shop can have maximum 6 coupons'
    }
  },

  offerImages: {
    type: {
      images: {
        type: [String], 
        validate: {
          validator: function (images) {
            return images.length <= 10; 
          },
          message: 'A shop can have a maximum of 10 offer images',
        },
      },
      offerImagesToggle: {
        type: Boolean, 
        default: false, 
      },
    },
  },


  offerDes: {
    type: [offerDescriptionSchema],
    validate: {
      validator: function(descriptions) {
        return descriptions.length <= 6;
      },
      message: 'A shop can have maximum 6 offer descriptions'
    }
  },
  
  Offertime: {
    type: Date,
    required: false,
    default: new Date('2024-10-13'),
  },

  socialLinks: {
    type: [String], 
    required: false,
    default: [], 
  },

  lastUpdated: {
    type: Date,
    required: true,
    default: Date.now, 
  },

  charges: {
    type: chargesSchema,
    required: false,
    default: () => ({
      isDeliveryChargesEnabled: false
    })
  },

  orderSettings: {
    type: orderSettingsSchema, 
    required: false,
  },

  ratings: [ratingSchema],

  orderSettings: {
    type: orderSettingsSchema, 
    required: false,
  },

});

const ShopDetails = mongoose.model("ShopDetails", shopDetailsSchema);
module.exports = { ShopDetails, shopDetailsSchema ,chargesSchema};
