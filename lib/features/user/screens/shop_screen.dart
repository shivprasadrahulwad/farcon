import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/buttons/addCart_button.dart';
import 'package:shopez/features/user/buttons/like_button.dart';
import 'package:shopez/features/user/screens/product_details._screen.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/models/product.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:shopez/providers/user_provider.dart';

class FshopScreen extends StatefulWidget {
  static const String routeName = '/shopScreen';
  final Map<String, dynamic> category;
  final String shopCode;

  const FshopScreen({Key? key, required this.category, required this.shopCode})
      : super(key: key);

  @override
  _FshopScreenState createState() => _FshopScreenState();
}

class _FshopScreenState extends State<FshopScreen> {
  int _page = 0;
  String _selectedSortOption = 'Default';
  List<Product>? products;
  bool _isFloatingContainerOpen = false; // Track floating container state
  final HomeServices homeServices = HomeServices();

  List<Map<String, dynamic>> carts = [];

  List<dynamic> get subcategories {
    try {
      return widget.category['sub-title'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort by',
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.grey),
                  _buildSortOption(setState, 'Default'),
                  _buildSortOption(setState, 'Price (Low to High)'),
                  _buildSortOption(setState, 'Price (High to Low)'),
                  _buildSortOption(setState, 'Popular'),
                  _buildSortOption(setState, 'Discount (High to Low)'),
                  GestureDetector(
                    onTap: () {
                      _sortProducts();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: GlobalVariables
                            .greenColor, // You can change the color as needed
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(StateSetter setState, String option) {
    return Row(
      children: [
        Radio<String>(
          value: option,
          groupValue: _selectedSortOption,
          onChanged: (value) {
            setState(() {
              _selectedSortOption = value!;
            });
          },
        ),
        Text(option,
            style: const TextStyle(
                fontFamily: 'Regular',
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _sortProducts() {
    if (products == null) return;

    setState(() {
      switch (_selectedSortOption) {
        case 'Price (Low to High)':
          products!
              .sort((a, b) => a.discountPrice!.compareTo(b.discountPrice!));
          break;
        case 'Price (High to Low)':
          products!
              .sort((a, b) => b.discountPrice!.compareTo(a.discountPrice!));
          break;
        case 'Popular':
          // Assuming there's a 'popularity' or 'sales' field. If not, you might need to add one.
          // products!.sort((a, b) => b.popularity.compareTo(a.popularity));
          break;
        case 'Discount (High to Low)':
          products!.sort((a, b) {
            double discountA =
                ((a.price - a.discountPrice!) / a.price * 100).abs();
            double discountB =
                ((b.price - b.discountPrice!) / b.price * 100).abs();
            return discountB.compareTo(discountA);
          });
          break;
        default:
          // 'Default' sorting. You might want to define what this means for your app.
          // For now, let's sort by product ID as an example.
          products!.sort((a, b) => a.id!.compareTo(b.id!));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSubCategoryProducts();
    carts = context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
  }

  double calculateCartTotal(List<Map<String, dynamic>> cart) {
    int sum = 0;
    double require = 0;
    double deliveryPrice = 150;
    cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null && product != null) {
        final discountPrice = product['discountPrice'] as int?;
        final price = product['price'] as int;
        sum += quantity * (discountPrice ?? price);
        require = deliveryPrice - sum;
        require = (sum / deliveryPrice).toDouble();

        if (require > 1) {
          require = 1;
        }
      }
    });
    return require;
  }

  int addMore(List<Map<String, dynamic>> cart) {
    int sum = 0;
    int rem = 0;
    int require = 0;
    int deliveryPrice = 150;
    cart.forEach((e) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;

      if (quantity != null && product != null) {
        final discountPrice = product['discountPrice'] as int?;
        final price = product['price'] as int;
        // sum += quantity * (discountPrice ?? price);
        sum += quantity * (discountPrice!);
        if (sum > deliveryPrice) {
          rem = 0;
        } else {
          rem = deliveryPrice - sum;
        }
      }
    });
    return rem;
  }

  void increaseQuantity(Product product) {
    homeServices
        .addToCart(
      context: context,
      product: product,
      quantity: 1, // Assuming you add one item at a time
    )
        .then((_) {
      setState(() {
        _isFloatingContainerOpen =
            true; // Ensure the floating container is open after adding an item
      });
    }).catchError((error) {
      // Handle error gracefully
      print('Error adding to cart: $error');
    });
  }

  void decreaseQuantity(Product product) {
    homeServices
        .removeFromCart(
      context: context,
      product: product,
      sourceUserId: '6652bfc64e869c021acf688c',
    )
        .then((_) {
      setState(() {
        if (context.read<UserProvider>().user.cart.isEmpty) {
          _isFloatingContainerOpen =
              false; // Close the floating container if the cart is empty
        }
      });
    }).catchError((error) {
      // Handle error gracefully
      print('Error removing from cart: $error');
    });
  }

  Future<void> fetchSubCategoryProducts() async {
    if (subcategories.isEmpty) return;

    try {
      products = await homeServices.fetchCartProductsBySubCategory(
        context: context,
        shopCode: widget.shopCode,
        subCategory:
            subcategories[_page], // Make sure this matches your API expectation
      );
      setState(() {});
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        products = [];
      });
    }
  }

  // Widget _buildProductList() {
  //   if (products == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else if (products!.isEmpty) {
  //     return const Center(child: Text('No products found.'));
  //   } else {
  //     return GridView.builder(
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 5,
  //         mainAxisSpacing: 5,
  //         childAspectRatio: 0.56,
  //       ),
  //       padding: const EdgeInsets.all(0),
  //       itemCount: products!.length,
  //       itemBuilder: (context, index) {
  //         return _buildProductCard(products![index]);
  //       },
  //     );
  //   }
  // }

  Widget _buildProductList() {
    if (products != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              // Remove childAspectRatio to allow automatic height
              mainAxisExtent: MediaQuery.of(context).size.height *
                  0.4, // Approximate initial height
            ),
            padding: const EdgeInsets.all(0),
            itemCount: products!.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products![index]);
            },
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildProductCard(Product product) {
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    // final shopDetails = shopProvider.shopDetailsList[0];
    int discount =
        ((product.price - product.discountPrice!) / product.price * 100)
            .abs()
            .toInt();
    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 -
              10, // Set width of each item
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                width: 180,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          ////////////////////////
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '',
                          fit: BoxFit.cover,
                          width: 180,
                          height: 180,
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
                                '${discount}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const Text(
                                'OFF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: LikeButton(
                        productId: product.id,
                        sourceUserId: '66f911889b7e68decf9f8c0a',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (product.quantity < 10)
                        ? const Text(
                            'Few quantity left',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontFamily: 'SemiBold',
                            ),
                          )
                        : Container(
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
                                    fontFamily: 'SemiBold'),
                              ),
                            ),
                          ),
                    // const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'SemiBold'),
                        ),
                        // const Spacer(),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     color: GlobalVariables.backgroundColor,
                        //     border: Border.all(
                        //       color: const Color.fromARGB(255, 212, 212, 212),
                        //       width: 1.0,
                        //     ),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(2),
                        //     child: Text(
                        //       'No offer',
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //       style: const TextStyle(
                        //           fontSize: 10,
                        //           fontWeight: FontWeight.bold,
                        //           color: Color.fromARGB(255, 41, 62, 93),
                        //           fontFamily: 'SemiBold'),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // ignore: prefer_const_constructors
                    Text(
                      'offer des',
                      style: const TextStyle(
                          fontSize: 12,
                          color: GlobalVariables.blueTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SemiBold'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      '- - - - - - - - - - -',
                      style: TextStyle(
                          fontSize: 12,
                          color: GlobalVariables.blueTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '₹${(product.discountPrice?.toInt()).toString()}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SemiBold'),
                            ),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'MRP ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.greyTextColor,
                                      ),
                                    ),
                                    Text(
                                      '₹${product.price.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.greyTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                  left:
                                      30, // Adjust this value to control the start position of the divider
                                  right: 0,
                                  bottom: 0,
                                  child: Divider(
                                    color: GlobalVariables
                                        .greyTextColor, // Choose your desired color
                                    thickness: 1, // Adjust thickness as needed
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // AddProduct(productId: product.id!),
                        AddCartButton(
                          productId: product.id,
                          sourceUserId: '66f911889b7e68decf9f8c0a',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
      fetchSubCategoryProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final carts = context.watch<UserProvider>().user.cart;
    final carts =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    final percent = calculateCartTotal(carts);
    final rem = addMore(carts);

    // Toggle floating container state based on cart length
    if (carts.length >= 1 && !_isFloatingContainerOpen) {
      _isFloatingContainerOpen = true;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '${widget.category['title']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: GlobalVariables.greenColor,
                    fontFamily: 'SemiBold',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50, // Set a fixed height for the scrollable row
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Color pickerColor = Colors.blue; // Initial color

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Corner radius of 20
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16), // Padding around the content
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Wraps the content height
                                  children: [
                                    const Text(
                                      'Pick a color',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    BlockPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: (Color color) {
                                        // Do something with the selected color
                                        pickerColor = color;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Text color set to black
                                            fontSize: 16, // Font size set to 16
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(Icons.sort, size: 15),
                              SizedBox(width: 5),
                              Text(
                                'Filters',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sort Container
                    GestureDetector(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(Icons.sort, size: 15),
                              SizedBox(width: 5),
                              Text(
                                'Sort',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sub-title Row, which is scrollable
                    Row(
                      children: List.generate(
                        subcategories.length,
                        (index) => GestureDetector(
                          onTap: () => updatePage(index),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            decoration: BoxDecoration(
                              color: _page == index
                                  ? const Color.fromARGB(255, 243, 253, 244)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    _page == index ? Colors.green : Colors.grey,
                              ),
                            ),
                            child: Text(
                              subcategories[index].toString(),
                              style: TextStyle(
                                color: _page == index
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildProductList(), // List of products
            ),
            if (_isFloatingContainerOpen)
              Container(
                height: 130,
                color: GlobalVariables.backgroundColor,
              )
          ],
        ),
      ),
    );
  }
}
