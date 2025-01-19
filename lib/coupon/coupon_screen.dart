import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/constants/utils.dart';
import 'package:farcon/providers/shop_details_provider.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/models/coupon.dart';
import 'package:farcon/models/shopDetails.dart';


// class CouponScreen extends StatefulWidget {
//   static const String routeName = '/coupon';

//   const CouponScreen({Key? key}) : super(key: key);

//   @override
//   State<CouponScreen> createState() => _CouponScreenState();
// }

// class _CouponScreenState extends State<CouponScreen> {
//   bool _isContentVisible = false;
//   int? _appliedCouponIndex;
  
  

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeCouponState();
//     });
//   }
 
//   void _initializeCouponState() {
//     if (!mounted) return;
    
//     final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
//     final shopDetails = shopProvider.shopDetails;
    
//     if (shopDetails?.coupon != null) {
//       for (int i = 0; i < shopDetails!.coupon!.length; i++) {
//         if (shopDetails.coupon![i]?.off == GlobalVariables.appliedCouponOffer) {
//           setState(() {
//             _appliedCouponIndex = i;
//           });
//           break;
//         }
//       }
//     }
//   }

//   void _toggleContentVisibility() {
//     setState(() {
//       _isContentVisible = !_isContentVisible;
//     });
//   }

  

//    void _applyCoupon(int index, double couponPrice, double sum) {
//     if (!mounted) return;

//     final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
//     final coupons = shopProvider.fetchLatestCoupons();

//     print('Attempting to apply coupon:');
//     print('- Index: $index');
//     print('- Cart Total: ₹$sum');
//     print('- Min Required: ₹$couponPrice');

//     // Validate index
//     if (index < 0 || index >= coupons.length) {
//       print('❌ Invalid index: $index');
//       CustomSnackBar.show(context, 'Invalid coupon');
//       return;
//     }

//     final coupon = coupons[index];
    
//     // Debug prints
//     print('Selected Coupon Details:');
//     print('- Code: ${coupon.couponCode}');
//     print('- Discount: ${coupon.off}%');
//     print('- Min Price: ₹${coupon.price}');

//     // Check minimum cart value
//     if (sum >= (coupon.price ?? 0)) {
//       print('✅ Applying coupon: ${coupon.couponCode}');
//       setState(() {
//         _appliedCouponIndex = index;
//         GlobalVariables.appliedCouponOffer = coupon.off?.toInt() ?? 0;
//       });

//       CustomSnackBar.show(
//         context,
//         'Coupon ${coupon.couponCode} applied: ${coupon.off?.toInt()}% off',
//       );
//     } else {
//       print('❌ Cart total insufficient');
//       CustomSnackBar.show(
//         context,
//         'Minimum cart value should be ₹${coupon.price?.toInt()}',
//       );
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<UserProvider>().user;
//     final shopProvider = Provider.of<ShopDetailsProvider>(context);
//     final shopDetails = shopProvider.shopDetails;
//     final userProvider = context.read<UserProvider>();
//     final totalPrice = userProvider.cartTotal;
    
//     final double cartTotal = totalPrice!.toDouble();

//     print('Current cart total: ₹$cartTotal');

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 1.0,
//           leading: IconButton(
//             onPressed: () => Navigator.pushNamed(context, '/user-cart-products'),
//             icon: const Padding(
//               padding: EdgeInsets.only(top: 20, left: 10),
//               child: Icon(Icons.arrow_back, color: Colors.black, size: 25),
//             ),
//           ),
//           title:const Padding(
//                 padding: EdgeInsets.only(top: 30),
//                 child: Text(
//                   'Checkout',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontFamily: 'SemiBold',
//                   ),
//                 ),
//               ),
//         ),
//       ),
//       body: shopDetails == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10),
//                     _buildCouponInput(),
//                     const SizedBox(height: 30),
//                     const Text(
//                       'Best Coupons for you',
//                       style: TextStyle(
//                         fontFamily: 'Regular',
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildCouponsList(shopDetails, cartTotal),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildCouponInput() {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.white,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Type coupon code here',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 10,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: const Text(
//               'APPLY',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Regular',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//  Widget _buildCouponsList(ShopDetails shopDetails, double cartTotal) {
//     final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
//     final coupons = shopProvider.fetchLatestCoupons();

//     print('Building coupons list:');
//     print('- Total coupons: ${coupons.length}');
//     print('- Cart total: ₹$cartTotal');

//     if (coupons.isEmpty) {
//       return const Center(
//         child: Text(
//           'No coupons available',
//           style: TextStyle(
//             fontSize: 14,
//             fontFamily: 'Regular',
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: coupons.asMap().entries.map((entry) {
//         final index = entry.key;
//         final coupon = entry.value;
        
//         return CouponCard(
//           coupon: coupon,
//           isApplied: _appliedCouponIndex == index,
//           isVisible: _isContentVisible,
//           onApply: () {
//             print('Applying coupon at index $index');
//             print('Coupon details: ${coupon.toString()}');
//             _applyCoupon(
//               index,
//               coupon.price?.toDouble() ?? 0,
//               cartTotal,
//             );
//           },
//           onToggleVisibility: _toggleContentVisibility,
//         );
//       }).toList(),
//     );
//   }
// }

// class CouponCard extends StatelessWidget {
//   final Coupon coupon;
//   final bool isApplied;
//   final bool isVisible;
//   final VoidCallback onApply;
//   final VoidCallback onToggleVisibility;

//   const CouponCard({
//     Key? key,
//     required this.coupon,
//     required this.isApplied,
//     required this.isVisible,
//     required this.onApply,
//     required this.onToggleVisibility,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     if (coupon.off == null || 
//         coupon.couponCode == null || 
//         coupon.couponCode!.isEmpty) {
//       return const SizedBox.shrink();
//     }



//     return Container(
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.lightBlue[100],
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Icon(
//                   Icons.discount,
//                   color: Colors.grey,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'GET ${coupon.off!.toInt()}% OFF',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                       fontFamily: 'SemiBold',
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Text(
//                         'Use Code ',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                           fontFamily: 'Regular',
//                         ),
//                       ),
//                       Text(
//                         coupon.couponCode!,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black87,
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: onApply,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: isApplied ? Colors.blue : GlobalVariables.greenColor,
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                     color: isApplied ? Colors.blue : Colors.white,
//                   ),
//                   child: Text(
//                     isApplied ? 'Applied' : 'Apply',
//                     style: TextStyle(
//                       color: isApplied ? Colors.white : GlobalVariables.greenColor,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'SemiBold',
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (isVisible) ...[
//             const SizedBox(height: 10),
//             Divider(color: Colors.grey[400], thickness: 1),
//             const SizedBox(height: 10),
//             _buildCouponDetails(coupon),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildCouponDetails(Coupon coupon) {
//     return Column(
//       children: [
//         _buildDetailRow(
//           'Applicable only on purchase value above ₹${coupon.price ?? 0}',
//         ),
//         const SizedBox(height: 5),
//         _buildDetailRow('Maximum discount ₹500 per transaction'),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: const BoxDecoration(
//             color: Colors.green,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 12,
//               fontFamily: 'Regular',
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }




class CouponScreen extends StatefulWidget {
  static const String routeName = '/coupon';

  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  bool _isContentVisible = false;
  int? _appliedCouponIndex;
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCouponState();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
 
  void _initializeCouponState() {
    if (!mounted) return;
    
    final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
    final shopDetails = shopProvider.shopDetails;
    
    if (shopDetails?.coupon != null) {
      for (int i = 0; i < shopDetails!.coupon!.length; i++) {
        if (shopDetails.coupon![i].off == GlobalVariables.appliedCouponOffer) {
          setState(() {
            _appliedCouponIndex = i;
          });
          break;
        }
      }
    }
  }

  void _toggleContentVisibility() {
    setState(() {
      _isContentVisible = !_isContentVisible;
    });
  }

  bool _isValidCoupon(Coupon coupon) {
    final now = DateTime.now();
    
    if (coupon.startDate == null || coupon.endDate == null) {
      return false;
    }
    
    try {
      final startDate = DateTime.parse(coupon.startDate!);
      final endDate = DateTime.parse(coupon.endDate!);
      
      final currentTimeInMinutes = now.hour * 60 + now.minute;
      final startTimeInMinutes = coupon.startTimeMinutes?.toInt() ?? 0;
      final endTimeInMinutes = coupon.endTimeMinutes?.toInt() ?? 0;
      
      bool isDateValid = now.isAfter(startDate) && now.isBefore(endDate);
      
      bool isTimeValid = true;
      if (endTimeInMinutes > startTimeInMinutes) {
        isTimeValid = currentTimeInMinutes >= startTimeInMinutes && 
                     currentTimeInMinutes <= endTimeInMinutes;
      } else {
        isTimeValid = currentTimeInMinutes >= startTimeInMinutes || 
                     currentTimeInMinutes <= endTimeInMinutes;
      }
      
      return isDateValid && isTimeValid;
    } catch (e) {
      debugPrint('Error validating coupon: $e');
      return false;
    }
  }

  void _applyCoupon(int index, double couponPrice, double sum) {
    if (!mounted) return;

    final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
    final coupons = shopProvider.fetchLatestCoupons();

    if (index < 0 || index >= coupons.length) {
      _showSnackBar('Invalid coupon');
      return;
    }

    final coupon = coupons[index];
    
    if (!_isValidCoupon(coupon)) {
      _showSnackBar('This coupon is not valid at the current time');
      return;
    }

    if (sum >= (coupon.price ?? 0)) {
      setState(() {
        _appliedCouponIndex = index;
        GlobalVariables.appliedCouponOffer = coupon.off?.toInt() ?? 0;
      });

      _showSnackBar('Coupon ${coupon.couponCode} applied: ${coupon.off?.toInt()}% off');
    } else {
      _showSnackBar('Minimum cart value should be ₹${coupon.price?.toInt()}');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  Widget _buildValidityStatus(Coupon coupon) {
    final isValid = _isValidCoupon(coupon);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isValid ? 'Active' : 'Expired',
        style: TextStyle(
          color: isValid ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCouponInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Type coupon code here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Implement manual coupon code validation
              final code = _couponController.text.trim();
              if (code.isEmpty) {
                _showSnackBar('Please enter a coupon code');
                return;
              }
              // Add your coupon validation logic here
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'APPLY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;
    final cartTotal = userProvider.cartTotal?.toDouble() ?? 0.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user-cart-products'),
            icon: const Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Icon(Icons.arrow_back, color: Colors.black, size: 25),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'SemiBold',
              ),
            ),
          ),
        ),
      ),
      body: shopDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildCouponInput(),
                    const SizedBox(height: 30),
                    const Text(
                      'Best Coupons for you',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCouponsList(shopDetails, cartTotal),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCouponsList(ShopDetails shopDetails, double cartTotal) {
    final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
final coupons = shopProvider.fetchLatestCoupons();


    if (coupons.isEmpty) {
      return const Center(
        child: Text(
          'No coupons available',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Regular',
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return CouponCard(
          coupon: coupon,
          isApplied: _appliedCouponIndex == index,
          isVisible: _isContentVisible,
          onApply: () => _applyCoupon(
            index,
            coupon.price?.toDouble() ?? 0,
            cartTotal,
          ),
          onToggleVisibility: _toggleContentVisibility,
        );
      },
    );
  }
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final bool isApplied;
  final bool isVisible;
  final VoidCallback onApply;
  final VoidCallback onToggleVisibility;

  const CouponCard({
    Key? key,
    required this.coupon,
    required this.isApplied,
    required this.isVisible,
    required this.onApply,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coupon.off == null || 
        coupon.couponCode == null || 
        coupon.couponCode!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onToggleVisibility,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.discount,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GET ${coupon.off!.toInt()}% OFF',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Use Code ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'Regular',
                              ),
                            ),
                            Text(
                              coupon.couponCode!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApplied ? Colors.blue : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: isApplied ? Colors.blue : GlobalVariables.greenColor,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      isApplied ? 'Applied' : 'Apply',
                      style: TextStyle(
                        color: isApplied ? Colors.white : GlobalVariables.greenColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              if (isVisible) ...[
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                _buildCouponDetails(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponDetails() {
    return Column(
      children: [
        _buildDetailRow(
          'Applicable only on purchase value above ₹${coupon.price ?? 0}',
        ),
        const SizedBox(height: 5),
        _buildDetailRow('Maximum discount ₹500 per transaction'),
      ],
    );
  }

  Widget _buildDetailRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Regular',
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

