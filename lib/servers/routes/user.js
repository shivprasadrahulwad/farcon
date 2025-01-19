const express = require("express");
const userRouter=express.Router();
const User=require("../models/user");
const auth=require("../middlewares/auth")
const { Product } = require("../models/product");
const { mongoose } = require("mongoose");
const moment = require('moment');
const Admin = require("../models/admin");
const Order = require('../models/order'); 

userRouter.post("/admin/add-to-cart", auth ,async (req ,res) =>{
  try {
    const {id} =req.body;
    const product=await Product.findById(id);
    let user=await User.findById(req.user);
    
    let isProductFound=false;
    for(let i=0;i<user.cart.length ; i++){
      if(user.cart[i].product._id.equals(product._id)){
        isProductFound=true;
        console.log("Product is already added into cart!!!");
      }
    }

    if(!isProductFound)
      {
        user.cart.push({product});
      }

      user=await user.save();
      res.json(user);
  } catch (e) {
    
  }
})



//fetch products from other users cart
userRouter.get("/api/user/:userId/cart/products", auth, async (req, res) => {
    try {
      const user = await User.findById(req.params.userId).populate('cart.product');
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
      res.json(user.cart.map(item => item.product));
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


// Route to fetch products from the cart by user ID and product IDs
userRouter.post("/api/admin/:shopcode/products", auth, async (req, res) => {
  try {
    const { shopcode } = req.params;
    const { productIds } = req.body;

    console.log(`Received request for shop ${shopcode} with product IDs:`, productIds);

    if (!Array.isArray(productIds) || productIds.length === 0) {
      return res.status(400).json({ error: "Invalid product IDs" });
    }

    // Find the admin document by shopCode
    const admin = await Admin.findOne({ shopCode: shopcode });

    if (!admin) {
      console.log(`Admin not found for shopCode: ${shopcode}`);
      return res.status(404).json({ error: "Shop not found" });
    }

    console.log('Admin found:', JSON.stringify(admin, null, 2));

    // Check if productsInfo exists and is an array
    if (!Array.isArray(admin.productsInfo)) {
      console.log(`productsInfo is not an array for admin with shopCode ${shopcode}:`, admin.productsInfo);
      return res.status(404).json({ error: "Admin has no products info" });
    }

    // Collect products from the admin's productsInfo that match the provided product IDs
    let products = admin.productsInfo
      .filter(item => item && item.product && productIds.includes(item.product._id.toString()))
      .map(item => item.product);

    console.log(`Found ${products.length} matching products`);

    if (!products.length) {
      return res.status(404).json({ error: "No matching products found for this shop" });
    }

    res.json(products);
  } catch (e) {
    console.error('Error in /api/shop/:shopcode/products:', e);
    res.status(500).json({ error: e.message });
  }
});

//// fetch products 
  userRouter.post("/api/products/details", auth, async (req, res) => {
    const { productIds } = req.body; // Expecting an array of product IDs in the request body

    if (!Array.isArray(productIds) || productIds.length === 0) {
        return res.status(400).json({ error: "Invalid product IDs" });
    }

    try {
        const products = await Product.find({ _id: { $in: productIds } });

        if (!products.length) {
            return res.status(404).json({ error: "No products found" });
        }

        res.json(products); // Respond with the array of product details
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


//// shopinfo/details by shopcode
userRouter.get("/api/shop/:shopCode/details", auth, async (req, res) => {
  try {
    const { shopCode } = req.params;

    // Find users with the specified shopCode
    const users = await Admin.find({ shopCode });

    if (!users.length) {
      return res.status(404).json({ error: "No shop found with this shop code" });
    }

    // Collect all shopDetails from the users found
    let shopDetails = [];

    users.forEach(user => {
      user.shopDetails.forEach(shop => {
        if (shop.shopCode === shopCode) {
          shopDetails.push(shop); // Collect shop details
        }
      });
    });

    if (!shopDetails.length) {
      return res.status(404).json({ error: "No shop details found for this shop code" });
    }

    // Return the shopDetails array
    res.json(shopDetails);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//// fetching shop info for storing in the shop details provider
userRouter.get("/api/shop-info/:shopCode", async (req, res) => {
  try {
    const { shopCode } = req.params;
    console.log("Searching for shop with code:", shopCode);

    // Find admin with matching shopCode
    const adminUser = await Admin.findOne({ 
      shopCode: shopCode 
    }).populate("shopDetails");

    if (!adminUser) {
      console.log("No admin found with shop code:", shopCode);
      return res.status(404).json({ msg: "No shop found with this code" });
    }

    // Find matching shop details
    const matchingShopDetails = adminUser.shopDetails.find(
      shop => shop.shopCode === shopCode
    );

    if (!matchingShopDetails) {
      console.log("No shop details found for shop code:", shopCode);
      return res.status(404).json({ msg: "No shop details found for this shop code" });
    }

    console.log("offerImages structure:", {
      images: matchingShopDetails.offerImages?.images || [],
      toggle: matchingShopDetails.offerImages?.offerImagesToggle
      
    });

    console.log("Found shop details:", matchingShopDetails);
    return res.status(200).json([matchingShopDetails]); // Keeping array format for consistency
  } catch (e) {
    console.error("Error fetching shop details:", e);
    return res.status(500).json({ error: e.message });
  }
});


//// fetch all farmers by address
userRouter.get("/api/shop-info/address/:address", async (req, res) => {
  try {
    const { address } = req.params;
    console.log("🔍 Searching for shops at address:", address);

    // Find all admin users with the matching address
    const adminUsers = await Admin.find({ address }).populate("shopDetails");

    if (!adminUsers || adminUsers.length === 0) {
      console.log("⚠️ No shops found at the given address:", address);
      return res.status(404).json({ msg: "No shops found at this address" });
    }

    // Extract relevant details (shopName, time, shopCode) from shopDetails
    const shopDetailsList = adminUsers.flatMap((admin) =>
      admin.shopDetails.map((shop) => ({
        shopName: shop.shopName || "N/A",
        time: shop.time || "N/A",
        shopCode: shop.shopCode || "N/A",
      }))
    );

    console.log("✅ Found shop details:", shopDetailsList);
    return res.status(200).json(shopDetailsList);
  } catch (e) {
    console.error("💥 Error fetching shop details by address:", e);
    return res.status(500).json({ error: e.message });
  }
});



userRouter.get("/api/shop/:shopCode/cart/products", auth, async (req, res) => {
  try {
    const { shopCode } = req.params;
    const { category, subCategory, productIds } = req.query;

    // Find users with the specified shopCode
    const users = await Admin.find({ shopCode });

    if (!users.length) {
      return res.status(404).json({ error: "No shop found with this shop code" });
    }

    let products = [];

    // Case 1: Fetch products based on category
    if (category) {
      users.forEach(user => {
        user.productsInfo.forEach(item => {
          if (item.product.category === category) {
            const cleanProduct = item.product.toObject ? item.product.toObject() : item.product;
            products.push(cleanProduct);
          }
        });
      });

      if (!products.length) {
        return res.status(404).json({ error: "No products found for this shop and category" });
      }

      return res.json(products);
    }

    // Case 2: Fetch products based on subCategory
    if (subCategory) {
      users.forEach(user => {
        user.productsInfo.forEach(item => {
          if (item.product.subCategory === subCategory) {
            const cleanProduct = item.product.toObject ? item.product.toObject() : item.product;
            products.push(cleanProduct);
          }
        });
      });

      if (!products.length) {
        return res.status(404).json({ error: "No products found for this shop and subCategory" });
      }

      return res.json(products);
    }

    // Case 3: Fetch products based on productIds
    if (productIds) {
      const productIdArray = productIds.split(',');
      users.forEach(user => {
        user.productsInfo.forEach(item => {
          if (productIdArray.includes(item.product._id.toString())) {
            const cleanProduct = item.product.toObject ? item.product.toObject() : item.product;
            products.push(cleanProduct);
          }
        });
      });

      if (!products.length) {
        return res.status(404).json({ error: "No products found for the given IDs and shop code" });
      }

      return res.json(products);
    }

    console.log('Fetching product for discount price -----------')
    // Case 4: Fetch top 10 products with highest discount (offer)
    const allProducts = users.reduce((acc, user) => {
      user.productsInfo.forEach(item => {
        const cleanProduct = item.product.toObject ? item.product.toObject() : item.product;
        acc.push(cleanProduct);
      });
      return acc;
    }, []);

    // Sort products by highest offer (discount percentage)
    const sortedProducts = allProducts
      .filter(p => p.price > 0 && p.discountPrice > 0) // Ensure valid price and discountPrice
      .map(p => {
        const offer = ((p.price - p.discountPrice) / p.price) * 100;
        return { ...p, offer };
      })
      .sort((a, b) => b.offer - a.offer) // Sort by offer in descending order
      .slice(0, 10); // Get top 10

    if (!sortedProducts.length) {
      return res.status(404).json({ error: "No products found with discount" });
    }

    return res.json(sortedProducts);
    
  } catch (error) {
    console.error('Error in fetching products:', error);
    res.status(500).json({ error: error.message });
  }
});


//copying / adding product to users cart by user
userRouter.post("/api/copy-product", async (req, res) => {
  try {
    const { productId, sourceUserId, targetUserId, quantity } = req.body;

    if (!mongoose.Types.ObjectId.isValid(targetUserId)) {
      return res.status(400).json({ error: "Invalid Target User ID format" });
    }

    if (!mongoose.Types.ObjectId.isValid(productId)) {
      return res.status(400).json({ error: "Invalid Product ID format" });
    }

    if (!mongoose.Types.ObjectId.isValid(sourceUserId)) {
      return res.status(400).json({ error: "Invalid Source User ID format" });
    }

    console.log(`Fetching source user with ID: ${sourceUserId}`);
    const sourceUser = await User.findById(sourceUserId);
    if (!sourceUser) {
      console.log(`Source user with ID: ${sourceUserId} not found`);
      return res.status(404).json({ error: "Source user not found" });
    }

    console.log(`Fetching product with ID: ${productId} from source user's cart`);
    const productInCart = sourceUser.cart.find(item => item.product && item.product._id.toString() === productId);
    if (!productInCart || !productInCart.product) {
      console.log(`Product with ID: ${productId} not found in source user's cart`);
      return res.status(404).json({ error: "Product not found in source user's cart" });
    }

    console.log(`Fetching target user with ID: ${targetUserId}`);
    const targetUser = await User.findById(targetUserId);
    if (!targetUser) {
      console.log(`Target user with ID: ${targetUserId} not found`);
      return res.status(404).json({ error: "Target user not found" });
    }

    // Check if the product already exists in the target user's cart
    const existingProductInTargetCart = targetUser.cart.find(item => item.product && item.product._id.toString() === productId);
    if (existingProductInTargetCart) {
      // If the product exists, update the quantity
      existingProductInTargetCart.quantity += quantity;
      console.log(`Updated product quantity in target user's cart: ${existingProductInTargetCart.quantity}`);
      await targetUser.save();
      res.json({ message: "Product quantity updated in cart", cartItem: existingProductInTargetCart });
    } else {
      // If the product doesn't exist, add it to the cart
      const cartItem = {
        product: productInCart.product,
        quantity,
      };
      targetUser.cart.push(cartItem);
      await targetUser.save();
      console.log(`Added new product to target user's cart`);
      res.json({ message: "Product added to cart successfully", cartItem });
    }
  } catch (e) {
    console.error(`Error: ${e.message}`);
    res.status(500).json({ error: e.message });
  }
});




userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address, instruction, tips, totalSave, shopId, number, note, name, location } = req.body;

    if (!cart || cart.length === 0) {
      return res.status(400).json({ msg: 'Cart is empty' });
    }

    // Default location if not provided
    const defaultLocation = {
      latitude: 0,
      longitude: 0
    };

    // Use the provided location if it's valid, otherwise use the default
    const orderLocation = (location && typeof location.latitude === 'number' && typeof location.longitude === 'number')
      ? location
      : defaultLocation;

    console.log('Using location:', orderLocation);

    // Fetch the admin user using shopId
    const admin = await Admin.findOne({ shopCode: shopId });

    if (!admin || !admin.productsInfo) {
      return res.status(404).json({ msg: 'Admin or productsInfo not found' });
    }

    let products = [];

    for (let item of cart) {
      const productId = item.product._id;
      const sourceProduct = admin.productsInfo.find(p => p.product._id.toString() === productId);

      if (!sourceProduct) {
        return res.status(404).json({ msg: `Product with id ${productId} not found in admin's productsInfo` });
      }

      if (sourceProduct.quantity < item.quantity) {
        return res.status(400).json({ msg: `${item.product.name} is out of stock!` });
      }

      sourceProduct.quantity -= item.quantity;

      products.push({
        product: {
          _id: sourceProduct.product._id,
          name: sourceProduct.product.name,
          images: sourceProduct.product.images,
          description: sourceProduct.product.description,
          price: sourceProduct.product.price,
          discountPrice: sourceProduct.product.discountPrice,
          subCategory: sourceProduct.product.subCategory,
          category: sourceProduct.product.category,
        },
        quantity: item.quantity,
      });
    }

    // Save the updated admin's productsInfo
    await admin.save();

    const order = new Order({
      products,
      totalPrice,
      shopId,
      totalSave,
      instruction,
      tips,
      number,
      note,
      name,
      location: orderLocation,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });

    await order.save();
    res.json(order);

  } catch (e) {
    console.error('Error in order creation:', e);
    res.status(500).json({ error: e.message });
  }
});



// Route to fetch products with not -null discountPrice from a user's cart
userRouter.get("/api/user/:userId/cart/products/nullDiscountPrice", auth, async (req, res) => {
  try {
      const user = await User.findById(req.params.userId).populate('cart.product');
      if (!user) {
          return res.status(404).json({ error: "User not found" });
      }

      // Filter cart products by null or zero discount price
      const cartProducts = user.cart.filter(item => item.product.discountPrice !== null || item.product.discountPrice !== 0).map(item => item.product);
      res.json(cartProducts);
  } catch (e) {
      res.status(500).json({ error: e.message });
  }
});


userRouter.get("/api/get-orders", auth, async (req, res) => {
  console.log('GET /api/get-orders - Request received');
  console.log('Headers:', req.headers);
  
  try {
    // Check if req.user exists, which should be the user ID from the auth middleware
    const userId = req.user;
    if (!userId) {
      console.log('Error: req.user is undefined. Auth middleware may not be working correctly.');
      return res.status(401).json({ error: 'User not authenticated' });
    }

    console.log('Authenticated user ID:', userId);

    // Fetch orders for the authenticated user
    console.log('Fetching orders for user:', userId);
    const orders = await Order.find({ userId: userId });

    if (orders.length === 0) {
      console.log(`No orders found for user ID: ${userId}`);
      return res.status(404).json({ message: 'No orders found for this user.' });
    }

    console.log('Orders fetched:', orders.length);
    console.log('Sending response with orders');
    console.log('--------------------------------------------------------');

    // Send the list of orders as a response
    res.status(200).json(orders);
  } catch (e) {
    console.error('Error in /api/get-orders:', e.message);
    res.status(500).json({ error: 'Server error, please try again later.' });
  }
});


////quqntity increase
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//quqntity decresse
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// userRouter.get("/api/orders/me", auth, async (req, res) => {
//   try {
//     const orders = await Order.find({ userId: req.user });
//     res.json(orders);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

//offer products
userRouter.get("/api/user/:userId/cart/products/offer", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.userId).populate('cart.product');
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Filter products based on the offer 'rain'
    const filteredProducts = user.cart
      .filter(item => item.product.offer === 'rain')
      .map(item => item.product);

    res.json(filteredProducts);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//fetch all orders based on shopcode
//fetch all orders based on shopId
userRouter.get("/admin/get-orders", auth, async (req, res) => {
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



userRouter.get("/api/get-product-by-id/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      console.log("Invalid ObjectId:", id);
      return res.status(400).json({ error: 'Invalid product ID' });
    }

    const objectId = new mongoose.Types.ObjectId(id);

    // Log all products from all admins
    const allAdmins = await Admin.find({});
    console.log("All products:");
    allAdmins.forEach(admin => {
      admin.productsInfo.forEach(productInfo => {
        console.log(`Admin: ${admin._id}, ProductInfo: ${productInfo._id}, Product: ${productInfo.product._id}, Name: ${productInfo.product.name}`);
      });
    });

    // Try to find the product across all admins
    const adminWithProduct = await Admin.findOne({ "productsInfo.product._id": objectId });

    if (!adminWithProduct) {
      console.log("No admin found with product ID:", id);
      return res.status(404).json({ error: 'Product not found' });
    }

    const productInfo = adminWithProduct.productsInfo.find(p => p.product._id.equals(objectId));

    if (!productInfo) {
      console.log("Product not found in admin's productsInfo:", id);
      return res.status(404).json({ error: 'Product not found' });
    }

    console.log("Fetched product:", productInfo.product);
    res.json(productInfo.product);
  } catch (e) {
    console.error("Error fetching product:", e);
    res.status(500).json({ error: e.message });
  }
});



userRouter.post('/api/verify-code', auth, async (req, res) => {
  const { shopCode } = req.body;

  try {
    const user = await Admin.findOne({ shopCode });

    if (!user) {
      return res.status(404).json({ error: 'Shop with this shop code not found' });
    }

    res.json({ message: 'Shop code verified successfully', user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


userRouter.post("/api/admin/rate-product", auth, async (req, res) => {
  console.log('⭐ Starting rate-product endpoint');
  console.log('📝 Request body:', req.body);
  console.log('🔑 Authenticated user:', req.user);
  try {
    const { shopCode, rating } = req.body;
    console.log(`🏪 Looking up shop with shopCode: ${shopCode}`);
    
    // Find shop by shopCode
    let shop = await Admin.findOne({ shopCode: shopCode });
    
    if (!shop) {
      console.log('❌ Shop not found');
      return res.status(404).json({ error: 'Shop not found' });
    }

    // Check if shopDetails exists and has at least one entry
    if (!shop.shopDetails || shop.shopDetails.length === 0) {
      console.log('❌ Shop details not found');
      return res.status(404).json({ error: 'Shop details not found' });
    }

    // Get the first shop details (assuming single shop details)
    const shopDetail = shop.shopDetails[0];

    // Check for existing rating
    const existingRatingIndex = shopDetail.ratings.findIndex(
      r => r.userId.toString() === req.user.toString()
    );
    
    if (existingRatingIndex !== -1) {
      console.log('🔄 Removing existing rating');
      shopDetail.ratings.splice(existingRatingIndex, 1);
    }
    
    // Create new rating
    const newRating = {
      userId: req.user,
      rating: rating
    };
    
    shopDetail.ratings.push(newRating);
    
    console.log('📊 New ratings count:', shopDetail.ratings.length);
    console.log('💾 Saving updated shop data');
    
    // Save without full validation
    shop = await shop.save({ validateBeforeSave: false });
    
    console.log('✅ Shop data saved successfully');
    console.log('📤 Sending response');
    res.json(shop);
  } catch (e) {
    console.error('❌ Error in rate-product:', e);
    console.error('📍 Stack trace:', e.stack);
    res.status(500).json({ error: e.message });
  }
});


userRouter.post("/api/admin/session-info", auth, async (req, res) => {
  try {
    const { shopCode, userSession } = req.body;
    console.log(`🏪 Looking up shop with shopCode: ${shopCode}`);
    console.log(`📦 Session data received:`, userSession);

    // Find shop by shopCode
    let admin = await Admin.findOne({ shopCode: shopCode });

    if (!admin) {
      console.log('❌ Shop not found');
      return res.status(404).json({ error: 'Shop not found' });
    }

    // Create new session document
    const newSession = {
      userId: req.user, // From auth middleware
      sessionId: userSession.sessionId,
      shopId: shopCode,
      sessionStart: new Date(),
      screensVisited: userSession.screensVisited || [],
      actions: userSession.actions || [],
      deviceInfo: userSession.deviceInfo,
      networkInfo: userSession.networkInfo
    };

    // Add session to admin's sessions array
    admin.sessions.push(newSession);
    await admin.save();

    console.log('✅ Session stored successfully');
    res.json({ message: 'Session stored successfully', session: newSession });
  } catch (e) {
    console.error('❌ Error storing session:', e);
    res.status(500).json({ error: e.message });
  }
});


module.exports=userRouter;