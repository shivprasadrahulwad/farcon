import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/user/screens/home_screen.dart';
import 'package:shopez/features/user/services/shopInfo_services.dart';
import 'package:shopez/models/shopInfo.dart';
import 'package:shopez/providers/user_provider.dart';
import 'package:shopez/models/shopDetails.dart';


class CodeInputScreen extends StatefulWidget {
  const CodeInputScreen({super.key});

  @override
  _CodeInputScreenState createState() => _CodeInputScreenState();
}

class _CodeInputScreenState extends State<CodeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  String _errorMessage = '';
  List<shopInfo>? codes;
  String qrResult = 'No Result';
  final shopInfoServices = ShopInfoServices();
  int? selected;
  String? _selectedShopCode;

  void _showBottomSheet1(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: codes == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Choose shop",
                                style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          for (var i = 0; i < codes!.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedIndex == i
                                      ? GlobalVariables.blueBackground
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _selectedIndex == i
                                        ? GlobalVariables.blueTextColor
                                        : Colors.grey.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        // color: GlobalVariables.blueBackground,
                                        color: _selectedIndex == i
                                            ? Colors.white
                                            : GlobalVariables.blueBackground,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Icon(Icons.store,
                                          size: 30,
                                          color: GlobalVariables.blueTextColor),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            codes![i].shopName ?? 'No Name',
                                            style: const TextStyle(
                                              fontFamily: 'SemiBold',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${codes![i].shopCode}',
                                            style: const TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${codes![i].address}',
                                            style: const TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 12,
                                              color:
                                                  GlobalVariables.greyTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Radio(
                                        value: i,
                                        groupValue: _selectedIndex,
                                        activeColor:
                                            GlobalVariables.blueTextColor,
                                        onChanged: (int? value) {
                                          setModalState(() {
                                            _selectedIndex = value!;
                                            _selectedShopCode =
                                                codes![value].shopCode;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: GlobalVariables.lightGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        const Color.fromARGB(255, 90, 228, 44),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Expanded(
                                  child: Text(
                                    'Select which shop store you want to see',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _verifyCode();
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        GlobalVariables.greenColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text('Continue',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }

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
                    'Shop code',
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
                                    'Shop code of 6 characters',
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
                                      Icons.lock,
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
                                    color:
                                        const Color.fromARGB(255, 90, 228, 44),
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
                                'Shopkeeper will provided you',
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
                                    color:
                                        const Color.fromARGB(255, 90, 228, 44),
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
                                'Unique identity of shop',
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
                                    color:
                                        const Color.fromARGB(255, 90, 228, 44),
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
                                  "Used shop codes access from 'Used codes'",
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

  Widget customRadio(IconData icon, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (selected == index) {
            selected = null; // Unselect
          } else {
            selected = index; // Select
          }
        });
      },
      child: Icon(
        icon,
        size: 20,
        color: (selected == index) ? Colors.red : Colors.grey,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10)), 
        backgroundColor: Colors.transparent, 
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // fetchShopInfo(); 
  }

  int? _selectedIndex;

  void _verifyCode() async {
    String qrCode = '000000';
    String shopCode = _selectedShopCode ??
        _controllers.map((controller) => controller.text).join();

    if (shopCode.isNotEmpty  || qrCode.isNotEmpty && qrCode.length< 6  && qrCode.length > 6 ) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      try {
        final response = await http.post(
          Uri.parse('$uri/api/verify-code'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({'shopCode': shopCode}),
        );

        if (response.statusCode == 200) {
          print('Shop code verified successfully');
          await addShopCode(shopCode);

          GlobalVariables.setShopCode(shopCode);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(shopCode: shopCode),
            ),
          );
        } else {
          print('Failed to verify shop code: ${response.body}');
          setState(() {
            _errorMessage = 'Shop with this code not found';
          });
        }
      } catch (e) {
        print('Error verifying shop code: $e');
        setState(() {
          _errorMessage = 'Error verifying shop code';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Shop code is required';
      });
    }
  }

  Future<void> addShopCode(String shopCode) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('$uri/api/add-to-shopcodes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'shopCode': shopCode}),
      );

      if (response.statusCode == 200) {
        print('Shop code added successfully');
        // fetchShopInfo(); 
      } else {
        print('Failed to add shop code: ${response.body}');
      }
    } catch (e) {
      print('Error adding shop code: $e');
    }
  }

  // void fetchShopInfo() async {
  //   codes = await shopInfoServices.fetchShopInfo(
  //     context: context,
  //     userId: Provider.of<UserProvider>(context, listen: false).user.id,
  //   );
  //   setState(() {}); 
  // }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<UserProvider>(context)
        .user
        .cart
        .cast<Map<String, dynamic>>();
    final cart = context.watch<UserProvider>().user.cart;
    final rem = carts.isEmpty ? 0 : carts.length;
    final percent = rem / 6; // Example calculation

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            Container(), // To keep the space for leading icon but keep it empty
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
              size: 25,
            ), // Scan icon
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/scan');
              if (result != null) {
                setState(() {
                  qrResult = result as String; // Cast the result to String
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your shop Code',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Enter your Shop code number",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.greyBlueColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 15,
                          ))
                    ],
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return _textFieldOTP(
                                controller: _controllers[index],
                                first: index == 0,
                                last: index == 5,
                              );
                            }),
                          ),
                          const SizedBox(height: 30),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _verifyCode();
                                // addShopCode();
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        GlobalVariables.greenColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text('Continue',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't remember shop code?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.greyBlueColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // _isFloatingContainerOpen =
                            //     !_isFloatingContainerOpen;
                            _showBottomSheet1(context);
                          });
                        },
                        child: const Text(
                          "Used codes",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.greenColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldOTP({
    required TextEditingController controller,
    required bool first,
    required bool last,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 43,
        width: 43,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            onChanged: (value) {
              if (value.length == 1 && !last) {
                FocusScope.of(context).nextFocus();
              }
              if (value.length == 0 && !first) {
                FocusScope.of(context).previousFocus();
              }
            },
            showCursor: false,
            readOnly: false,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            maxLength: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              counter: const Offstage(),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: GlobalVariables.greenColor),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
