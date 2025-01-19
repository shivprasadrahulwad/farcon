
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/user/services/home_services.dart';
import 'package:farcon/local_storage/models/CartItem.dart';
import 'package:farcon/providers/user_provider.dart';



class AddCartButton extends StatefulWidget {
  final String productId;
  final String sourceUserId;

  const AddCartButton({
    Key? key,
    required this.productId,
    required this.sourceUserId,
  }) : super(key: key);

  @override
  _AddCartButtonState createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        bool isInCart = userProvider.isInCart(widget.productId);
        int quantity = isInCart ? userProvider.getCartQuantity(widget.productId) ?? 0 : 0;

        return isInCart && quantity > 0
            ? Container(
                margin: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: GlobalVariables.greenColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: GlobalVariables.greenColor,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => decreaseQuantity(context, userProvider),
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.remove,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: GlobalVariables.greenColor,
                                width: 1.5,
                              ),
                              color: GlobalVariables.greenColor,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              width: 27,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Medium',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => increaseQuantity(context, userProvider),
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () => _addToCart(context, userProvider, widget.productId, widget.sourceUserId, 1),
                child: Container(
                  width: 60,
                  height: 30,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: GlobalVariables.greenColor),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'ADD',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SemiBold',
                      color: GlobalVariables.greenColor,
                    ),
                  ),
                ),
              );
      },
    );
  }

  void increaseQuantity(BuildContext context, UserProvider userProvider) {
    setState(() {
      if (userProvider.isInCart(widget.productId)) {
        userProvider.incrementQuantity(widget.productId);
      } else {
        _addToCart(context, userProvider, widget.productId, widget.sourceUserId, 1);
      }
    });
  }

  void decreaseQuantity(BuildContext context, UserProvider userProvider) {
    setState(() {
      if (userProvider.isInCart(widget.productId) && userProvider.getCartQuantity(widget.productId)! > 0) {
        userProvider.decrementQuantity(widget.productId);
      }
    });
  }

  void _addToCart(BuildContext context, UserProvider userProvider, String productId, String sourceUserId, int quantity) async {
    try {
      final homeServices = HomeServices();
      final product = await homeServices.fetchProductById(context, productId);
      if (product != null) {
        setState(() {
          userProvider.
          addItemToCart({
            'id': productId,
            'quantity': quantity,
            'product': product.toMap(),
          });
        });
      } else {
        showSnackBar(context, 'Product not found');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


