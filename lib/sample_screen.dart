// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:shopez/local_storage/models/CartItem.dart';
// import 'package:shopez/providers/user_provider.dart';

// class CartsScreen extends StatelessWidget {
//   static const String routeName = '/carts'; // Update route name for clarity

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: FutureBuilder<Box<CartItem>>(
//         future: Hive.openBox<CartItem>('cartItems'), // Open the Hive box
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final cartBox = snapshot.data;

//           // Check if cartBox is null or empty
//           if (cartBox == null || cartBox.isEmpty) {
//             return Center(child: Text('Your cart is empty.'));
//           }

//           // Get the current shop code from UserProvider
//           final currentShopCode = userProvider.user.shopCode;

//           // Update the shop code in UserProvider if it's empty
//           if (currentShopCode!.isEmpty && userProvider.user.shopCodes.isNotEmpty) {
//             userProvider.setShopCode(userProvider.user.shopCodes.first.shopCode);
//           }

//           // Filter cart items based on the current shop code
//           final filteredCartItems = cartBox.values.where((cartItem) => cartItem.shopCode == currentShopCode).toList();

//           // Prepare the list of widgets for the Column
//           List<Widget> columnChildren = [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Current Shop Code: $currentShopCode', // Display current shop code
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ];

//           // Check if filtered items are empty
//           if (filteredCartItems.isEmpty) {
//             columnChildren.add(Center(child: Text('Your cart is empty for this shop.')));
//           } else {
//             // Add the ListView to the children if there are items
//             columnChildren.add(
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredCartItems.length,
//                   itemBuilder: (context, index) {
//                     final cartItem = filteredCartItems[index];
//                     return ListTile(
//                       title: Text(cartItem.id), // Assuming 'id' represents the product name
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Quantity: ${cartItem.quantity}'),
//                           Text('Shop Code: ${cartItem.shopCode}'), // Displaying the shop code
//                         ],
//                       ),
//                       // Assuming you have a way to get the price based on the id
//                       // trailing: Text('\$${cartItem.price ?? 0}'), // Update this according to your data model
//                       onTap: () {
//                         // Handle item tap (e.g., navigate to product details)
//                       },
//                     );
//                   },
//                 ),
//               ),
//             );
//           }

//           // Return the Column with the prepared children
//           return Column(
//             children: columnChildren,
//           );
//         },
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Total: \$${userProvider.cartTotal}'), // Total calculation remains
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/local_storage/models/CartItem.dart';
import 'package:shopez/local_storage/models/address.dart';
import 'package:shopez/models/coupon.dart';
import 'package:shopez/models/offerDes.dart';
import 'package:shopez/models/product.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:shopez/providers/user_provider.dart';
import 'package:shopez/coupon/coupon_screen.dart';

class NewCartProductScreen extends StatelessWidget {
  static const String routeName = '/sample';
  const NewCartProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Products'),
      ),
      body: ValueListenableBuilder<Box<CartItem>>(
        valueListenable: Hive.box<CartItem>('cartItems').listenable(),
        builder: (context, box, _) {
          final cartItems = box.values.toList();
          final groupedItems = _groupItemsByShopCode(cartItems);

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return ListView.builder(
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final shopCode = groupedItems.keys.elementAt(index);
              final items = groupedItems[shopCode]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Shop Code: $shopCode',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, itemIndex) {
                      final item = items[itemIndex];
                      return CartItemTile(item: item);
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<CartItem>> _groupItemsByShopCode(List<CartItem> items) {
    return groupBy(items, (CartItem item) => item.shopCode);
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return ListTile(
      title: Text(item.id), // Replace with actual product name if available
      subtitle: Text('Quantity: ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              userProvider.decrementQuantity(item.id);
              userProvider.syncCartWithHive();
            },
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              userProvider.incrementQuantity(item.id);
              userProvider.syncCartWithHive();
            },
          ),
        ],
      ),
    );
  }
}

// Helper function to group items
Map<K, List<T>> groupBy<T, K>(Iterable<T> items, K Function(T) key) {
  return items.fold<Map<K, List<T>>>(
    {},
    (Map<K, List<T>> map, T element) {
      (map[key(element)] ??= []).add(element);
      return map;
    },
  );
}




class ProductInfoScreen extends StatefulWidget {
    static const String routeName = '/fetch';

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  late Future<List<Product>> _fetchedProducts;
  HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    _fetchedProducts = _fetchProductsByShopCode(context);
  }

  Future<List<String>> fetchProductIdsByShopCode(String shopCode) async {
  final cartBox = Hive.box<CartItem>('cartItems');
  List<String> productIds = [];

  for (var cartItem in cartBox.values) {
    if (cartItem.shopCode == shopCode) {
      productIds.add(cartItem.id);
    }
  }

  return productIds;
}


  Future<List<Product>> _fetchProductsByShopCode(BuildContext context) async {
    String shopCode = GlobalVariables.shopCode;
    
    // Fetch product IDs from Hive based on shopCode
    List<String> productIds = await fetchProductIdsByShopCode(shopCode);

    // Fetch products from API based on product IDs and shopCode
    return await homeServices.fetchCartProductsByProductIds(
      context: context,
      shopCode: shopCode,
      productIds: productIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Info'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchedProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          List<Product> products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: \$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}




class ShopDetailsScreen extends StatefulWidget {
  static const String routeName = '/details';

  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial shop details (if required)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
      // Simulating shop details fetch
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(shopDetails?.shopName ?? 'Shop Details'),
      ),
      body: shopDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${shopDetails.shopName ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Number: ${shopDetails.number ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Address: ${shopDetails.address ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Address: ${shopDetails.charges ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}




class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressScreen> {
  late Box<Address> addressBox; // Declare the Hive box

  @override
  void initState() {
    super.initState();
    addressBox = Hive.box<Address>('addresses'); // Initialize the box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stored Addresses'),
      ),
      body: ValueListenableBuilder<Box<Address>>(
        valueListenable: addressBox.listenable(),
        builder: (context, box, _) {
          final addresses = box.values.toList(); // Get the addresses

          if (addresses.isEmpty) {
            return const Center(
              child: Text('No addresses stored.'),
            );
          }

          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return ListTile(
                title: Text(address.fullAddress),
                subtitle: Text(address.addressType),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // _deleteAddress(address);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add address screen or show a dialog to add a new address
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddAddressScreen()),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // void _deleteAddress(Address address) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Delete Address'),
  //         content: Text('Are you sure you want to delete this address?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               addressBox.delete(address.key); // Delete the address from the box
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Delete'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

// Note: You will also need to implement the AddAddressScreen where users can add new addresses.




// class ShopInfoScreen extends StatefulWidget {
//       static const String routeName = '/shopInfo';
//   @override
//   ShopInfoScreenState createState() => ShopInfoScreenState();
// }

// class ShopInfoScreenState extends State<ShopInfoScreen> {
//   Box<ShopInfo>? _shopBox;

//   @override
//   void initState() {
//     super.initState();
//     _initializeHive();
//   }

//   Future<void> _initializeHive() async {
//     await Hive.initFlutter();
    
//     // Register the ShopInfo adapter if it hasn’t been registered
//     if (!Hive.isAdapterRegistered(ShopInfoAdapter().typeId)) {
//       Hive.registerAdapter(ShopInfoAdapter());
//     }

//     // Open the `shopInfo` box if it’s not already open
//     if (!Hive.isBoxOpen('shopInfo')) {
//       _shopBox = await Hive.openBox<ShopInfo>('shopInfo');
//     } else {
//       _shopBox = Hive.box<ShopInfo>('shopInfo');
//     }

//     setState(() {}); // Refresh the UI once the box is open
//   }

//   @override
//   void dispose() {
//     _shopBox?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_shopBox == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Shop Information'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shop Information'),
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: _shopBox!.listenable(),
//         builder: (context, Box<ShopInfo> box, _) {
//           if (box.isEmpty) {
//             return Center(
//               child: Text('No shop details available.'),
//             );
//           }

//           return ListView.builder(
//             itemCount: box.length,
//             itemBuilder: (context, index) {
//               final shop = box.getAt(index);

//               return ListTile(
//                 title: Text(shop?.shopName ?? 'Unnamed Shop'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Shop Code: ${shop?.shopCode ?? ''}'),
//                     Text('Address: ${shop?.address ?? ''}'),
//                     Text('Number: ${shop?.number ?? ''}'),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




// class ShopInfoScreen extends StatefulWidget {
//   static const String routeName = '/shopInfo';

//   @override
//   ShopInfoScreenState createState() => ShopInfoScreenState();
// }

// class ShopInfoScreenState extends State<ShopInfoScreen> {
//   Box<ShopInfo>? _shopBox;

//   @override
//   void initState() {
//     super.initState();
//     _initializeHive();
//   }

//   Future<void> _initializeHive() async {
//     await Hive.initFlutter();

//     // Register the ShopInfo adapter if it hasn’t been registered
//     if (!Hive.isAdapterRegistered(ShopInfoAdapter().typeId)) {
//       Hive.registerAdapter(ShopInfoAdapter());
//     }

//     // Open the `shopInfo` box if it’s not already open
//     if (!Hive.isBoxOpen('shopInfo')) {
//       _shopBox = await Hive.openBox<ShopInfo>('shopInfo');
//     } else {
//       _shopBox = Hive.box<ShopInfo>('shopInfo');
//     }

//     setState(() {}); // Refresh the UI once the box is open
//   }

//   @override
//   void dispose() {
//     _shopBox?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_shopBox == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Shop Information'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shop Information'),
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: _shopBox!.listenable(),
//         builder: (context, Box<ShopInfo> box, _) {
//           if (box.isEmpty) {
//             return Center(
//               child: Text('No shop details available.'),
//             );
//           }

//           return ListView.builder(
//             itemCount: box.length,
//             itemBuilder: (context, index) {
//               final shop = box.getAt(index);

//               return ListTile(
//                 title: Text(shop?.shopName ?? 'Unnamed Shop'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Shop Code: ${shop?.shopCode ?? ''}'),
//                     Text('Address: ${shop?.address ?? ''}'),
//                     Text('Number: ${shop?.number ?? ''}'),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



// class ShopInfoScreen extends StatefulWidget {
//   static const String routeName = '/shopInfo';

//   @override
//   _ShopInfoScreenState createState() => _ShopInfoScreenState();
// }

// class _ShopInfoScreenState extends State<ShopInfoScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch shop details when the screen is initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ShopDetailsProvider>(context, listen: false)
//           .fetchShopDetails(context: context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shopDetailsProvider = Provider.of<ShopDetailsProvider>(context);
//     final shopDetailsList = shopDetailsProvider.shopDetailsList;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shop Information'),
//       ),
//       body: shopDetailsList.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: shopDetailsList.length,
//               itemBuilder: (context, index) {
//                 final shop = shopDetailsList[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Shop Name: ${shop.shopName}',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Shop Code: ${shop.shopCode}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Address: ${shop.address}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Contact Number: ${shop.number}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


class ShopDetailssScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Details'),
      ),
      body: Consumer<ShopDetailsProvider>(
        builder: (context, shopDetailsProvider, child) {
          if (shopDetailsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (shopDetailsProvider.error != null) {
            return Center(child: Text('Error: ${shopDetailsProvider.error}'));
          }

          final shopDetails = shopDetailsProvider.shopDetails;

          if (shopDetails == null) {
            return Center(child: Text('No shop details available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Shop Name: ${shopDetails.shopName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Number: ${shopDetails.number}'),
                SizedBox(height: 8),
                Text('Address: ${shopDetails.address}'),
                SizedBox(height: 8),
                Text('Shop Code: ${shopDetails.shopCode}'),
                SizedBox(height: 8),
                Text('Delivery Price: ${shopDetails.delPrice ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Last Updated: ${shopDetails.lastUpdated}'),
                SizedBox(height: 16),
                // shopDetails.coupon != null && shopDetails.coupon!.isNotEmpty
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Coupons:',
                //             style: TextStyle(
                //                 fontSize: 18, fontWeight: FontWeight.bold),
                //           ),
                //           ...shopDetails.coupon!
                //               .map((coupon) => Text(coupon.toString()))
                //               .toList(),
                //         ],
                //       )
                //     : Container(),
                // Display more fields as necessary, e.g., categories, ratings, etc.
              ],
            ),
          );
        },
      ),
    );
  }
}



class CouponsListScreen extends StatelessWidget {
  const CouponsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopDetailsProvider = Provider.of<ShopDetailsProvider>(context);
    final coupons = shopDetailsProvider.fetchLatestCoupons();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Coupons'),
        backgroundColor: Colors.green,
      ),
      body: coupons.isNotEmpty
          ? ListView.separated(
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return CouponTile(coupon: coupon);
              },
            )
          : const Center(
              child: Text(
                'No Coupons Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
    );
  }
}

// Updated CouponTile
class CouponTile extends StatelessWidget {
  final Coupon coupon;

  const CouponTile({super.key, required this.coupon});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.card_giftcard, color: Colors.white),
        ),
        title: Text(
          coupon.couponCode,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discount: ${coupon.off}%',
              style: const TextStyle(fontSize: 14),
            ),
            if (coupon.price != null)
              Text(
                'Price: \$${coupon.price!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14),
              ),
            // if (coupon.startDate != null && coupon.endDate != null)
            //   Text(
            //     'Valid: ${_formatDate(coupon.startDate)} - ${_formatDate(coupon.endDate)}',
            //     style: const TextStyle(fontSize: 12, color: Colors.grey),
            //   ),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Coupon "${coupon.couponCode}" Applied!'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Apply'),
        ),
      ),
    );
  }
}




// class SimpleOfferScreen extends StatelessWidget {
//   const SimpleOfferScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Offers'),
//         backgroundColor: GlobalVariables.blueBackground,
//       ),
//       body: Consumer<ShopDetailsProvider>(
//         builder: (context, shopProvider, child) {
//           if (shopProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final offerDes = shopProvider.shopDetails?.offerDes
//               ?.map((map) => OfferDes.fromMap(map))
//               .toList() ?? [];

//           if (offerDes.isEmpty) {
//             return const Center(
//               child: Text('No offers available'),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: offerDes.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final offer = offerDes[index];
//               return Row(
//                 children: [
//                   Icon(
//                     IconData(
//                       int.parse(offer.icon),
//                       fontFamily: 'MaterialIcons',
//                     ),
//                     color: GlobalVariables.blueTextColor,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           offer.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(offer.description),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }