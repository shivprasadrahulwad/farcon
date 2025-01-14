import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/providers/user_provider.dart';

class LikeButton extends StatelessWidget {
  final String productId;
  final String sourceUserId;

  const LikeButton({
    Key? key,
    required this.productId,
    required this.sourceUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        bool isLiked = userProvider.isProductLiked(productId);
        print('Building LikeButton for product $productId. Is liked: $isLiked');
        return GestureDetector(
          onTap: () => _toggleLike(context, userProvider),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: GlobalVariables.greenColor,
                width: 1.5,
              ),
            ),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isLiked ? Colors.red : GlobalVariables.greenColor,
            ),
          ),
        );
      },
    );
  }

  void _toggleLike(BuildContext context, UserProvider userProvider) async {
    print('Toggle like called for product $productId');
    if (userProvider.isProductLiked(productId)) {
      print('Removing product $productId from liked');
      await userProvider.removeProductFromLiked(productId);
      // _showSnackBar(context, 'Removed from favorites');
    } else {
      print('Adding product $productId to liked');
      final homeServices = HomeServices();
      try {
        final product = await homeServices.fetchProductById(context, productId);
        if (product != null) {
          await userProvider.addProductToLiked(productId);
          // _showSnackBar(context, 'Added to favorites');
        } else {
          print('Product not found');
          _showSnackBar(context, 'Product not found');
        }
      } catch (e) {
        print('Error: ${e.toString()}');
        _showSnackBar(context, 'Error: ${e.toString()}');
      }
    }
    // No need to call printLikedProducts() here as it's not defined in our UserProvider
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}