import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/user/screens/home_screen.dart';
import 'package:farcon/features/user/services/home_services.dart';
import 'package:farcon/models/user.dart';
import 'package:farcon/providers/shop_details_provider.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/widgets/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarmerListScreen extends StatefulWidget {
  final String area;

  const FarmerListScreen({Key? key, required this.area})
      : super(key: key);

  @override
  State<FarmerListScreen> createState() => _FarmerListScreenState();
}

class _FarmerListScreenState extends State<FarmerListScreen> {
  List<User>? users; // Change from orders to users
  final HomeServices homeServices = HomeServices();
    bool isLoading = true;
  String? error;


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: GlobalVariables.backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Time',
                    style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(
                          16), // Optional: Adds some padding inside the container
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'All deliveries will be done in time ',
                                    style: TextStyle(
                                        fontFamily: 'SemiBold',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '* * * * * *',
                                    style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 36,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: GlobalVariables.blueBackground,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      35), // Optional: adds rounded corners to the border
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.motorcycle,
                                      size: 30,
                                      color: GlobalVariables.blueTextColor,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(255, 90, 228, 44),
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.done,
                                        size: 10,
                                        color: Colors.white,
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Products delivered in given time interval',
                                style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(255, 90, 228, 44),
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.done,
                                        size: 10,
                                        color: Colors.white,
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Choose delivery partner as per your time',
                                style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(255, 90, 228, 44),
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(
                                        Icons.done,
                                        size: 10,
                                        color: Colors.white,
                                      ))),
                              const SizedBox(width: 10),
                              const Expanded(
                                // This will allow the text to take up the remaining space in the row
                                child: Text(
                                  "Delivered only in given time frame",
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  // overflow: TextOverflow.ellipsis, // This will handle the overflow by showing '...'
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ]));
      },
    );
  }


  @override
  void initState() {
    super.initState();
    fetchShopDetails(); // Fetch users instead of orders
  }

Future<void> fetchShopDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      await HomeServices.fetchShopsByAddress(context, widget.area);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          elevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.only(left: 10, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.people),
                SizedBox(width: 20),
                Text(
                  'Farmers',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
      Consumer<ShopDetailsProvider>(
        builder: (context, shopDetailsProvider, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchShopDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final shops = shopDetailsProvider.shopList;

          if (shops.isEmpty) {
            return const Center(
              child: Text('No farmers found in this area'),
            );
          }

          return ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];

                return GestureDetector(
                  onTap: () {
                    // Implement navigation or actions if necessary
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          16), // Adjust the radius as needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: GlobalVariables.blueBackground,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.person,
                                    size: 25,
                                    color: GlobalVariables.blueTextColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  shop.shopName ?? 'Unknown Farmer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'SemiBold',
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: GlobalVariables.blueBackground,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: GlobalVariables.blueTextColor)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                        shop.time ?? '7AM - 9AM',
                                        style: const TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.blueTextColor),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.grey, thickness: 1),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.timelapse,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                shop.time ?? '7AM - 9AM',
                                style: const TextStyle(
                                  color: GlobalVariables.greyTextColor,
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context);
                                },
                                child: const Icon(
                                  Icons.info_outline,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  shop.address ?? 'Address not available',
                                  style: const TextStyle(
                                    color: GlobalVariables.greyTextColor,
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // final userProvider = Provider.of<UserProvider>(
                              //     context,
                              //     listen: false);
                              // userProvider.setShopCode('${userData.shopCode}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    shopCode: shop.shopCode,
                                  ), 
                                ),
                              );
                            },
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Shop now',
                                    style: TextStyle(
                                        color: GlobalVariables.greenColor,
                                        fontFamily: 'Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    CupertinoIcons.forward,
                                    color: GlobalVariables.greenColor,
                                    size: 25,
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
        }
      )
    );
  }
}
