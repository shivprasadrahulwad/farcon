

import 'package:flutter/material.dart';
import 'package:farcon/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  
  const SearchedProduct({
    Key? key,
    required this.product, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10 ,right: 10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.images.isNotEmpty ? product.images[0] : '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Product details column
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10 ,right: 10 ,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product name
                    Row(
                      children: [
                        Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(width: 25),
                    // Product quantity
                    Text(
                      product.quantity?.toInt().toString() ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Product price and discount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${product.discountPrice?.toInt() ?? 0}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '₹${product.price.toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Regular',
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        // Add to cart button
                        // AddCartButton(
                        //   productId: product.id!,
                        //   sourceUserId: '', // Adjust as per your logic
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class SearchedOrder extends StatelessWidget {
//   final Order order;

//   const SearchedOrder({
//     Key? key,
//     required this.order,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final orderDate = DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
//     final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(orderDate);

//     return Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pushNamed(
//               context,
//               OrderDetailScreen.routeName,
//               arguments: order,
//             );
//           },
//           child: Padding(
//             padding: EdgeInsets.only(left: 10 ,top: 5  ,bottom: 5),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Order ID: ${order.id}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   formattedDate,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }