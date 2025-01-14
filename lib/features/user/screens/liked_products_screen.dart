// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopez/constants/global_variables.dart';
// import 'package:shopez/features/user/buttons/addCart_button.dart';
// import 'package:shopez/features/user/buttons/like_button.dart';
// import 'package:shopez/models/product.dart';
// import 'package:shopez/providers/user_provider.dart';

// class LikedProductsScreen extends StatelessWidget {
//   static const String routeName = '/like';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Padding(
//               padding: EdgeInsets.only(top: 20, left: 10),
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Colors.black,
//                 size: 25,
//               ),
//             ),
//           ),
//           title: const Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 30),
//                 child: Text(
//                   'Liked Products',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: GlobalVariables.greenColor,
//                     fontFamily: 'SemiBold',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         child: const Column(
//           children: [
//             Expanded(
//               child: LikedProductsGrid(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LikedProductsGrid extends StatelessWidget {
//   const LikedProductsGrid({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Product>>(
//       future: Provider.of<UserProvider>(context, listen: false)
//           .fetchLikedProducts(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No liked products found.'));
//         } else {
//           final likedProducts = snapshot.data!;
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.58,
//             ),
//             padding: const EdgeInsets.all(10),
//             itemCount: likedProducts.length,
//             itemBuilder: (context, index) {
//               return _buildProductCard(likedProducts[index], context);
//             },
//           );
//         }
//       },
//     );
//   }

//   Widget _buildProductCard(Product product, BuildContext context) {
//     int discount =
//         ((product.price - product.discountPrice!) / product.price * 100)
//             .abs()
//             .toInt();
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 2 - 10, // Set width of each item
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: 150,
//               width: 150,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                     child: InkWell(
//                       onTap: () {},
//                       child: Image.network(
//                         product.images.isNotEmpty ? product.images[0] : '',
//                         fit: BoxFit.cover,
//                         width: 180,
//                         height: 180,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 5,
//                     top: 0,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/offer.png',
//                           height: 40,
//                           width: 40,
//                           fit: BoxFit.cover,
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               '${discount}%',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 10,
//                               ),
//                             ),
//                             const Text(
//                               'OFF',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 10,
//                               ),
//                             ),
//                             const SizedBox(height: 3),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     right: 5,
//                     top: 5,
//                     child: LikeButton(
//                       productId: product.id!,
//                       sourceUserId: '66f911889b7e68decf9f8c0a',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   (product.quantity < 10)
//                       ? const Text(
//                           'Few quantity left',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                             fontFamily: 'SemiBold',
//                           ),
//                         )
//                       : const Text(
//                           'New Arrivals',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: GlobalVariables.greenColor,
//                             fontFamily: 'SemiBold',
//                           ),
//                         ),
//                   const Divider(),
//                   Row(
//                     children: [
//                       Text(
//                         product.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                             fontFamily: 'SemiBold'),
//                       ),
//                       const Spacer(),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: GlobalVariables.backgroundColor,
//                           border: Border.all(
//                             color: const Color.fromARGB(255, 212, 212, 212),
//                             width: 1.0,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: Text(
//                             product.offer.toString(),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromARGB(255, 41, 62, 93),
//                                 fontFamily: 'SemiBold'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   const Text(
//                     '10% off above ₹1499',
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: GlobalVariables.blueTextColor,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'SemiBold'),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const Text(
//                     '- - - - - - - - - - -',
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: GlobalVariables.blueTextColor,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Regular'),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             '₹${(product.discountPrice?.toInt()).toString()}',
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'SemiBold'),
//                           ),
//                           Stack(
//                             children: [
//                               Row(
//                                 children: [
//                                   const Text(
//                                     'MRP ',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       fontFamily: 'Regular',
//                                       color: GlobalVariables.greyTextColor,
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹${product.price?.toInt()}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontFamily: 'Regular',
//                                       color: GlobalVariables.greyTextColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Positioned(
//                                 left: 30, // Adjust this value to control the start position of the divider
//                                 right: 0,
//                                 bottom: 0,
//                                 child: Divider(
//                                   color: GlobalVariables.greyTextColor, // Choose your desired color
//                                   thickness: 1, // Adjust thickness as needed
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       // AddProduct(productId: product.id!),
//                       AddCartButton(
//                         productId: product.id!,
//                         sourceUserId: '66f911889b7e68decf9f8c0a',
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
