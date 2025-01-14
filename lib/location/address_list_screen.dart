import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/local_storage/models/address.dart';
import 'package:shopez/location/add_address_screen.dart';
import 'package:shopez/location/addess_options_sheet.dart';
import 'package:shopez/location/address_edit_sheet.dart';


class AddressListScreen extends StatefulWidget {
  static const String routeName = '/address-list';
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Box<Address> addressBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    addressBox = await Hive.openBox<Address>('addresses');
    setState(() {}); // Trigger rebuild after loading addresses
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 2,
        shadowColor: Colors.grey[300],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My addresses",
          style: TextStyle(
            fontFamily: 'Regular',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            // Add New Address Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                    AddressEditBottomSheet(context, existingAddress: null);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: GlobalVariables.greenColor,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Add new address",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.greenColor,
                      ),
                    ),
                    const Spacer(),
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
            ),
            const SizedBox(height: 10),
            const Text(
              'Your saved addresses',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
                color: GlobalVariables.greyTextColor,
              ),
            ),
            const SizedBox(height: 16),
            // Address List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: addressBox.listenable(),
                builder: (context, Box<Address> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No addresses saved yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalVariables.greyTextColor,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final address = box.getAt(index)!;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  address.addressType.toLowerCase() == 'home'
                                      ? Icons.home
                                      : Icons.location_on,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        address.addressType,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      if (address.isDefault)
                                        Container(
                                          margin: const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: GlobalVariables.greenColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Default',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: GlobalVariables.greenColor,
                                              fontFamily: 'Regular',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    address.fullAddress,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phone number: ${address.receiverPhone}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle edit
                                          AddressOptionsBottomSheet(context,
                                                address: address);
                                          
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Transform.rotate(
                                            angle: 90 * (3.141592653589793 / 180),
                                            child: const Icon(
                                              Icons.more_vert,
                                              color: GlobalVariables.greenColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle delete
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Transform.rotate(
                                            angle: 90 * (3.141592653589793 / 180),
                                            child: const Icon(
                                              Icons.share,
                                              color: GlobalVariables.greenColor,
                                              size: 16,
                                            ),
                                          ),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}