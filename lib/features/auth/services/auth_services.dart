import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farcon/constants/error_handeling.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/constants/utils.dart';
import 'package:farcon/features/user/screens/home_screen.dart';
import 'package:farcon/models/user.dart';
import 'package:farcon/providers/user_provider.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [], 
        shopCodes: [], 
        likedProducts: [], location: {},
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          CustomSnackBar.show(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }

  void signInUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/api/signin'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

      // Navigate to HomeSplashScreen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const HomeSplashScreen(),
      //   ),
      // );

      // Wait for 3 seconds and then navigate to BottomBar
      Timer(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      });
    } else {
      throw Exception('Failed to sign in: ${res.statusCode}');
    }
  } catch (e) {
    CustomSnackBar.show(context, 'Error: $e');
  }
}


   void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }
}