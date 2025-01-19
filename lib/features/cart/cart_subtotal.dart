import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/providers/shop_details_provider.dart';
import 'package:farcon/providers/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    int totalSum=0;

    // Add null checks before accessing 'quantity' and 'product'
    user.cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null && product != null )
      {
        totalSum += quantity* product?['price'] as int;
      }
      if (quantity != null &&
          product != null &&
          product['discountPrice'] != null) {
        sum += quantity * product['discountPrice'] as int;
      } else {
        sum += quantity! * product?['price'] as int;
      }
    });

    return Container(
      margin: const EdgeInsets.all(0),
      child: Row(
        children: [
          Text(
            "\₹$totalSum",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.greyTextColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 10,),
          Text(
            '\₹$sum',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CouponDiscount extends StatelessWidget {
  const CouponDiscount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;

    // Add null checks before accessing 'quantity' and 'product'
    user.cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null &&
          product != null &&
          product['discountPrice'] != null) {
        sum += quantity * product['discountPrice'] as int;
      } else {
        sum += quantity! * product?['price'] as int;
      }
    });

    double per = GlobalVariables.appliedCouponOffer!.toDouble();
    double discount = (per * sum) / 100;
    GlobalVariables.totalDiscount = discount.toInt();

    return Container(
      margin: const EdgeInsets.all(0),
      child: Row(
        children: [
          const Text(
            "",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            ' ₹${discount.toInt().abs()}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.blueTextColor
            ),
          ),
        ],
      ),
    );
  }
}

class CartTotal extends StatelessWidget {
  final tip;
  const CartTotal({Key? key, this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    int? delPrice = shopDetails!.charges?.deliveryCharges!.toInt();

    // Add null checks before accessing 'quantity' and 'product'
    user.cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null &&
          product != null &&
          product['discountPrice'] != null) {
        sum += quantity * product['discountPrice'] as int;
      } else {
        sum += quantity! * product?['price'] as int;
      }
    });

    final total = sum.toInt() -
        GlobalVariables.totalDiscount!
            .toInt() + delPrice!; // Ensure totalDiscount is used safely
    final result = '${total}';
    context.read<UserProvider>().setCartTotal(total);

    return Container(
      margin: const EdgeInsets.all(0),
      child: Row(
        children: [
          const Text(
            "",
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
            ),
          ),
          Text(
            '\₹${result}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CartTotalSaving extends StatelessWidget {
  const CartTotalSaving({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;
    
    final user = context.watch<UserProvider>().user;
    int totalSavings = 0;
    int totalSaving = 0;
    int? delivery = shopDetails!.charges?.deliveryCharges!.toInt();

    user.cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null &&
          product != null &&
          product['price'] != null &&
          product['discountPrice'] != null) {
        int price = product['price'] as int;
        int discountPrice = product['discountPrice'] as int;
        int savingsPerItem = quantity * (price - discountPrice);
        totalSavings += savingsPerItem;
      }
    });
    int? discount = GlobalVariables.totalDiscount;
    totalSaving = totalSavings + discount!;
    if(delivery == 0)
     totalSavings =  delivery! + discount + totalSaving;

    return totalSavings == 0
    ? const Text(
        '0',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Medium',
          fontWeight: FontWeight.bold,
          color: GlobalVariables.blueTextColor,
        ),
      )
    : Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              '\₹${totalSavings.abs()}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Medium',
                fontWeight: FontWeight.bold,
                color: GlobalVariables.blueTextColor,
              ),
            ),
          ],
        ),
      );

  }
}
