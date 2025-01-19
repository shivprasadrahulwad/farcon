import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farcon/features/user/screens/shop_screen.dart';
import 'package:farcon/models/category.dart';
import 'package:farcon/providers/shop_details_provider.dart';


class GroceryCategories extends StatelessWidget {
  final String shopCode;

  const GroceryCategories({Key? key, required this.shopCode}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, Category category) {
    Navigator.pushNamed(
      context,
      FshopScreen.routeName,
      arguments: {
        'category': {
          'title': category.categoryName,
          'categoryImage': category.categoryImage,
          'sub-title': category.subcategories,
          '_id': category.id,
        },
        'shopCode': shopCode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;

    // Early return if shop details or categories are null
    if (shopDetails?.categories == null || shopDetails!.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No categories available',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final List<Category> categories = shopDetails.categories;
    final List<List<Widget>> categoryRows = [];
    final chunkSize = 3;

    // Calculate how many complete rows we need
    final numberOfRows = (categories.length / chunkSize).ceil();

    // Create rows
    for (var rowIndex = 0; rowIndex < numberOfRows; rowIndex++) {
      final startIndex = rowIndex * chunkSize;
      final endIndex = min(startIndex + chunkSize, categories.length);
      final List<Widget> rowChildren = [];

      for (var i = startIndex; i < endIndex; i++) {
        final category = categories[i];
        rowChildren.add(
          Expanded(
            child: GestureDetector(
              onTap: () => navigateToCategoryPage(context, category),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        category.categoryImage ?? '',
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      )
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Medium'
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Add spacing between items
        if (i < endIndex - 1) {
          rowChildren.add(const SizedBox(width: 10));
        }
      }

      // If the row is not complete, add empty expanded widgets to maintain spacing
      while (rowChildren.length < (chunkSize * 2 - 1)) {
        rowChildren.add(Expanded(child: Container()));
        if (rowChildren.length < (chunkSize * 2 - 1)) {
          rowChildren.add(const SizedBox(width: 10));
        }
      }

      categoryRows.add(rowChildren);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: categoryRows.map((rowChildren) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          );
        }).toList(),
      ),
    );
  }
}