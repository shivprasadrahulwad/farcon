import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:farcon/local_storage/models/address.dart';
import 'package:farcon/location/address_services.dart';
import 'package:farcon/location/set_location.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/widgets/custom_text_field.dart';

void AddressEditBottomSheet(BuildContext context, {Address? existingAddress}) {
  final _formKey = GlobalKey<FormState>();
  final List<List<dynamic>> addressOptions = [
    [Icons.home, 'Home'],
    [Icons.work, 'Work'],
    [Icons.hotel, 'Hotel'],
    [Icons.location_on, 'Other']
  ];

  // Controllers
  final _flatNoController =
      TextEditingController(text: existingAddress?.flatNo ?? '');
  final _floorController =
      TextEditingController(text: existingAddress?.floor ?? '');
  final _areaController =
      TextEditingController(text: existingAddress?.area ?? '');
  final _landmarkController =
      TextEditingController(text: existingAddress?.landmark ?? '');
  final _cityController =
      TextEditingController(text: existingAddress?.city ?? '');
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();

  // Focus nodes
  final _flatNoFocus = FocusNode();
  final _floorFocus = FocusNode();
  final _areaFocus = FocusNode();
  final _landmarkFocus = FocusNode();
  final _receiverNameFocus = FocusNode();
  final _receiverPhoneFocus = FocusNode();
  final _cityFocus = FocusNode();

  String orderingFor = 'myself';

// Set initial values based on orderingFor
  if (orderingFor == 'someone_else') {
    _receiverNameController.text = '';
    _receiverPhoneController.text = '';
  } else {
    _receiverNameController.text = existingAddress?.receiverName ?? '';
    _receiverPhoneController.text = existingAddress?.receiverPhone ?? '';
  }

  String? selectedState = existingAddress?.state;
  bool? isDefaultAddress = existingAddress?.isDefault;
  int selectedAddressIndex = addressOptions.indexWhere((option) =>
      option[1].toLowerCase() == existingAddress?.addressType.toLowerCase());

  Future<void> saveAddress(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedAddressIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an address type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Initialize AddressService
      await AddressService.init();

      // Get all addresses to check if this is the first one
      final addresses = await AddressService.getAllAddresses();
      final isFirstAddress = addresses.isEmpty;

      // Initialize isDefaultAddress if it's null
      final bool defaultAddressValue = isDefaultAddress ?? isFirstAddress;

      // Create new address
      final newAddress = Address(
        addressType: addressOptions[selectedAddressIndex][1].toLowerCase(),
        flatNo: _flatNoController.text,
        floor: _floorController.text,
        area: _areaController.text,
        landmark: _landmarkController.text,
        receiverName: _receiverNameController.text,
        receiverPhone: _receiverPhoneController.text,
        city: _cityController.text,
        state: selectedState!,
        isDefault: defaultAddressValue, // Use the computed value
        isInUse: true,
      );

      // Save to Hive
      final box =
          await Hive.openBox<Address>('addresses'); // Ensure box is open
      await box.add(newAddress);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error saving address: $e'); // For debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving address: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateAddress(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedAddressIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an address type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create updated address using copyWith
      final updatedAddress = existingAddress?.copyWith(
        addressType: addressOptions[selectedAddressIndex][1].toLowerCase(),
        flatNo: _flatNoController.text,
        floor: _floorController.text,
        area: _areaController.text,
        landmark: _landmarkController.text,
        receiverName: _receiverNameController.text,
        receiverPhone: _receiverPhoneController.text,
        city: _cityController.text,
        state: selectedState,
        isDefault: isDefaultAddress,
      );

      // Get the Hive box
      final box = Hive.box<Address>('addresses');

      // Since existingAddress is a HiveObject, we can use its key directly
      await box.put(existingAddress?.key, updatedAddress!);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

      // If you're using a state management solution, refresh the UI
      // Provider.of<AddressProvider>(context, listen: false).refreshAddresses();
    } catch (e) {
      print('Error updating address: $e'); // For debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating address: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
    'Delhi',
    'Puducherry',
    'Ladakh',
    'Jammu and Kashmir'
  ];

  // Rest of your existing variables...

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void handleSaveAddress() {
            saveAddress(context, _formKey);
          }

          void handleUpdateAddress() {
            updateAddress(context, _formKey);
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                // Your existing header...
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // const Text(
                          //   'Edit address details',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     fontFamily: 'SemiBold',
                          //   ),
                          // ),
                          Text(
                            existingAddress == null
                                ? 'Add new address'
                                : 'Edit address details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.clear,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 3,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Your existing banner and radio buttons...
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
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  children: <Widget>[
                                    Icon(Icons.info_outline_rounded,
                                        color: Colors.red),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Please check address details for a hassel free delivery experience',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Who you are ordering for?',
                              style: TextStyle(
                                  fontFamily: 'Regular', fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.3,
                                        child: Radio<String>(
                                          value: 'myself',
                                          groupValue: orderingFor,
                                          activeColor: Colors.green,
                                          onChanged: (value) {
                                            setState(() {
                                              orderingFor = value!;
                                              if (existingAddress != null) {
                                                _receiverNameController.text =
                                                    existingAddress
                                                            .receiverName ??
                                                        '';
                                                _receiverPhoneController.text =
                                                    existingAddress
                                                            .receiverPhone ??
                                                        '';
                                              } else {
                                                // If no existing address, can set to current user's details
                                                final user =
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user;
                                                _receiverNameController.text =
                                                    user.email ?? '';
                                                _receiverPhoneController.text =
                                                    ''; // Set appropriate default
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const Text('Myself'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.3,
                                        child: Radio<String>(
                                          value: 'someone_else',
                                          groupValue: orderingFor,
                                          activeColor: Colors.green,
                                          onChanged: (value) {
                                            setState(() {
                                              orderingFor = value!;
                                              _receiverNameController.clear();
                                              _receiverPhoneController.clear();
                                            });
                                          },
                                        ),
                                      ),
                                      const Text('Someone else'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Save address as *',
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: addressOptions.length,
                                itemBuilder: (context, index) {
                                  bool isSelected =
                                      selectedAddressIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedAddressIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.green[50]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              addressOptions[index][0],
                                              color: isSelected
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              addressOptions[index][1],
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: 'Flat / House No. / Building Name *',
                              controller: _flatNoController,
                              focusNode: _flatNoFocus,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (value) {
                                print('Validating field: $value'); // Add this
                                if (value == null || value.isEmpty) {
                                  print(
                                      'Validation failed for: $value'); // Add this
                                  return 'This field is required';
                                }
                                return null;
                              },
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_floorFocus);
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(  
                              hintText: 'Floor',
                              controller: _floorController,
                              focusNode: _floorFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_areaFocus);
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Area / Sector / Locality *',
                              controller: _areaController,
                              focusNode: _areaFocus,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_landmarkFocus);
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Nearby landmark',
                              controller: _landmarkController,
                              focusNode: _landmarkFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_receiverNameFocus);
                              },
                            ),
                            const SizedBox(height: 20),

                            CustomTextField(
                              hintText: 'City *',
                              controller: _cityController,
                              focusNode: _cityFocus,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),

                            DropdownButtonFormField<String>(
                              value: selectedState,
                              items: states.map((String state) {
                                return DropdownMenuItem(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a state';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Changed to 10
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8, // Reduced vertical padding
                                ),
                                isDense: true, // Makes the field more compact
                              ),
                              dropdownColor: Colors.white,
                              isExpanded:
                                  true, // Ensures dropdown takes full width
                            ),
                            const SizedBox(height: 20),
                            Text(
                              orderingFor == 'myself'
                                  ? "Enter your details for a seamless delivery experience"
                                  : "Add receiver's details for a seamless delivery experience",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: orderingFor == 'myself'
                                  ? "Your name *"
                                  : "Receiver's name *",
                              controller: _receiverNameController,
                              focusNode: _receiverNameFocus,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_receiverPhoneFocus);
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: orderingFor == 'myself'
                                  ? "Your phone number *"
                                  : "Receiver's phone number *",
                              controller: _receiverPhoneController,
                              focusNode: _receiverPhoneFocus,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.phone,
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            existingAddress?.key != null
                                ? GestureDetector(
                                    onTap: () =>
                                        updateAddress(context, _formKey),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Update Address',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => saveAddress(context, _formKey),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Save Address',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
