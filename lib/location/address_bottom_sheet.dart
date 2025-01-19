import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/local_storage/models/address.dart';
import 'package:farcon/location/addess_options_sheet.dart';
import 'package:farcon/location/address_edit_sheet.dart';
import 'package:farcon/location/set_location.dart';
import 'package:farcon/providers/user_provider.dart';

void AddressBottomSheet(BuildContext context) {
  String userName =
      Provider.of<UserProvider>(context, listen: false).user.email;

  // Get the address box from Hive
  final Box<Address> addressBox = Hive.box<Address>('addresses');

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    backgroundColor: GlobalVariables.backgroundColor,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          // showSnackBarOverlay(context);
          return false; // Prevent the bottom sheet from closing
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Select address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.clear))
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetLocation(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Go to current location',
                            style: TextStyle(
                              fontSize: 14,
                              color: GlobalVariables.greenColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                        Icon(CupertinoIcons.right_chevron, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    AddressEditBottomSheet(context, existingAddress: null);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.add, color: GlobalVariables.greenColor),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Add new address',
                            style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.greenColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                        Icon(CupertinoIcons.right_chevron, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your saved addresses',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                // List of saved addresses
                ValueListenableBuilder<Box<Address>>(
                  valueListenable: addressBox.listenable(),
                  builder: (context, box, _) {
                    final addresses = box.values.toList();

                    if (addresses.isEmpty) {
                      return const Center(
                        child: Text(
                          'No saved addresses.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.home, color: Colors.blue),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      toBeginningOfSentenceCase(
                                              address.addressType) ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                      ),
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
                                        fontFamily: 'Medium',
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
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
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Transform.rotate(
                                              angle: 90 *
                                                  (3.141592653589793 / 180),
                                              child: const Icon(
                                                Icons.more_vert,
                                                color:
                                                    GlobalVariables.greenColor,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Transform.rotate(
                                            angle:
                                                90 * (3.141592653589793 / 180),
                                            child: const Icon(
                                              Icons.share,
                                              color: GlobalVariables.greenColor,
                                              size: 16,
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
              ],
            ),
          ),
        ),
      );
    },
  );
}
