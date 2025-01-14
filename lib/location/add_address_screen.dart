// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:shopez/constants/global_variables.dart';
// import 'package:shopez/local_storage/models/address.dart';
// import 'package:shopez/providers/user_provider.dart';
// import 'package:shopez/widgets/custom_text_field.dart';

// class AddAddressScreen extends StatefulWidget {
//   static const String routeName = '/add-address';
//   @override
//   _AddAddressScreenState createState() => _AddAddressScreenState();
// }

// class _AddAddressScreenState extends State<AddAddressScreen> {
//   final TextEditingController flatController = TextEditingController();
//   final TextEditingController areaController = TextEditingController();
//   final TextEditingController landmarkController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   final List<List<dynamic>> addressOptions = [
//     [Icons.home, 'Home'],
//     [Icons.work, 'Work'],
//     [Icons.hotel, 'Hotel'],
//     [Icons.location_on, 'Other']
//   ];

//   int selectedAddressIndex = -1;

//   String? selectedState;
//   String? addressType;
//   bool isDefaultAddress = false;
//   final List<String> addressTypes = ['Home', 'Office'];

//   @override
//   void initState() {
//     GlobalVariables.setAddress('adakna');
//     super.initState();
//   }

//   String combineAddress() {
//     return '${flatController.text}, ${areaController.text}, ${landmarkController.text}, ${cityController.text}, ${pincodeController.text}';
//   }

//   void addAddress() async {
//     // Create a new address instance
//     String fullAddress = combineAddress();
//     String currentAddressType =
//         addressType ?? 'Home'; // Default to Home if not selected
//     Address newAddress = Address(fullAddress, currentAddressType);

//     // Get the Hive box
//     var addressBox = Hive.box<Address>('addresses');

//     // Check if the address already exists
//     bool addressExists = addressBox.values.any((address) =>
//         address.fullAddress == newAddress.fullAddress && // Use fullAddress here
//         address.addressType == currentAddressType); // Use addressType here

//     if (addressExists) {
//       // Show a message if the address already exists
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Address already exists!'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } else {
//       // Add the address to the box
//       await addressBox.add(newAddress);
//       clearFields(); // Clear input fields after adding
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Address added successfully!'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   void clearFields() {
//     flatController.clear();
//     areaController.clear();
//     landmarkController.clear();
//     cityController.clear();
//     pincodeController.clear();
//     setState(() {
//       selectedState = null;
//       addressType = null;
//       isDefaultAddress = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final List<String> states = [
//       'Andhra Pradesh',
//       'Arunachal Pradesh',
//       'Assam',
//       'Bihar',
//       'Chhattisgarh',
//       'Goa',
//       'Gujarat',
//       'Haryana',
//       'Himachal Pradesh',
//       'Jharkhand',
//       'Karnataka',
//       'Kerala',
//       'Madhya Pradesh',
//       'Maharashtra',
//       'Manipur',
//       'Meghalaya',
//       'Mizoram',
//       'Nagaland',
//       'Odisha',
//       'Punjab',
//       'Rajasthan',
//       'Sikkim',
//       'Tamil Nadu',
//       'Telangana',
//       'Tripura',
//       'Uttar Pradesh',
//       'Uttarakhand',
//       'West Bengal',
//       'Andaman and Nicobar Islands',
//       'Chandigarh',
//       'Dadra and Nagar Haveli and Daman and Diu',
//       'Lakshadweep',
//       'Delhi',
//       'Puducherry',
//       'Ladakh',
//       'Jammu and Kashmir'
//     ];

//     return Scaffold(
//       backgroundColor: GlobalVariables.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 4,
//         shadowColor: Colors.grey[300],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Add Address",
//           style: TextStyle(
//             fontFamily: 'Regular',
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Add a new address',
//                 style: TextStyle(
//                   fontFamily: 'SmiBold',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   color: GlobalVariables
//                       .greenColor, // Background color for the container
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 child: const Center(
//                   child: Text(
//                     'Use current location',
//                     style: TextStyle(
//                       color: Colors.white, // Text color
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Center(
//                 child: Text('-------------- OR ------------',
//                     style: TextStyle(
//                         fontFamily: 'SmiBold',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14)),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   color: GlobalVariables
//                       .greenColor, // Background color for the container
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 child: const Center(
//                   child: Text(
//                     'India',
//                     style: TextStyle(
//                       color: Colors.white, // Text color
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Flat, House no., Building, Company, Apartment',
//                 style: TextStyle(
//                     fontFamily: 'SmiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               CustomTextFields(
//                 hintText: 'E.g. Bandra-Kurla Complex (BKC)',
//                 controller: flatController,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Area, street, sector, village',
//                 style: TextStyle(
//                     fontFamily: 'SmiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               CustomTextFields(
//                 hintText: 'E.g. Bandra East',
//                 controller: areaController,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Landmark',
//                 style: TextStyle(
//                     fontFamily: 'SmiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               CustomTextFields(
//                 hintText: 'E.g. Near Appolo Hospital ',
//                 controller: landmarkController,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'City/Town',
//                 style: TextStyle(
//                     fontFamily: 'SmiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               CustomTextFields(
//                 hintText: 'E.g. Mumbai',
//                 controller: cityController,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Pincode',
//                 style: TextStyle(
//                     fontFamily: 'SmiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               CustomTextFields(
//                 hintText: 'E.g. 431801',
//                 controller: pincodeController,
//               ),
//               const SizedBox(height: 16),
//               const Text('State',
//                   style: TextStyle(
//                       fontFamily: 'SmiBold',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14)),
//               const SizedBox(
//                 height: 5,
//               ),
//               // DropdownButtonFormField<String>(
//               //   value: selectedState,
//               //   items: states.map((String state) {
//               //     return DropdownMenuItem(
//               //       value: state,
//               //       child: Text(state),
//               //     );
//               //   }).toList(),
//               //   onChanged: (value) {
//               //     setState(() {
//               //       selectedState = value;
//               //     });
//               //   },
//               //   decoration: InputDecoration(
//               //     border: OutlineInputBorder(
//               //       borderRadius: BorderRadius.circular(15),
//               //     ),
//               //     contentPadding:
//               //         const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               //   ),
//               // ),

//               DropdownButtonFormField<String>(
//                 value: selectedState,
//                 items: states.map((String state) {
//                   return DropdownMenuItem(
//                     value: state,
//                     child: Text(
//                       state,
//                       style: const TextStyle(
//                         fontSize: 14, // Smaller font size
//                         fontFamily: 'Regular',
//                         color: Colors.black87,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedState = value;
//                   });
//                 },
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   size: 20, // Smaller icon
//                 ),
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontFamily: 'Regular',
//                   color: Colors.black87,
//                 ),
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10), // Changed to 10
//                     borderSide: const BorderSide(
//                       color: Colors.grey,
//                       width: 1,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       color: Colors.grey,
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       color: Colors.black,
//                       width: 1.5,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8, // Reduced vertical padding
//                   ),
//                   isDense: true, // Makes the field more compact
//                 ),
//                 dropdownColor: Colors.white,
//                 isExpanded: true, // Ensures dropdown takes full width
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: isDefaultAddress,
//                     onChanged: (value) {
//                       setState(() {
//                         isDefaultAddress = value!;
//                       });
//                     },
//                   ),
//                   const Text('Mark this as my default address',
//                       style: TextStyle(
//                           fontFamily: 'SmiBold',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               const Text('Address Type',
//                   style: TextStyle(
//                       fontFamily: 'SmiBold',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14)),
//               const SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 height: 40,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: addressOptions.length,
//                   itemBuilder: (context, index) {
//                     bool isSelected = selectedAddressIndex == index;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedAddressIndex = index;
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isSelected ? Colors.green[50] : Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                             border: Border.all(
//                               color: isSelected ? Colors.green : Colors.grey,
//                             ),
//                           ),
//                           padding: const EdgeInsets.only(left: 15, right: 15),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 addressOptions[index][0],
//                                 color: isSelected ? Colors.green : Colors.grey,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 addressOptions[index][1],
//                                 style: TextStyle(
//                                   color:
//                                       isSelected ? Colors.green : Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   String fullAddress = combineAddress();
//                   GlobalVariables.setAddress(fullAddress);
//                   addAddress();
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: GlobalVariables
//                         .greenColor, // Background color for the container
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                   child: const Center(
//                     child: Text(
//                       'Add address',
//                       style: TextStyle(
//                         color: Colors.white, // Text color
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
