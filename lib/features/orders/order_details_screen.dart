import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/models/order.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/widgets/sine_wave.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  Order? order; // Made mutable

  OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int status = 0;
  int currentStep = 0;
  // final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    // changeOrderStatus(status);
    if (widget.order != null) {
      currentStep = widget.order!.status;
    }
  }

  // void changeOrderStatus(status) {
  //   if (widget.order != null) {
  //     adminServices.changeOrderStatus(
  //       context: context,
  //       status: status,
  //       order: widget.order!,
  //       onSuccess: () {
  //         setState(() {
  //           widget.order!.status = status; // Update the order status
  //           currentStep = status;
  //         });
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String id = '${widget.order!.id}';
    String convertIdToOrderId(String id) {
      // Truncate the original ID or generate a hash/UUID for a unique order ID
      String shortId = id
          .substring(0, 6)
          .toUpperCase(); // Truncate to 6 characters and make uppercase
      return 'ORD-$shortId'; // Create user-friendly order ID
    }

    final formattedOrderId = convertIdToOrderId(widget.order!.id);
    final user = Provider.of<UserProvider>(context).user;
    int handelingCharge = 0;
    bool isAdmin = user.type == 'admin';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
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
          actions: const [
            Row(
              children: [],
            ),
          ],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Your Orders',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: widget.order == null
          ? const Center(
              child: Text(
                'NO Order yet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     elevation: 0,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(15),
                    //       child: Column(
                    //         // mainAxisAlignment:
                    //         //     MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             children: [
                    //               const Text(
                    //                 "Name : ",
                    //                 style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontFamily: 'SemiBold',
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 "${widget.order!.name}",
                    //                 style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontFamily: 'Regular',
                    //                     fontWeight: FontWeight.bold,
                    //                     color: GlobalVariables.faintBlackColor),
                    //               ),
                    //             ],
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             children: [
                    //               const Text(
                    //                 "Mobile No : ",
                    //                 style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontFamily: 'SemiBold',
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 "${widget.order!.number}",
                    //                 style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontFamily: 'Regular',
                    //                     fontWeight: FontWeight.bold,
                    //                     color: GlobalVariables.faintBlackColor),
                    //               )
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.motorcycle,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Delivery Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Details of your current order',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery at Home',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  const Text(
                                    'Shiv, Behind Apurv Hospital, Nanded',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Change address",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: GlobalVariables.greenColor,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                      ),
                                      Transform.rotate(
                                        angle: 270 * (3.14159265359 / 180),
                                        child: const Icon(
                                          Icons.arrow_drop_down,
                                          color: GlobalVariables.greenColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.order!.name}, ${widget.order!.number}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // const SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      const Text(
                                        "Update receiver's contact",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: GlobalVariables.greenColor,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                      ),
                                      Transform.rotate(
                                        angle: 270 * (3.14159265359 / 180),
                                        child: const Icon(
                                          Icons.arrow_drop_down,
                                          color: GlobalVariables.greenColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Note for shopowner',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '-${widget.order!.note}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                  ),
                                  // const SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      const Text(
                                        "Update Note ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: GlobalVariables.greenColor,fontFamily: 'Regular',fontWeight: FontWeight.bold),
                                      ),
                                      Transform.rotate(
                                        angle: 270 * (3.14159265359 / 180),
                                        child: const Icon(
                                          Icons.arrow_drop_down,
                                          color: GlobalVariables.greenColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                   
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  const Text(
                                    "Bill details",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SemiBold',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '-  ${DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Text(
                                    'ID: ${formattedOrderId}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: formattedOrderId));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'ID copied to clipboard')),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 12,
                                      )),
                                  const Spacer(),
                                  Text(
                                    'Time: ${DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Text(
                                    'Price(1 Q.)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: widget.order!.products.isEmpty
                                      ? [
                                          const Center(
                                            child: Text(
                                              'No products in this order.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]
                                      : [
                                          const SizedBox(height: 10),
                                          Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        product.name,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Regular',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        (product.discountPrice)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Regular',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    int index = widget
                                                        .order!.products
                                                        .indexOf(product);
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        '${widget.order!.quantity[index]}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Regular',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.event_note_sharp,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Sub Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  // CartSubtotal(),
                                  Text('₹${widget.order!.totalPrice}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                          color:
                                              GlobalVariables.faintBlackColor))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Handeling Charge",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  Spacer(),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                10), // Adjust this value for spacing
                                        child: Text(
                                          '₹10  ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.greyTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                30), // Adjust this value for spacing
                                        child: Text(
                                          '  FREE',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.blueTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.motorcycle,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Delivery Charge",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: GlobalVariables.faintBlackColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular'),
                                  ),
                                  Spacer(),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                10), // Adjust this value for spacing
                                        child: Text(
                                          '₹150  ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.greyTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                30), // Adjust this value for spacing
                                        child: Text(
                                          '  FREE',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.blueTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, bottom: 10),
                              child: Row(
                                children: [
                                  const Text("Grand Total",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular')),
                                  const Spacer(),
                                  // CartTotal(),
                                  Text(
                                      '₹${widget.order!.totalPrice + handelingCharge}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                          color:
                                              GlobalVariables.faintBlackColor))
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                ClipPath(
                                  clipper: SineWaveClipper(
                                    amplitude: 3,
                                    frequency: 15,
                                  ),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(),
                                    child: Container(
                                      width: double.infinity,
                                      height: 70, // Adjust the height as needed

                                      decoration: const BoxDecoration(
                                          color: GlobalVariables.savingColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Positioned(
                                            top:
                                                19, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total savings",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Regular',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top:
                                                35, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Includes 10 savings through free delivery",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: GlobalVariables
                                                          .lightBlueTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹${widget.order!.totalSave + 10 + 150}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.blueTextColor,
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 20),
                        child: Text(
                          "Track Order",
                          style: TextStyle(
                              fontFamily: 'SemiBold',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: GlobalVariables.greyBackgroundCOlor,
                              width: 2)),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: GlobalVariables.greenColor)),
                        child: Stepper(
                          currentStep: currentStep,
                          controlsBuilder: (context, details) {
                            return (isAdmin && widget.order!.status < 3)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                        width: 200,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // changeOrderStatus(details.stepIndex + 1);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .blue, // Button background color
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Done',
                                              style: TextStyle(
                                                color:
                                                    Colors.white, // Text color
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  )
                                : const SizedBox();
                          },
                          steps: [
                            Step(
                              title: const Row(
                                children: [
                                  Icon(Icons.ac_unit),
                                  // Image.asset(
                                  //   'images/pending.png',
                                  //   width: 20,
                                  //   height: 20,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  SizedBox(width: 10),
                                  Text('Pending'),
                                ],
                              ),
                              content: const Row(
                                children: [
                                  Text(
                                    'Your order is yet to be accepted',
                                  ),
                                ],
                              ),
                              isActive: currentStep >= 0,
                              state: currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Row(
                                children: [
                                  // Image.asset(
                                  //   'images/accepted.png',
                                  //   width: 20,
                                  //   height: 20,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  SizedBox(width: 10),
                                  Text('Accepted'),
                                ],
                              ),
                              content: const Row(
                                children: [
                                  Text(
                                    'Your order has been accepted, yet to be ready.',
                                  ),
                                ],
                              ),
                              isActive: currentStep >= 1,
                              state: currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Row(
                                children: [
                                  Icon(Icons.shopping_bag_outlined),
                                  SizedBox(width: 10),
                                  Text('Ready'),
                                ],
                              ),
                              content: const Row(
                                children: [
                                  Text(
                                    'Your order is ready for takeaway.',
                                  ),
                                ],
                              ),
                              isActive: currentStep >= 2,
                              state: currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Row(
                                children: [
                                  Icon(Icons.man_outlined),
                                  SizedBox(width: 10),
                                  Text('Picked by you'),
                                ],
                              ),
                              content: const Row(
                                children: [
                                  Text(
                                    'Your order is completed.',
                                  ),
                                ],
                              ),
                              isActive: currentStep >= 3,
                              state: currentStep >= 3
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
    );
  }
}
