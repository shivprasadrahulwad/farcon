import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/local_storage/models/CartItem.dart';
import 'package:shopez/local_storage/models/LikedProduct.dart';
import 'package:shopez/models/product.dart';
import 'package:shopez/models/user.dart';




class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
    shopCodes: [],
    likedProducts: [],
    locationStatus: false,
    shopCode: '',
    location: {'latitude': 0.0, 'longitude': 0.0},
    cartTotal: 0,
  );

  User get user => _user;


  Future<void> syncCartWithHive() async {
    final box = Hive.box<CartItem>('cartItems');
    await box.clear();

    for (var item in _user.cart) {
      final cartItem = CartItem(
        id: item['id'],
        shopCode: item['shopCode'] ?? GlobalVariables.shopCode,
        quantity: item['quantity'],
      );
      await box.put(cartItem.id, cartItem);
    }
  }
     Future<void> loadCartFromHive() async {
    final box = Hive.box<CartItem>('cartItems');
    final cartItems = box.values.toList();
    _user.cart = cartItems.map((item) => item.toMap()).toList();
    notifyListeners();
  }

  List getCartItemsForShop([String? shopCode]) {
    if (shopCode != null && shopCode.isNotEmpty) {
      return _user.cart.where((item) => item['shopCode'] == shopCode).toList();
    }
    return _user.cart;
  }

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setCartTotal(int total) {
    _user = _user.copyWith(cartTotal: total);
    notifyListeners();
  }

   int? get cartTotal {
  return _user.cartTotal;
} 


  Future<void> _syncCartWithHive() async {
    final box = Hive.box<CartItem>('cartItems');
    await box.clear();

    for (var item in _user.cart) {
      final cartItem = CartItem(
        id: item['product']['_id'],
        quantity: item['quantity'],
        shopCode: item['shopCode'],
      );
      await box.add(cartItem);
      print('Synced item with Hive: ${cartItem.id}, quantity: ${cartItem.quantity}, shop code: ${cartItem.shopCode}');
    }
  }

  void setLocation(double latitude, double longitude) {
    _user.location = {
      'latitude': latitude,
      'longitude': longitude,
    };
    notifyListeners();  
  }

  void setLocationStatus(bool status) {
    _user.locationStatus = status;
    notifyListeners();  
  }

  // int get cartTotal {
  //   double sum = 0;
  //   _user.cart.forEach((e) {
  //     final quantity = e['quantity'] as int?;
  //     final product = e['product'] as Map<String, dynamic>?;

  //     if (quantity != null && product != null && product['discountPrice'] != null) {
  //       sum += quantity * (product['discountPrice'] as int);
  //     } else if (quantity != null && product != null && product['price'] != null) {
  //       sum += quantity * (product['price'] as int);
  //     }
  //   });
  //   return sum.toInt();
  // }

  void addItemToCart(Map<String, dynamic> product) {
    final productId = product['id'];
    final shopCode = GlobalVariables.shopCode;
    final quantity = product['quantity'];

    final existingItemIndex = _user.cart.indexWhere((item) => 
      item['id'] == productId && item['shopCode'] == shopCode
    );

    if (existingItemIndex >= 0) {
      _user.cart[existingItemIndex]['quantity'] += quantity;
    } else {
      _user.cart.add({
        'id': productId,
        'shopCode': shopCode,
        'quantity': quantity,
        'product': product['product'],
      });
    }

    notifyListeners();
  }

  // Remove item from cart
  void removeItemFromCart(String productId) {
    _user.cart.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  // Decrement quantity
  void decrementQuantity(String productId) {
    final index = _user.cart.indexWhere((item) => item['id'] == productId);
    if (index != -1 && _user.cart[index]['quantity'] > 0) {
      _user.cart[index]['quantity']--;
      if (_user.cart[index]['quantity'] == 0) {
        removeItemFromCart(productId);
      } else {
        notifyListeners();
      }
    }
  }

  // Increment quantity
  void incrementQuantity(String productId) {
    final index = _user.cart.indexWhere((item) => item['id'] == productId);
    if (index != -1) {
      _user.cart[index]['quantity']++;
      notifyListeners();
    }
  }

  // Update cart quantity
  void updateCartQuantity(String productId, int quantity) {
    final existingItemIndex = _user.cart.indexWhere((item) => item['id'] == productId);
    if (existingItemIndex >= 0) {
      _user.cart[existingItemIndex]['quantity'] = quantity;
      notifyListeners();
    }
  }


  bool isInCart(String productId) {
    return _user.cart.any((item) => item['id'] == productId);
  }

  int? getCartQuantity(String productId) {
    final existingItem = _user.cart.firstWhere(
      (item) => item['id'] == productId,
      orElse: () => {'quantity': null},
    );
    return existingItem['quantity'];
  }

  // Future<void> updateCartQuantity(String productId, int quantity) async {
  //   final existingItemIndex =
  //       _user.cart.indexWhere((item) => item['id'] == productId);
  //   if (existingItemIndex >= 0) {
  //     _user.cart[existingItemIndex]['quantity'] = quantity;
  //     notifyListeners();
  //   }
    
  //   await _syncCartWithHive();
  // }

  Future<void> clearCart() async {
    _user = _user.copyWith(cart: []);
    notifyListeners();
    
    final box = Hive.box<CartItem>('cartItems');
    await box.clear();
  }

  Future<void> addProductToLiked(String productId) async {
    final box = Hive.box<LikedProduct>('likedProducts');
    final isAlreadyLiked = box.values.any((product) => product.id == productId);
    if (!isAlreadyLiked) {
      final likedProduct = LikedProduct(
        id: productId,
        likedAt: DateTime.now(),
      );
      await box.add(likedProduct);
      _user.likedProducts.add(likedProduct.toMap());
      notifyListeners();
    }
  }

  Future<void> removeProductFromLiked(String productId) async {
    final box = Hive.box<LikedProduct>('likedProducts');
    final productsToRemove =
        box.values.where((product) => product.id == productId);

    if (productsToRemove.isNotEmpty) {
      for (var product in productsToRemove) {
        await product.delete();
      }

      _user.likedProducts.removeWhere((item) => item['id'] == productId);

      notifyListeners();
    }
  }

  Future<List<Product>> fetchLikedProducts(BuildContext context) async {
    final box = Hive.box<LikedProduct>('likedProducts');
    final likedProductIds =
        box.values.map((likedProduct) => likedProduct.id).toList();

    final homeServices = HomeServices();
    List<Product> likedProducts = [];

    for (String productId in likedProductIds) {
      final product = await homeServices.fetchProductById(context, productId);
      if (product != null) {
        likedProducts.add(product);
      }
    }

    return likedProducts;
  }

  bool isProductLiked(String productId) {
    final box = Hive.box<LikedProduct>('likedProducts');
    return box.values.any((product) => product.id == productId);
  }

  Future<void> clearLikedProducts() async {
    final box = Hive.box<LikedProduct>('likedProducts');
    await box.clear();
    _user = _user.copyWith(likedProducts: []);
    notifyListeners();
  }

  void printLikedProducts() {
    print('Liked Products:');
    for (var product in _user.likedProducts) {
      print('ID: ${product['id']}, Liked At: ${product['likedAt']}');
    }
  }
}
