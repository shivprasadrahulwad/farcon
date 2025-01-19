import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/account/account_services.dart';
import 'package:farcon/features/orders/order_history_screen.dart';
import 'package:farcon/features/user/services/home_services.dart';
import 'package:farcon/location/address_list_screen.dart';
import 'package:farcon/providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = '/account';
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // List<Order>? orders;
  final HomeServices accountServices = HomeServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment
                                    .bottomCenter, // Start at the bottom
                                end: Alignment.topCenter, // End at the top
                                colors: [
                                  GlobalVariables.blueBackground.withOpacity(
                                      1), // Fully opaque yellow at the bottom
                                  GlobalVariables.blueBackground.withOpacity(
                                      0), // Transparent yellow at the top
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Shivprasad',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Medium'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Rahulwad',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Medium'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        '8830031264',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Regular'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 7, bottom: 7),
                                        decoration: BoxDecoration(
                                          color: GlobalVariables
                                              .blueBackground, // Light blue background
                                          borderRadius: BorderRadius.circular(
                                              20), // Border radius of 20
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0, right: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Icon with circular black background
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors
                                                          .black, // Circular black background
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .done, // Icon of your choice
                                                      size: 15,
                                                      color: Colors
                                                          .white, // Icon color
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'Shop ID: ${GlobalVariables.shopCode}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black, // Text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors
                                                          .black, // Circular black background
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .done, // Icon of your choice
                                                      size: 15,
                                                      color: Colors
                                                          .white, // Icon color
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Text(
                                                    'OR CODE: ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black, // Text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(context, '/qr-create');
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(1),
                                                      child: const Icon(
                                                        Icons.qr_code,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Stack(
                                            clipBehavior: Clip
                                                .none, // Ensures nothing is clipped
                                            alignment: Alignment.center,
                                            children: [
                                              // Big Container with BorderRadius of 35
                                              Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50), // Border radius for large container
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                      fontSize: 45,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Small Container with BorderRadius of 20
                                              Positioned(
                                                  right:
                                                      -5, // Proper offset to make sure it's on the border
                                                  bottom: -5,
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushNamed(context, '/scan');
                                                        },
                                                        child: const Icon(
                                                          Icons.qr_code_scanner,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFFAF6EB), // Light green background color
                              borderRadius:
                                  BorderRadius.circular(15), // Radius of 20
                            ),
                            padding: const EdgeInsets.all(
                                16), // Padding inside the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceAround, // Distribute space evenly
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize size to fit content
                                  children: [
                                    Image.asset(
                                      'assets/images/wallet.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Space between icon and label
                                    const Text(
                                      'Wallet',
                                      style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontSize:
                                              14, // Font size of the label
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize size to fit content
                                  children: [
                                    Image.asset(
                                      'assets/images/support.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Space between icon and label
                                    const Text(
                                      'Support',
                                      style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontSize:
                                              14, // Font size of the label
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize size to fit content
                                  children: [
                                    Image.asset(
                                      'assets/images/payment.png',
                                      width: 22,
                                      height: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Space between icon and label
                                    const Text(
                                      'Payments',
                                      style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontSize:
                                              14, // Font size of the label
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "YOUR INFORMATION",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                color: GlobalVariables.greyBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderHistoryScreen(
                                            userId:
                                                '66fbd969bb65c03b750119a8')),
                              );
                              // Navigator.pushNamed(context, '/orders');

                              // Navigator.pushNamed(context, '/create');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Your Orders",
                                  style: TextStyle(
                                      fontFamily: 'Medium', fontSize: 16),
                                ),
                                const Spacer(), // This pushes the text to the leftmost side
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/like');
                              Navigator.pushNamed(context, AddressListScreen.routeName);
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.notes_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Address book",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text("OTHER INFORMATION",
                              style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  color: GlobalVariables.greyBlueColor,
                                  fontWeight: FontWeight.bold)),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share("mess");
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as neededv
                                  child: const Icon(
                                    Icons.share_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Share the app",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/aboutUs');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "About Us",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.star_border_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Rate us on the Play Store",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/accountPrivacy');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.privacy_tip_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Account privacy",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/accountPrivacy');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Notification preferences",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => AccountServices().logOut(context),
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'farcon',
                                  style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: GlobalVariables.greyBlueColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'V14.127.3',
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    color: GlobalVariables.greyBlueColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
