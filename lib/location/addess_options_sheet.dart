import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/local_storage/models/address.dart';
import 'package:farcon/location/address_edit_sheet.dart';
import 'package:farcon/location/address_services.dart';
import 'package:farcon/providers/user_provider.dart';

void AddressOptionsBottomSheet(BuildContext context,{required Address address}) {
  String userName = Provider.of<UserProvider>(context, listen: false).user.email;

  Future<void> handleDeleteAddress() async {
    try {
      // Find the index of the address to delete
      final addresses = AddressService.getAllAddresses();
      final index = addresses.indexWhere((a) => 
        a.flatNo == address.flatNo && 
        a.area == address.area &&
        a.city == address.city &&
        a.state == address.state &&
        a.receiverName == address.receiverName &&
        a.receiverPhone == address.receiverPhone
      );
      
      if (index != -1) {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: GlobalVariables.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                'Delete Address',
                style: TextStyle(
                  fontFamily: 'SemiBold',
                  color: Colors.black,
                ),
              ),
              content: const Text(
                'Are you sure you want to delete this address?',
                style: TextStyle(
                  fontFamily: 'Regular',
                  color: Colors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Regular',
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await AddressService.deleteAddress(index);
                      
                      // Close both the dialog and the bottom sheet
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close bottom sheet
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete address: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Regular',
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Address not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



// Future<void> handleSetAsDefault() async {
//     try {
//       final box = Hive.box<Address>(AddressService.boxName);
      
//       // Store all operations we need to perform
//       Map<dynamic, Address> updates = {};
//       String? targetKey;
      
//       // First pass: find our target address and collect all default addresses
//       for (var key in box.keys) {
//         final currentAddress = box.get(key);
//         if (currentAddress == null) continue;
        
//         // Check if this is a default address that needs to be updated
//         if (currentAddress.isDefault) {
//           updates[key] = currentAddress.copyWith(isDefault: false);
//         }
        
//         // Check if this is our target address
//         if (currentAddress.flatNo == address.flatNo &&
//             currentAddress.area == address.area &&
//             currentAddress.city == address.city &&
//             currentAddress.state == address.state &&
//             currentAddress.receiverName == address.receiverName &&
//             currentAddress.receiverPhone == address.receiverPhone) {
//           targetKey = key.toString();
//         }
//       }
      
//       if (targetKey == null) {
//         throw Exception('Target address not found in storage');
//       }
      
//       // Add our target address update to the batch
//       final updatedAddress = address.copyWith(
//         isDefault: true,
//         isInUse: true,
//       );
//       updates[targetKey] = updatedAddress;
      
//       // Perform all updates in a single batch
//       try {
//         await box.putAll(updates);
        
//         // Close the bottom sheet
//         Navigator.pop(context);
        
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Address set as default delivery address'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         throw Exception('Failed to update addresses: ${e.toString()}');
//       }
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error setting default address: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }


Future<void> handleSetAsDefault() async {
    try {
      final box = Hive.box<Address>(AddressService.boxName);
      
      // Debug log
      print('Starting to set default address. Total addresses: ${box.length}');
      
      // First: find all addresses and our target
      Address? targetAddress;
      List<Address> defaultAddresses = [];
      
      for (var entry in box.toMap().entries) {
        final currentAddress = entry.value;
        
        // Collect currently default addresses
        if (currentAddress.isDefault) {
          defaultAddresses.add(currentAddress);
          print('Found existing default address: ${currentAddress.toString()}');
        }
        
        // Find our target address
        if (currentAddress.flatNo == address.flatNo &&
            currentAddress.area == address.area &&
            currentAddress.city == address.city &&
            currentAddress.state == address.state &&
            currentAddress.receiverName == address.receiverName &&
            currentAddress.receiverPhone == address.receiverPhone) {
          targetAddress = currentAddress;
          print('Found target address: ${currentAddress.toString()}');
        }
      }
      
      if (targetAddress == null) {
        throw Exception('Target address not found in storage');
      }
      
      // Second: reset all default addresses
      for (var defaultAddress in defaultAddresses) {
        if (defaultAddress != targetAddress) {  // Don't reset if it's our target
          print('Resetting default status for address: ${defaultAddress.toString()}');
          defaultAddress.isDefault = false;
          defaultAddress.isInUse = false;
          await defaultAddress.save();
        }
      }
      
      // Finally: set our target as default
      print('Setting target address as default');
      targetAddress.isDefault = true;
      targetAddress.isInUse = true;
      await targetAddress.save();
      
      // Close the bottom sheet
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address set as default delivery address'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      print('Error in handleSetAsDefault: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error setting default address: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  

  
  
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    backgroundColor: GlobalVariables.backgroundColor,
    isScrollControlled: true,
    // isDismissible: false,
    enableDrag: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
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
              const Text(
                'Select option',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    
                    GestureDetector(
                      onTap: () {
                        AddressEditBottomSheet(context, existingAddress: address);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Edit address",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: GlobalVariables.dividerColor,),
                    GestureDetector(
                      onTap: () {
                        handleDeleteAddress();
                        print('deleted');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.black,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Delete address",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    Divider(color: GlobalVariables.dividerColor,),
                    GestureDetector(
                      onTap: handleSetAsDefault,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Set as delivery address",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
