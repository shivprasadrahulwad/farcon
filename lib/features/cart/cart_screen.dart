import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/cart/bill_details.dart';
import 'package:shopez/features/cart/cart_subtotal.dart';
import 'package:shopez/features/cart/note_popup.dart';
import 'package:shopez/features/payment/payment_options.dart';
import 'package:shopez/features/user/screens/home_screen.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/location/location_popup.dart';
import 'package:shopez/models/product.dart';
import 'package:shopez/offer/discount_products.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:shopez/providers/user_provider.dart';

enum DeliveryOption { door, other }

DeliveryOption selectedDeliveryOption = DeliveryOption.door;

class UserCartProducts extends StatefulWidget {
  static const String routeName = '/user-cart-products';
  final int totalPrice;
  final String totalSave;
  final String shopCode;
  final String address;
  final int index;
  final List<Map<String, String>> instruction;
  final tips;
  final note;
  final number;
  final name;
  final int paymentType;
  final location;

  UserCartProducts({
    Key? key,
    required this.totalPrice,
    required this.address,
    required this.index,
    required this.instruction,
    required this.tips,
    required this.totalSave,
    required this.shopCode,
    required this.note,
    required this.number,
    required this.name,
    required this.paymentType,
    required this.location,
  }) : super(key: key);

  final Map<String, dynamic> Schedule = {
    'title': 'Delivary Schedule',
    'tips': [
      ' ',
      '₹20',
      '₹30',
      '₹50',
      'Custom',
    ],
    'emoji': [
      '😊 Clear',
      '😀',
      '🤩',
      '😍',
      '🤗',
    ],
  };

  @override
  State<UserCartProducts> createState() => _UserCartProductsState();
}

class _UserCartProductsState extends State<UserCartProducts> {
  late int _amountInRupees;
  final HomeServices homeServices = HomeServices();
  final TextEditingController _noteController = TextEditingController();
  List<Map<String, String>> instruction = [];

  /////////////////////payment phonepe////////////////
  String environment = 'SANDBOX';
  String appId = 'your_app_id_here'; // Replace with your actual app ID
  String merchantId = 'PGTESTPAYUAT86';
  bool enableLogging = true;
  String checksum = '';
  String saltKey = '96434309-7796-489d-8924-ab56988a6076';
  String saltIndex = '1';
  String callbackUrl =
      'https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1';
  String body = '';
  Object? result;
  String apiEndPoint = '/pg/v1/pay';

  late int delPrice;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    final shopProvider = Provider.of<ShopDetailsProvider>(context, listen: false);
final shopDetails = shopProvider.shopDetails;
delPrice = shopDetails!.charges!.deliveryCharges!.toInt();

    _initializeAmountInRupees();
    phonepeInit();
  }

  void _initializeAmountInRupees() {
    final userProvider = context.read<UserProvider>();
    setState(() {
      _amountInRupees = userProvider.cartTotal ?? 0;
    });
  }

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT${DateTime.now().millisecondsSinceEpoch}",
      "merchantUserId": "MUID${DateTime.now().millisecondsSinceEpoch}",
      "amount": _amountInRupees * 100, // Convert rupees to paise for PhonePe
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    return base64Body;
  }

  ////////////////////////////////

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void increaseQuantity(Product product) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.incrementQuantity(product.id);
  }

  void decreaseQuantity(Product product) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.decrementQuantity(product.id);
  }

  String? _selectedScheduleValue = '';
  bool _isFloatingContainerOpen = false;

  void placeOrders() {
    final cart =
        context.read<UserProvider>().user.cart.cast<Map<String, dynamic>>();
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const HomeScreen(
              shopCode: '123456')), // Replace with your desired screen
    );

    // int calculateCartTotal(List<Map<String, dynamic>> cart) {
    //   int sum = 0;
    //   int devlivery = delPrice;

    //   cart.forEach((e) {
    //     final quantity = e['quantity'] as int?;
    //     final product = e['product'] as Map<String, dynamic>?;

    //     if (quantity != null && product != null) {
    //       final discountPrice = product['discountPrice'] as int?;
    //       final price = product['price'] as int?;

    //       if (price != null) {
    //         sum += quantity * (discountPrice ?? price);
    //       }
    //     }
    //   });

    //   return sum;
    // }

    int calculateTotalSave(List<Map<String, dynamic>> cart) {
      int save = 0;

      cart.forEach((e) {
        final quantity = e['quantity'] as int?;
        final product = e['product'] as Map<String, dynamic>?;

        if (quantity != null && product != null) {
          final discountPrice = product['discountPrice'] as int?;
          final price = product['price'] as int?;

          if (discountPrice != null && price != null) {
            // Calculate savings for each item
            int originalTotal = quantity * price;
            int discountedTotal = quantity * discountPrice;
            int itemSave = originalTotal - discountedTotal -delPrice;

            save += itemSave;
          }
        }
      });

      return save;
    }
    final userProvider = context.read<UserProvider>();
    final totalPrice = userProvider.cartTotal;
    print(totalPrice);
    final totalSave = calculateTotalSave(cart);
    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    homeServices.placeOrder(
      context: context,
      shopId: GlobalVariables.shopCode,
      address: GlobalVariables.address,
      totalPrice: totalPrice!,
      totalSave: totalSave,
      instruction: instruction,
      tips: _selectedScheduleValue,
      number: 8830031264,
      note: _noteController.text,
      name: userProvider.user.name,
      paymentType: widget.paymentType,
      location: userProvider.user.location,
    );
  }

  bool isMarked1 = false;
  bool isMarked2 = false;
  bool isMarked3 = false;
  bool isMarked4 = false;
  bool isMarked5 = false;

  int _selectedScheduleIndex = 0;

  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;

  void updateInstructions() {
    instruction.clear(); // Clear existing instructions

    if (isMarked1) {
      instruction.add({'type': '1'});
    }
    if (isMarked2) {
      instruction.add({'type': '2'});
    }
    if (isMarked3) {
      instruction.add({'type': '3'});
    }
    if (isMarked4) {
      instruction.add({'type': '4'});
    }
    if (isMarked5) {
      instruction.add({'type': '5'});
    }
  }

  String getPaymentTitle(int paymentType) {
    final paymentOption = GlobalVariables.paymentImages.firstWhere(
      (option) => option['sub-title'] == paymentType.toString(),
      orElse: () => {'title': 'Unknown'},
    );
    return paymentOption['title'];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final shopCode = userProvider.user.shopCode;
    final cart = context.watch<UserProvider>().user.cart;
    updateInstructions();
    final paymentTitle = getPaymentTitle(widget.paymentType);

    final carts = context.watch<UserProvider>().user.cart;

    if (carts.length >= 1 && !_isFloatingContainerOpen) {
      _isFloatingContainerOpen = true;
    }

    // final shopProvider = Provider.of<ShopDetailsProvider>(context);
    // final shopDetails = shopProvider.shopDetailsList[0];
    final shopProvider = Provider.of<ShopDetailsProvider>(context);
    final shopDetails = shopProvider.shopDetails;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Navigator.pushNamed(context, '/home');
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
          actions: [
            if(carts.length > 0)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle share action
                    Share.share('Your message here');
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(top: 25, right: 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle shopping cart action
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: GlobalVariables.greenColor,
                                size: 15,
                              ),
                            ),
                          ),
                          const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.greenColor,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          cart.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Padding(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 234, 241, 246)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: GlobalVariables.savingColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Your total savings',
                                            style: TextStyle(
                                                color: GlobalVariables
                                                    .blueTextColor,
                                                fontFamily: 'Medium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          if(shopDetails!.delPrice ==0)
                                          Text(
                                            'Includes ${shopDetails.charges?.isDeliveryChargesEnabled == true ? shopDetails.charges?.deliveryCharges?.toInt() ?? 0 : 0} saving through free delivery',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: GlobalVariables
                                                    .lightBlueTextColor,
                                                fontFamily: 'Medium'),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const CartTotalSaving(),
                                    ],
                                  )),
                            ),

                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 15, right: 15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: const Color.fromARGB(
                                                    255, 228, 229, 239)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.timer,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Ready in 10 minutes",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: GlobalVariables
                                                        .cartFontWeight,
                                                    fontFamily: 'SemiBold'),
                                              ),
                                              Text(
                                                'Shipment of ${cart.length} Items',
                                                style: const TextStyle(
                                                  fontFamily: 'Medium',
                                                  fontSize: 12,
                                                  color: GlobalVariables
                                                      .greyTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: GlobalVariables.dividerColor,
                                  ),
                                  ListView.separated(
                                    itemCount: cart.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      thickness: 1,
                                      color: GlobalVariables.dividerColor,
                                    ),
                                    itemBuilder: (context, index) {
                                      final productCart = cart[index];
                                      if (productCart['product'] == null) {
                                        return const SizedBox.shrink();
                                      }
                                      final product = Product.fromMap(
                                          productCart['product']);
                                      if (product == null) {
                                        return const SizedBox.shrink();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Image.network(
                                                    product.images.isNotEmpty
                                                        ? product.images[0]
                                                        : '',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Regular'),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        (product.quantity
                                                                ?.toInt())
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: GlobalVariables
                                                              .greyTextColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: GlobalVariables
                                                                            .greenColor,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: GlobalVariables
                                                                          .greenColor),
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () =>
                                                                        decreaseQuantity(
                                                                            product),
                                                                    child:
                                                                        Container(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: GlobalVariables
                                                                              .greenColor,
                                                                          width:
                                                                              1.5),
                                                                      color: GlobalVariables
                                                                          .greenColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: 30,
                                                                      height:
                                                                          28,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        productCart['quantity']
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            fontFamily:
                                                                                'Regular',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () =>
                                                                        increaseQuantity(
                                                                            product),
                                                                    child:
                                                                        Container(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '₹${(product.price).toInt()}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Regular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  color: GlobalVariables
                                                                      .greyTextColor),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              '₹${(product.discountPrice)?.toInt()}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Regular',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: Text(
                                          'Before you checkout',
                                          style: TextStyle(
                                              fontFamily: 'SemiBold',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    DiscountProducts(
                      shopCode: GlobalVariables.shopCode,
                      category: 'Shirts',
                    ),

                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GlobalVariables.blueBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: GlobalVariables
                                                      .blueTextColor,
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.done,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Yay! you got No Handling Charge",
                                                  style: TextStyle(
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    fontFamily: 'SemiBold',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'No coupons needed',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Regular',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/coupon');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'See all coupons',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Regular',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Transform.rotate(
                                              angle:
                                                  -1.5708, // 90 degrees in radians
                                              child: const Icon(Icons.arrow_drop_down),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),

                            const SizedBox(
                              height: 5,
                            ),
                            BillDetails(
                              selectedScheduleValue:
                                  _selectedScheduleValue ?? '',
                            ),
                            const SizedBox(height: 5),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    NotePopup());
                                          },
                                          child: const Row(
                                            children: [
                                              Text(
                                                "Note for shopkeeper",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'SemiBold',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                'Add',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables
                                                        .greenColor,
                                                    fontFamily: 'Regular'),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                                child: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ordering for someone else?",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SemiBold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Add details',
                                        style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: GlobalVariables.greenColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cancellation Policy",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'SemiBold',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Orders cannot be cancelled once packed for delivery. In case of unexpected delays, a refund will be provided, if applicable.",
                                          style: TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 12,
                                              color: GlobalVariables
                                                  .greyTextColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                                child: const Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "",
                                            style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 16,
                                                color: GlobalVariables
                                                    .greyTextColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // CustomButton(
                            //   text: "Proceed to Payment",
                            //   onTap: placeOrders,
                            // ),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          if (_isFloatingContainerOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0, // Extend the container to the full width
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFloatingContainerOpen = false;
                  });
                },
                child: Container(
                  height:
                      137, // Increase the height for a drawer-like appearance
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Change the color to white for a drawer effect
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20), // Only top corners rounded
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(
                            0, -4), // Shadow offset adjusted for bottom drawer
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10), // Add padding around the content
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align to the start
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 10,
                                top: 5,
                              ),
                              child: Icon(
                                Icons.house,
                                size: 40,
                                color: GlobalVariables.blueTextColor,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Delivering to ',
                                              style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Home',
                                              style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Shiv, Behind Apurv Hospital, Nanded',
                                    style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                        color: GlobalVariables.greyTextColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Text(
                                  //   '${userProvider.user.location != null ? 'Lat: ${userProvider.user.location!['latitude']}, Lng: ${userProvider.user.location!['longitude']}' : 'Location not available'}',
                                  //   style: const TextStyle(
                                  //     fontFamily: 'Regular',
                                  //     fontSize: 12,
                                  //     color: GlobalVariables.greyTextColor,
                                  //   ),
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: GlobalVariables.dividerColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        PaymentOptions.routeName,
                                      );
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        // color: GlobalVariables.blueBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0),
                                        child: Column(
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(
                                                  Icons.apple,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'PAY USING',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Regular',
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_drop_up,
                                                  color: GlobalVariables
                                                      .blueTextColor,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              paymentTitle == 'Unknown'
                                                  ? 'Google Pay UPI'
                                                  : '$paymentTitle',
                                              style: const TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              GlobalVariables.greenColor),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isFloatingContainerOpen = false;
                                      });
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                         const LocationPopup();
                                        _showPaymentDialog();
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CartTotal(),
                                              Text(
                                                'TOTAL',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontFamily: 'Regular'),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'Place order',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'SemiBold'),
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('PhonePe Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Amount: ₹$_amountInRupees',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await startPgTransaction(); // Start the payment
                },
                child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('Proceed with Payment')),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Button radius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Result:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                result != null ? '$result' : '',
                style: TextStyle(
                  color: result != null && result.toString().contains('failed')
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  Future<void> startPgTransaction() async {
    try {
      var response = await PhonePePaymentSdk.startTransaction(
          getChecksum(), callbackUrl, checksum, apiEndPoint);

      setState(() {
        if (response != null) {
          String status = response['status']?.toString() ?? 'Unknown';
          String error = response['error']?.toString() ?? 'No error details';

          if (status.toLowerCase() == 'success') {
            result =
                'Payment of ₹$_amountInRupees successful - status : SUCCESS';

            placeOrders();
          } else {
            result = 'Payment failed - status : $status and error $error';
          }
        } else {
          result = 'Payment process incomplete';
          print(
              "Response is null, payment process incomplete.----------------------------------------");
        }
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      result = {'error': error.toString()};
    });
  }
}
