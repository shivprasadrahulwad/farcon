import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopez/constants/error_handeling.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/constants/utils.dart';
import 'package:shopez/local_storage/models/shopInfo.dart';
import 'package:shopez/models/charges.dart';
import 'package:shopez/models/order.dart';
import 'package:shopez/models/product.dart' as ModelsProduct;
import 'package:shopez/models/product.dart';
import 'package:shopez/models/ratings.dart';
import 'package:shopez/models/shopDetails.dart';
import 'package:shopez/models/user.dart';
import 'package:shopez/models/userSession.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:shopez/providers/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      print('Fetching products for category: $category');
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print('Processing response...');
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            print('Adding product $i to productList');
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      print('Error occurred: $e');
      CustomSnackBar.show(context, e.toString());
    }
    print('Returning productList: $productList');
    return productList;
  }

//fetch cart products with provided users id
  Future<List<Product>> fetchCartProducts({
    required BuildContext context,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      print('Fetching cart products for user: $userId');
      final Uri url = Uri.parse('$uri/api/user/$userId/cart/products');
      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print('Processing response...');
          final List<dynamic> responseData = jsonDecode(res.body);
          for (var item in responseData) {
            String jsonString = jsonEncode(item); // Convert map to JSON string
            print('Adding product to productList: $jsonString');
            productList.add(Product.fromJson(jsonString));
          }
        },
      );
    } catch (e) {
      print('Error occurred: $e');
      CustomSnackBar.show(context, e.toString());
    }
    print('Returning productList: $productList');
    return productList;
  }

  /// fetch users cart products based on user id and products ids
  Future<List<Product>> fetchShopProductsIds({
    required BuildContext context,
    required String shopcode,
    required List<String> productIds,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      print(
          'Fetching products for shop: $shopcode with product IDs: $productIds');
      final Uri url = Uri.parse('$uri/api/admin/$shopcode/products');

      final body = jsonEncode({
        'productIds': productIds,
      });

      print('Request body: $body');

      http.Response res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: body,
      );

      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(res.body);
        print('Response data: $responseData');

        for (var item in responseData) {
          try {
            productList.add(Product.fromMap(item));
          } catch (e) {
            print('Error parsing product: $e');
            print('Problematic product data: $item');
          }
        }
      } else {
        print('Server error: ${res.body}');
        CustomSnackBar.show(context, 'Server error: ${res.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching shop products: $e');
      CustomSnackBar.show(context, 'Error: ${e.toString()}');
    }

    print('Returning productList: $productList');
    return productList;
  }

  Future<List<Product>> fetchCartProductsBySubCategory({
    required BuildContext context,
    required String shopCode,
    required String subCategory,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      print(
          'Fetching cart products for shop: $shopCode and sub-category: $subCategory');

      final Uri url = Uri.parse(
          '$uri/api/shop/$shopCode/cart/products?subCategory=$subCategory');

      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        final List<dynamic> responseData = json.decode(res.body);

        for (var item in responseData) {
          Product product = Product.fromMap(item);
          productList.add(product);
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    print('Returning productList: $productList');
    return productList;
  }

////  to store it shop details provider
  static Future<void> fetchShopDetailsByCode(
    BuildContext context, String shopCode) async {
  final shopDetailsProvider =
      Provider.of<ShopDetailsProvider>(context, listen: false);

  try {
    print('🔍 Fetching shop details for shop code: $shopCode');

    final response = await http.get(
      Uri.parse('$uri/api/shop-info/$shopCode'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('📡 Response status: ${response.statusCode}');
    print('📦 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);

      if (responseData is List && responseData.isNotEmpty) {
        final Map<String, dynamic> shopData = Map<String, dynamic>.from(responseData[0]);

        // Handle optional fields
        shopData['socialLinks'] = shopData['socialLinks'] ?? [];
        if (shopData['Offertime'] != null) {
          shopData['offertime'] = shopData['Offertime'];
        }

        print('🔄 Converting response data to ShopDetails');
        final shopDetails = ShopDetails.fromMap(shopData);

        print('💾 Updating ShopDetailsProvider');
        shopDetailsProvider.setShopDetails(shopDetails);


        print('✅ Shop details successfully updated');

        if (ScaffoldMessenger.maybeOf(context) != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shop details fetched successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('⚠️ Response data is not a valid List or is empty');
        throw Exception('Invalid response format');
      }
    } else {
      final errorData = jsonDecode(response.body);
      print('❌ Error response: $errorData');
      throw Exception(errorData['msg'] ?? 'Failed to fetch shop details');
    }
  } catch (e) {
    print('💥 Error in fetchShopDetailsByCode: $e');
    print('💥 Stack trace: ${StackTrace.current}');

    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    rethrow;
  }
}


  Future<List<Product>> fetchCartProductsByShopAndCategory({
    required BuildContext context,
    required String shopCode,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    // Validate input parameters
    if (shopCode.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop code is required')),
        );
      }
      return productList;
    }

    try {
      print(
          'Fetching cart products for shop: $shopCode and category: $category');

      final Uri url = Uri.parse(
          '$uri/api/shop/${Uri.encodeComponent(shopCode)}/cart/products?category=${Uri.encodeComponent(category)}');

      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        // Only try to decode JSON if we got a 200 response
        try {
          final List<dynamic> responseData = json.decode(res.body);
          for (var item in responseData) {
            try {
              Product product = Product.fromMap(item);
              productList.add(product);
            } catch (e) {
              print('Error parsing product: $e');
              print('Problematic item: $item');
              continue;
            }
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to decode server response');
        }
      } else if (res.statusCode == 404) {
        // Handle 404 specifically
        try {
          final errorData = json.decode(res.body);
          throw Exception(errorData['error'] ?? 'Products not found');
        } catch (e) {
          // If we can't parse the error message, use a default one
          throw Exception('Products not found');
        }
      } else {
        // Handle other status codes
        try {
          final errorData = json.decode(res.body);
          throw Exception(errorData['error'] ?? 'Failed to load products');
        } catch (e) {
          throw Exception('Failed to load products');
        }
      }
    } catch (e) {
      print('Error occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    print('Returning productList: $productList');
    return productList;
  }

//// fetch products by product ids and shopcode for inof
  Future<List<Product>> fetchCartProductsByProductIds({
    required BuildContext context,
    required String shopCode,
    required List<String> productIds,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      print(
          'Fetching cart products for shop: $shopCode and product IDs: $productIds');

      // Convert productIds list to a comma-separated string
      String productIdsString = productIds.join(',');

      // Updated URL to pass productIds as a query parameter
      final Uri url = Uri.parse(
          '$uri/api/shop/$shopCode/cart/products?productIds=$productIdsString');

      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        final List<dynamic> responseData = json.decode(res.body);

        for (var item in responseData) {
          Product product = Product.fromMap(item);
          productList.add(product);
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    print('Returning productList: $productList');
    return productList;
  }

  Future<List<Product>> fetchTopDiscountProducts({
    required BuildContext context,
    required String shopCode,
  }) async {
    List<Product> productList = [];

    try {
      debugPrint('Fetching top discounted products for shop: $shopCode');

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final url = Uri.parse('$uri/api/shop/$shopCode/cart/products');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
              'Connection timed out. Please check your internet connection.');
        },
      );

      debugPrint('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        debugPrint('Found ${responseData.length} shops');

        // Process each shop's products
        for (var userData in responseData) {
          if (userData['productsInfo'] != null) {
            final List<dynamic> productsInfo = userData['productsInfo'];

            for (var productInfo in productsInfo) {
              try {
                if (productInfo['product'] != null) {
                  final productData = productInfo['product'];
                  final product = Product.fromMap(productData);

                  // Only add products with valid discounts
                  if (_isValidDiscountProduct(product)) {
                    productList.add(product);
                  }
                }
              } catch (e) {
                debugPrint('Error processing product: $e');
                continue;
              }
            }
          }
        }

        // Sort products by discount percentage (highest first)
        productList.sort((a, b) {
          double discountA = _calculateDiscountPercentage(a);
          double discountB = _calculateDiscountPercentage(b);
          return discountB.compareTo(discountA);
        });

        debugPrint('Found ${productList.length} products with valid discounts');

        // Take top 10 products
        if (productList.length > 10) {
          productList = productList.sublist(0, 10);
        }

        if (productList.isEmpty) {
          throw Exception('No products found with valid discounts');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No shop found with this shop code');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      debugPrint('Error in fetchTopDiscountProducts: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }

    return productList;
  }

  double _calculateDiscountPercentage(Product product) {
    if (product.price <= 0 ||
        product.discountPrice == null ||
        product.discountPrice! <= 0) {
      return 0.0;
    }

    return ((product.price - product.discountPrice!) / product.price) * 100;
  }

  bool _isValidDiscountProduct(Product product) {
    return product.price > 0 &&
        product.discountPrice != null &&
        product.discountPrice! > 0 &&
        product.discountPrice! < product.price;
  }

//add/ copy product to user cart
  Future<Product?> copyProductToUserCart({
    required BuildContext context,
    required String productId,
    required String sourceUserId,
    required int quantity,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product? product;

    try {
      final String targetUserId = userProvider.user.id;
      print('Source User ID: $sourceUserId');
      print('Target User ID: $targetUserId');
      print('Product ID: $productId');
      print('Quantity: $quantity');

      final Uri apiUri = Uri.parse('$uri/api/copy-product');
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      };
      final body = jsonEncode({
        'productId': productId,
        'sourceUserId': sourceUserId,
        'targetUserId': targetUserId,
        'quantity': quantity,
      });

      http.Response res = await http.post(apiUri, headers: headers, body: body);

      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body);

        if (responseData.containsKey('cartItem') &&
            responseData['cartItem'].containsKey('product')) {
          product =
              Product.fromJson(jsonEncode(responseData['cartItem']['product']));
        } else {
          CustomSnackBar.show(context, 'Unexpected response structure.');
        }
      } else {
        final error = jsonDecode(res.body)['error'];
        CustomSnackBar.show(context, error);
      }
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
    return product;
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required int totalPrice,
    required String shopId,
    required List<Map<String, String>> instruction,
    required String? tips,
    required int? totalSave,
    required String? note,
    required int number,
    required String name,
    required int paymentType,
    required Map<String, dynamic> location,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    double toDouble(dynamic value) {
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }

    final Map<String, double> defaultLocation = {
      'latitude': 0.0,
      'longitude': 0.0,
    };

    final Map<String, double> orderLocation = {
      'latitude': location['latitude'] != null
          ? (location['latitude'] as num).toDouble()
          : defaultLocation['latitude']!,
      'longitude': location['longitude'] != null
          ? (location['longitude'] as num).toDouble()
          : defaultLocation['longitude']!,
    };

    try {
      // Check for null or invalid products
      for (var item in userProvider.user.cart) {
        if (item == null ||
            item['product'] == null ||
            item['product']['_id'] == null) {
          throw Exception('Invalid product in cart');
        }
      }

      final response = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'totalPrice': totalPrice,
          'shopId': shopId,
          'totalSave': totalSave,
          'address': address,
          'instruction': instruction,
          'tips': tips,
          'note': note,
          'number': number,
          'name': name,
          'location': orderLocation, // Use the determined location
          'payment': paymentType
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          userProvider.clearCart();
          Navigator.popUntil(context, (route) => route.isFirst);
          CustomSnackBar.show(context, 'Your order has been placed!');
        },
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    print('fetchAllOrders - Start');
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // userProvider.printUserDetails(); // Print current user details

    List<Order> orderList = [];

    if (userProvider.user.id.isEmpty) {
      print('Error: User ID is empty');
      CustomSnackBar.show(context, 'User ID is not set. Please log in again.');
      return orderList;
    }

    try {
      print('Preparing to send GET request to $uri/api/get-orders');
      print('User ID: ${userProvider.user.id}');
      print('User token: ${userProvider.user.token}');

      final response = await http.get(
        Uri.parse('$uri/api/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print('Response received. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as List<dynamic>;
        print('Decoded body length: ${decodedBody.length}');

        for (var orderJson in decodedBody) {
          try {
            final order = Order.fromJson(orderJson);
            print('Processed order: ${order.id}');
            orderList.add(order);
          } catch (e) {
            print('Error processing order: $e');
          }
        }

        print('Total orders processed: ${orderList.length}');
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        CustomSnackBar.show(
            context, 'Failed to fetch orders. Please try again.');
      }
    } catch (e) {
      print('Error in fetchAllOrders: ${e.toString()}');
      CustomSnackBar.show(
          context, 'An error occurred while fetching orders: ${e.toString()}');
    }

    print('fetchAllOrders - End. Returning ${orderList.length} orders');
    return orderList;
  }

// // fetch all users oredrs
//   Future<List<Order>> fetchMyOrders({
//     required BuildContext context,
//   }) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     List<Order> orderList = [];
//     try {
//       http.Response res =
//           await http.get(Uri.parse('$uri/api/orders/me'), headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'x-auth-token': userProvider.user.token,
//       });

//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () {
//           for (int i = 0; i < jsonDecode(res.body).length; i++) {
//             orderList.add(
//               Order.fromJson(
//                 jsonEncode(
//                   jsonDecode(res.body)[i],
//                 ),
//               ),
//             );
//           }
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//     return orderList;
//   }

//// remove from cart decrese quqntity
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
    required String sourceUserId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }

//// incresse the quqnity
  Future<void> addToCart({
    required BuildContext context,
    required Product product,
    required int quantity,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }

  Future<List<Product>> fetchOfferCartProducts({
    required BuildContext context,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      print('Fetching offer products for user: $userId');
      final Uri url = Uri.parse('$uri/api/user/$userId/cart/products/offer');
      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print('Processing response...');
          final List<dynamic> responseData = jsonDecode(res.body);
          for (var item in responseData) {
            print('Raw item: $item');
            Map<String, dynamic> productMap = item as Map<String, dynamic>;
            print('Adding product to productList: $productMap');
            productList.add(Product.fromMap(productMap));
          }
        },
      );
    } catch (e) {
      print('Error occurred: $e');
      CustomSnackBar.show(context, e.toString());
    }
    print('Returning productList: $productList');
    return productList;
  }

  Future<Product?> fetchProductById(
    BuildContext context,
    String productId,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      print("Attempting to fetch product with ID: $productId");
      print("Product ID length: ${productId.length}");

      if (productId.length != 24) {
        // MongoDB ObjectIds are 24 characters long
        print(
            "Warning: Product ID doesn't appear to be a valid MongoDB ObjectId");
      }

      final response = await http.get(
        Uri.parse('$uri/api/get-product-by-id/$productId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("Parsed JSON: $responseJson");
        final product = Product.fromMap(responseJson);
        print("Fetched Product: $product");
        return product;
      } else if (response.statusCode == 404) {
        print("Product not found");
        CustomSnackBar.show(
            context, 'Product not found. Please check the product ID.');
      } else {
        final errorMessage =
            jsonDecode(response.body)['error'] ?? 'Failed to fetch product';
        throw HttpException(errorMessage);
      }
    } catch (e) {
      print("Error fetching product: $e");
      CustomSnackBar.show(
          context, 'An error occurred while fetching the product');
    }

    return null;
  }


Future<void> rateShop({
  required BuildContext context,
  required String shopCode,
  required double rating,
}) async {
  print('⭐ Starting rateShop function');
  print('📝 Input params - shopCode: $shopCode, rating: $rating');

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  print('👤 User ID from provider: ${userProvider.user.id}');
  print('🔑 Token available: ${userProvider.user.token.isNotEmpty}');

  try {
    print('📦 Creating rating data object');
    final Rating ratingData = Rating(
      userId: userProvider.user.id,
      rating: rating,
    );
    print('📦 Rating data created: ${ratingData.toJson()}');

    print('🌐 Preparing API request to: ${Uri.parse('$uri/api/admin/rate-product')}');
    final requestBody = jsonEncode({
      'shopCode': shopCode,
      'rating': rating,
      'userId': userProvider.user.id,
    });
    print('📤 Request body: $requestBody');

    print('🚀 Sending POST request...');
    http.Response res = await http.post(
      Uri.parse('$uri/api/admin/rate-product'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: requestBody,
    );
    
    print('📥 Response received');
    print('📊 Status code: ${res.statusCode}');
    print('📄 Response body: ${res.body}');

    print('🔍 Handling HTTP response');
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        print('✅ Rating submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your feedback!')),
        );
      },
    );
  } catch (e) {
    print('❌ Error occurred in rateShop:');
    print('🚨 Error details: $e');
    print('📍 Stack trace: ${StackTrace.current}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting rating: ${e.toString()}')),
    );
  }
}



// Future<void> sendSessionInfo({
//   required BuildContext context,
//   required String shopCode,
//   required UserSession userSession // Create this class to match your schema
// }) async {
//   print('📊 Starting sendSessionInfo function');
//   final userProvider = Provider.of<UserProvider>(context, listen: false);

//   try {
//     // Create session data object
//     final Map<String, dynamic> sessionInfo = {
//       'sessionId': DateTime.now().millisecondsSinceEpoch.toString(),
//       'screensVisited': userSession.screensVisited.map((visit) => {
//         'screen': visit.screen,
//         'timestamp': visit.timestamp.toIso8601String(),
//         'shopId': shopCode,
//       }).toList(),
//       'actions': userSession.actions.map((action) => {
//         'action': action,
//         'item': action.item,
//         'timestamp': action.timestamp.toIso8601String(),
//         'shopId': shopCode,
//       }).toList(),
//       'deviceInfo': {
//         'deviceType': userSession.deviceInfo.deviceType,
//         'os': userSession.deviceInfo.os,
//         'osVersion': userSession.deviceInfo.osVersion,
//       },
//       'networkInfo': {
//         'networkType': userSession.networkInfo.networkType,
//         'location': userSession.networkInfo.location,
//       },
//     };

//     print('📤 Preparing to send session data');
//     final response = await http.post(
//       Uri.parse('$uri/api/admin/session-info'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'x-auth-token': userProvider.user.token,
//       },
//       body: jsonEncode({
//         'shopCode': shopCode,
//         'userSession': sessionInfo,
//       }),
//     );

//     print('📥 Response received: ${response.statusCode}');
//     httpErrorHandle(
//       response: response,
//       context: context,
//       onSuccess: () {
//         print('✅ Session data stored successfully');
//       },
//     );
//   } catch (e) {
//     print('❌ Error in sendSessionInfo: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error storing session data: ${e.toString()}')),
//     );
//   }
// }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
