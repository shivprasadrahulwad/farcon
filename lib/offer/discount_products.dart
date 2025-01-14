import 'package:flutter/material.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/buttons/addCart_button.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/models/product.dart';

class DiscountProducts extends StatefulWidget {
  final String shopCode;
  final String category;

  const DiscountProducts({
    Key? key,
    required this.shopCode,
    required this.category,
  }) : super(key: key);

  @override
  State<DiscountProducts> createState() => _DiscountProductsState();
}

class _DiscountProductsState extends State<DiscountProducts> {
  List<Product> products = [];
  List<Product> topDiscountProducts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProducts();
    });
  }

  // Calculate discount percentage for a product
  double calculateDiscountPercentage(Product product) {
    return ((product.price - product.discountPrice!) / product.price * 100).abs();
  }

  // Sort and get top 10 products with highest discount
  void sortProductsByDiscount() {
    products.sort((a, b) {
      double discountA = calculateDiscountPercentage(a);
      double discountB = calculateDiscountPercentage(b);
      return discountB.compareTo(discountA); // Sort in descending order
    });
    
    // Get top 10 products or all if less than 10
    topDiscountProducts = products.take(3).toList(); 
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts =
          await HomeServices().fetchCartProductsByShopAndCategory(
        context: context,
        shopCode: widget.shopCode,
        category: widget.category,
      );
      setState(() {
        products = fetchedProducts;
        sortProductsByDiscount(); // Sort and get top discount products
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(child: Text('Error: $errorMessage'))
          else if (topDiscountProducts.isEmpty)
            const Center(child: Text('No products available'))
          else
            DiscountProductsList(products: topDiscountProducts),
        ],
      ),
    );
  }
}

class DiscountProductsList extends StatelessWidget {
  final List<Product> products;

  const DiscountProductsList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Text(
              'Top Discounted Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.blueTextColor,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 310,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                int discount =
                    ((product.price - product.discountPrice!) / product.price * 100)
                        .abs()
                        .toInt();
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Image.network(
                                  product.images.isNotEmpty
                                      ? product.images[0]
                                      : '',
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 5,
                              top: 0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/offer.png',
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '$discount%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const Text(
                                        'OFF',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: GlobalVariables.backgroundColor,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 212, 212, 212),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      product.offer.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 41, 62, 93),
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'SemiBold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '10% off above ₹149',
                              style: TextStyle(
                                fontSize: 12,
                                color: GlobalVariables.blueTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SemiBold',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              '- - - - - - - - - - -',
                              style: TextStyle(
                                fontSize: 12,
                                color: GlobalVariables.blueTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${product.discountPrice?.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          'MRP',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontFamily: 'Regular',
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '₹${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'Regular',
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(width: 5),
                                AddCartButton(
                                  productId: product.id!,
                                  sourceUserId: '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}