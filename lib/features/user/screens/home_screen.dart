// ignore_for_file: dead_code

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/cart/cart_screen.dart';
import 'package:farcon/features/user/screens/categories_screen.dart';
import 'package:farcon/features/user/screens/custom_container_banner.dart';
import 'package:farcon/features/user/screens/horizontal_products.dart';
import 'package:farcon/features/user/search/screens/search_screen.dart';
import 'package:farcon/features/user/services/home_services.dart';
import 'package:farcon/location/address_bottom_sheet.dart';
import 'package:farcon/location/location_popup.dart';
import 'package:farcon/location/set_location.dart';
import 'package:farcon/models/category.dart';
import 'package:farcon/models/product.dart';
import 'package:farcon/models/userSession.dart';
import 'package:farcon/notification/notifications.dart';
import 'package:farcon/offer/discount_products.dart';
import 'package:farcon/providers/shop_details_provider.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/ratings/shop_rating_popup.dart';
import 'package:farcon/sample_screen.dart';
import 'package:farcon/session/sessio_batch_manager.dart';
import 'package:farcon/widgets/horizontal_line.dart';
import 'package:farcon/widgets/sliding_banner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:farcon/features/user/screens/shop_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final String shopCode;
  const HomeScreen({Key? key, required this.shopCode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentHint = 'Search products';
  late Stream<String> _hintStream;
  late StreamSubscription<String> _hintSubscription;
  bool _isItemDetailsOpen = false;
  List<Product>? products;
  bool _isFloatingContainerOpen = false; // Track floating container state
  final HomeServices homeServices = HomeServices();
  final _controller = PageController();
  Map<String, List> categoryProducts = {};
  Map<String, bool> isLoadingMap = {};
  String savedAddress = GlobalVariables.address;

  void navigateToSearchScreen() {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
    );
  }

  void navigateToCategoryPage(
      BuildContext context, Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      FshopScreen.routeName,
      arguments: {
        'category': category,
        'shopCode': '123456',
      },
    ); // Passing category details and shopCode when navigating
    print('---------catgory ${category}');
    print('---------catgory shopcode ${widget.shopCode}');
  }

  List<Map<String, dynamic>> carts = [];

  Future<void> fetchAllCategoryProducts() async {
    // for (var categoryData in GlobalVariables.categoryImages) {
    //   String categoryTitle = categoryData['title'] ?? '';
    //   // Set loading true for this category
    //   setState(() {
    //     isLoadingMap[categoryTitle] = true;
    //   });
    final shopDetailsProvider =
        Provider.of<ShopDetailsProvider>(context, listen: false);

    // Get categories from ShopDetails
    final categories = shopDetailsProvider.shopDetails?.categories ?? [];

    for (var category in categories) {
      String categoryTitle = category.categoryName;

      // Set loading true for this category
      setState(() {
        isLoadingMap[categoryTitle] = true;
      });

      try {
        final fetchedProducts =
            await HomeServices().fetchCartProductsByShopAndCategory(
          context: context,
          shopCode: GlobalVariables.shopCode,
          category: categoryTitle,
        );

        setState(() {
          categoryProducts[categoryTitle] = fetchedProducts;
          isLoadingMap[categoryTitle] = false; // Loading finished
        });
      } catch (e) {
        setState(() {
          isLoadingMap[categoryTitle] = false;
          // Handle errors if needed
        });
      }
    }
  }

  @override
  void initState() {
    // checkForNotification();
    print('initializeSessionTracking');
    // initializeSessionTracking(context);
    // startSession('123456', widget.shopCode);
    _hintStream = hintStream();
    Provider.of<ShopDetailsProvider>(context, listen: false)
        .initializeShopDetails(context);
    fetchAllCategoryProducts();
    GlobalVariables.setAddress('');
    // carts = context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    final shopProvider =
        Provider.of<ShopDetailsProvider>(context, listen: false);
    if (carts.isNotEmpty) {
      _isFloatingContainerOpen = true;
    }

    super.initState();
    // logScreenVisit('HomeScreen');
  }

  @override
  void dispose() {
    _hintSubscription.cancel();
    // endSession(context);
    super.dispose();
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
        carts =
            context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
        _isFloatingContainerOpen = true;
      });
    });
  }

  void decreaseQuantity(Product product) {
    homeServices
        .removeFromCart(
      context: context,
      product: product,
      sourceUserId: '',
    )
        .then((_) {
      setState(() {
        carts =
            context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
        if (carts.isEmpty) {
          _isFloatingContainerOpen = true;
        }
      });
    });
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

  Stream<String> hintStream() async* {
    while (true) {
      yield 'Search "Ghagra"';
      await Future.delayed(const Duration(seconds: 2));
      yield 'Search "Suit"';
      await Future.delayed(const Duration(seconds: 2));
      yield 'Search "Lehenga"';
      await Future.delayed(const Duration(seconds: 2));
      yield 'Search "Sherwani"';
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationService =
        Provider.of<NotificationService>(context, listen: false);
    final cart = context.watch<UserProvider>().user.cart;
    final userProvider = Provider.of<UserProvider>(context);
    final carts =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    final percent = calculateCartTotal(carts);
    final rem = addMore(carts);
    // if (!_isFloatingContainerOpen || cart.length > 0) {
    //   setState(() {
    //     _isFloatingContainerOpen = true;
    //   });
    // }
    if (cart.length > 0) {
      setState(() {
        _isFloatingContainerOpen = true;
      });
    }
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;
    final List<Category> categories = shopDetails!.categories;
    double averageRatings = shopProvider.averageRating;
    // final

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/welcome.png'), // Local image
                    fit:
                        BoxFit.cover, // Adjust image fit (cover, contain, etc.)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Ready in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SemiBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              // const Text(
                                              //   "8 minutes",
                                              //   style: TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 25,
                                              //     fontFamily: 'SemiBold',
                                              //   ),
                                              // ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '',
                                                      style: TextStyle(
                                                        fontFamily: 'ExtraBold',
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${shopDetails.shopName} ',
                                                      style: const TextStyle(
                                                        fontFamily: 'ExtraBold',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: const Icon(
                                                        Icons.trending_up,
                                                        color: Colors.green,
                                                        size: 10,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 3),
                                                      child: Text(
                                                        'High demand',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              AddressBottomSheet(context);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const LocationPopup()),
                                              // );
                                            },
                                            child: Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: ' HOME - ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'SemiBold',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${shopDetails!.address} ',
                                                        style: const TextStyle(
                                                          fontFamily: 'Medium',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Icon(
                                                    Icons.arrow_drop_down)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/account');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () => navigateToSearchScreen(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black38, width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 0.1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          currentHint,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // if (Provider.of<ShopDetailsProvider>(context)
                      //         .shopDetails
                      //         ?.offerImages?['images'] ==
                      //     null)
                      // Center(
                      //   child: Container(
                      //     height: 150,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     clipBehavior: Clip.antiAlias,
                      //     child: Image.network(
                      //       'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720875098/vegetables/swya6iwpohlynuq1r9td.gif',
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),

                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 70, right: 10),
                        child: CustomContainerBanner(
                          imageUrl:
                              'https://res.cloudinary.com/dybzzlqhv/image/upload/v1727670900/fmvqjdmtzq5chmeqsyhb.png',
                          titleText: 'Flat ₹50 OFF',
                          subtitleText: 'On first order above ₹299',
                        ),
                      ),

                      // SizedBox(height: 60,),
                      // const Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: 'Enjoy ',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       TextSpan(
                      //         text: 'Free Delivery!',
                      //         style: TextStyle(
                      //             color: GlobalVariables.greenColor,
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      // const Text(
                      //   'ON YOUR FIRST ORDER',
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // if (Provider.of<ShopDetailsProvider>(context)
                      //         .shopDetails
                      //         ?.offerImages?['images'] !=
                      //     null)
                      //   CarouselSlider(
                      //     items: (Provider.of<ShopDetailsProvider>(context)
                      //             .shopDetails
                      //             ?.offerImages?['images'] as List<dynamic>?)
                      //         ?.map((imageUrl) => Builder(
                      //               builder: (BuildContext context) => Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: 10),
                      //                 child: Container(
                      //                   width:
                      //                       MediaQuery.of(context).size.width,
                      //                   child: ClipRRect(
                      //                     borderRadius: BorderRadius.circular(
                      //                         15), // Set corner radius
                      //                     child: Image.network(
                      //                       imageUrl
                      //                           .toString(), // Convert to String explicitly
                      //                       fit: BoxFit.cover,
                      //                       height: 200,
                      //                       errorBuilder:
                      //                           (context, error, stackTrace) {
                      //                         return Container(
                      //                           height: 200,
                      //                           color: Colors.grey.shade200,
                      //                           child: const Center(
                      //                             child: Text(
                      //                                 'Failed to load image'),
                      //                           ),
                      //                         );
                      //                       },
                      //                       loadingBuilder: (context, child,
                      //                           loadingProgress) {
                      //                         if (loadingProgress == null)
                      //                           return child;
                      //                         return Container(
                      //                           height: 200,
                      //                           color: Colors.grey.shade100,
                      //                           child: const Center(
                      //                             child:
                      //                                 CircularProgressIndicator(),
                      //                           ),
                      //                         );
                      //                       },
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ))
                      //         .toList(),
                      //     options: CarouselOptions(
                      //       height: 200,
                      //       viewportFraction: 1.0,
                      //       enlargeCenterPage: false,
                      //       autoPlay: true,
                      //       autoPlayInterval: const Duration(seconds: 3),
                      //     ),
                      //   ),
                      // const SizedBox(
                      //   height: 20,
                      // )
                    ],
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),

              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white,
                      child: Consumer<ShopDetailsProvider>(
                        builder: (context, shopDetailsProvider, child) {
                          if (shopDetailsProvider.shopDetails == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final categories =
                              shopDetailsProvider.shopDetails!.categories ?? [];

                          return Column(
                            children: categories.map((category) {
                              String categoryTitle =
                                  category.categoryName ?? '';
                              if (isLoadingMap[categoryTitle] == true) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              List products =
                                  categoryProducts[categoryTitle] ?? [];

                              if (products.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '    $categoryTitle',
                                              style: const TextStyle(
                                                fontFamily: 'SemiBold',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const HorizontalLine(),
                                          ],
                                        ),
                                      ],
                                    ),

                                    HorizontalProducts(
                                      shopCode: GlobalVariables.shopCode,
                                      category: categoryTitle,
                                    ),

                                    // Show "See all products" only when products > 3
                                    if (products.length > 3)
                                      GestureDetector(
                                        onTap: () {
                                          navigateToCategoryPage(
                                            context,
                                            {
                                              'title': category.categoryName,
                                              'image': category.categoryImage,
                                              'sub-title':
                                                  category.subcategories,
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 220, 235, 241),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 16,
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'See all products',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Transform.rotate(
                                                  angle: -90 *
                                                      3.1415926535897932 /
                                                      180,
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 20),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }).toList(),
                          );
                        },
                      ),
                    ),

                    DiscountProducts(
                      shopCode: GlobalVariables.shopCode,
                      category: 'Shirts',
                    ),

                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const SimpleOfferScreen()),
                        // );
                      },
                      child: const Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'coupons',
                                  style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Bestsellers",
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              fontWeight: FontWeight
                                  .bold, // Adjust font weight as needed
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          SizedBox(width: 10),
                          HorizontalLine(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('onTap triggered');
                        await notificationService.showNotification(
                          title: 'Order placed Successfully',
                          body: 'Click to track order',
                          payload: 'order_tracking',
                        );
                        print('Notification method called');
                      },
                      child: const Text(
                        "Notifications",
                        style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    GestureDetector(
                        onTap: () {
                          const SetLocation();
                          Navigator.pushNamed(context, SetLocation.routeName);
                        },
                        child: const Text('SetLocation')),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LocationPopup.routeName);

                          const LocationPopup();
                        },
                        child: const Text('Popup location')),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return RatingPopup(
                              onSubmit: (rating, feedback) {},
                              shopCode: widget.shopCode,
                            );
                          },
                        );
                      },
                      child: const Text('Rating popup'),
                    ),

                    // GestureDetector(
                    //     onTap: () {
                    //       AddressBottomSheet(context);
                    //     },
                    //     child: const Text('Address Bottom sheet')),

                    // GestureDetector(
                    //     onTap: () {
                    //       Navigator.pushNamed(context, AddressScreen.routeName);
                    //     },
                    //     child: const Text('Hive Address')),

                    GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, ShopDetailsScreen.routeName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ShopDetailsScreen()),
                          );
                        },
                        child: const Text('shop details hive')),
                    const HorizontalLine(),

                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 10,
                    ),
                    // fshopProducts(),
                    const Text(
                      "Categories",
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const HorizontalLine(),

                    const SizedBox(height: 20),
                    if (categories.length % 3 == 1)
                      GroceryCategories(shopCode: GlobalVariables.shopCode),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 400,
                      color: GlobalVariables.blueBackground,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              "India's  time and cost saving app",
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: GlobalVariables.lightBlueTextColor),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Text(
                                'shoper',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: GlobalVariables.lightBlueTextColor),
                              ),
                            ),
                            Center(
                              child: Text(
                                'V14.127.3',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 50,
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 50,
                color: GlobalVariables.blueBackground,
              )

              // Orders(),
            ],
          ),
        ),
        if (_isFloatingContainerOpen)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFloatingContainerOpen = false;
                  print('_isFloatingContainerOpen  clikced');
                });
              },
              child: Container(
                height: 133,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20), // Rounded upper corners
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Column(children: [
                    // Container(
                    //     decoration: const BoxDecoration(
                    //         color: GlobalVariables.blueBackground,
                    //         borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(20),
                    //             topRight: Radius.circular(20))),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(top: 0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(10),
                    //                   child: Container(
                    //                     decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         color: Colors.white),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           bottom: 10,
                    //                           left: 10,
                    //                           right: 10,
                    //                           top: 10),
                    //                       child: rem == 0
                    //                           ? const Icon(
                    //                               Icons.motorcycle,
                    //                               color: GlobalVariables
                    //                                   .blueTextColor,
                    //                               size: 18,
                    //                             )
                    //                           : const Icon(
                    //                               Icons.shopping_cart,
                    //                               color: GlobalVariables
                    //                                   .blueTextColor,
                    //                               size: 18,
                    //                             ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 rem == 0
                    //                     ? const Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             "Yay! you got FREE Delivery",
                    //                             style: TextStyle(
                    //                               color: GlobalVariables
                    //                                   .blueTextColor,
                    //                               fontFamily: 'Regular',
                    //                               fontSize: 12,
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                           Text(
                    //                             'No coupons needed',
                    //                             style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontFamily: 'Regular',
                    //                               fontSize: 12,
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       )
                    //                     : Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Text(
                    //                             "Get FREE delivery",
                    //                             style: TextStyle(
                    //                               fontSize: 12,
                    //                               color: GlobalVariables
                    //                                   .blueTextColor,
                    //                               fontFamily: 'Medium',
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                           Text(
                    //                             'Add products worth ₹${addMore(carts)} more',
                    //                             style: const TextStyle(
                    //                               fontFamily: 'Medium',
                    //                               fontSize: 12,
                    //                               color: GlobalVariables
                    //                                   .greyTextColor,
                    //                             ),
                    //                           ),
                    //                           const SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           Center(
                    //                             child: LinearPercentIndicator(
                    //                               lineHeight: 3,
                    //                               barRadius:
                    //                                   const Radius.circular(10),
                    //                               width: 280,
                    //                               animation: true,
                    //                               animationDuration:
                    //                                   1000, // The duration is in milliseconds
                    //                               percent: percent.toDouble(),
                    //                               progressColor: GlobalVariables
                    //                                   .yelloColor,
                    //                               backgroundColor:
                    //                                   Colors.amber[50],
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //               ],
                    //             ),
                    //           ),
                    //         ])),

                    SlidingBannerWidget(),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 10, left: 10, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 228, 229, 239),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.list,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isItemDetailsOpen = true;
                                // _openBottomSheet(context);
                              });
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${cart.length}  ITEMS', // Display the count of items
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_up,
                                  color: GlobalVariables.greenColor,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  backgroundColor: MaterialStateProperty.all(
                                      GlobalVariables.greenColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Navigator.pushNamed(
                                  //     context, '/user-cart-products');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserCartProducts(
                                              totalPrice: 0,
                                              address: '',
                                              index: 0,
                                              tips: 0,
                                              instruction: const [],
                                              totalSave: '',
                                              shopCode: '',
                                              note: '',
                                              number: 0,
                                              name: '',
                                              paymentType: 0,
                                              location: const {},
                                            )),
                                  );
                                  setState(() {
                                    _isFloatingContainerOpen = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Place order',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'SemiBold',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        if (!_isFloatingContainerOpen) const SlidingBannerWidget(),
      ]),
    );
  }
}
