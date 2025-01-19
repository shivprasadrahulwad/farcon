import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/orders/order_details_screen.dart';
import 'package:farcon/features/orders/order_services.dart';
import 'package:farcon/models/order.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/widgets/Loader.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const String routeName = '/order-history';
  final String userId;

  const OrderHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order>? orders;
  final OrderServices orderServices = OrderServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  String convertIdToOrderId(String id) {
    // Truncate the original ID or generate a hash/UUID for a unique order ID
    String shortId = id.substring(0, 8); // Truncate for brevity
    return 'ORD-$shortId'; // Create user-friendly order ID
  }

  void fetchOrders() async {
    setState(() {
      orders = null; // Set to null to show loading state
    });

    try {
      orders = await orderServices.fetchAllOrders(context);

      if (orders != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userId = userProvider.user?.id;

        if (userId != null) {
          // Filter orders by user ID
          orders = orders!.where((order) => order.userId == userId).toList();

          // Sort by date
          orders!.sort((a, b) {
            DateTime dateA = DateTime.fromMillisecondsSinceEpoch(a.orderedAt);
            DateTime dateB = DateTime.fromMillisecondsSinceEpoch(b.orderedAt);
            return dateB.compareTo(dateA); // Most recent first
          });

          setState(() {});
        } else {
          throw Exception('User ID is null');
        }
      }
    } catch (e) {
      print('Error fetching orders: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch orders: ${e.toString()}')),
      );
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'accepted';
      case 1:
        return 'packed';
      case 2:
        return 'on the way';
      case 3:
        return 'delivered';
      default:
        return 'Unknown'; // Fallback text for any undefined status
    }
  }

  String formatOrderDate(DateTime orderDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Check if the order date is today
    if (orderDate.isAfter(today)) {
      return 'Today, ${DateFormat('hh.mm a').format(orderDate)}';
    }
    // Check if the order date is yesterday
    else if (orderDate.isAfter(yesterday)) {
      return 'Yesterday, ${DateFormat('hh.mm a').format(orderDate)}';
    }
    // If the order date is older than yesterday
    else {
      return DateFormat('dd MMM yyyy, hh.mm a').format(orderDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 241, 246),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Your Orders',
          style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: orders == null
          ? const Loader()
          : Padding(
            padding: EdgeInsets.only(top: 5),
            child: ListView.builder(
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  final orderData = orders![index];
                  final orderDates =
                      DateTime.fromMillisecondsSinceEpoch(orderData.orderedAt);
                  final formattedDate = formatOrderDate(orderDates);
                  final formattedOrderId = convertIdToOrderId(orderData.id);
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              // Section A: Icon and Order Details
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      color: GlobalVariables.blueBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.shopping_bag,
                                        color: GlobalVariables.blueTextColor),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Order is ${getStatusText(orderData.status)}',
                                            style: const TextStyle(
                                                fontSize:
                                                    16,fontFamily: 'SemiBold',fontWeight: FontWeight.bold), 
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${orderData.totalPrice}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Regular',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .grey, // Set the color to black
                                                borderRadius: BorderRadius.circular(
                                                    30), // Set the border radius to 30
                                              ),
                                              child: const SizedBox(
                                                height: 5, // Example height
                                                width: 5, // Example width
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '$formattedDate',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Regular',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: orderData.status == 3
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                      color: Colors
                                          .white, // Optional: Background color
                                    ),
                                    child: Text(
                                      orderData.status == 0
                                          ? 'Active'
                                          : 'Completed',
                                      style: TextStyle(
                                        color: orderData.status == 3
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                      
                              // Section B: Items and Date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Items count and divider
                                  const Row(
                                    children: [
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                      
                                  // Date and View Details
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            OrderDetailScreen.routeName,
                                            arguments: orderData,
                                          );
                                        },
                                        child: Row(
                                
                                          children: [
                                            const Text(
                                              'View details',
                                              style: TextStyle(
                                                color: GlobalVariables.greenColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Transform.rotate(
                                              angle: 270 * (3.14159265359 / 180),
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                                color: GlobalVariables.greenColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ),
    );
  }
}
