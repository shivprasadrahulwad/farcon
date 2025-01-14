import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopez/constants/error_handeling.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/constants/utils.dart';
import 'package:shopez/models/shopInfo.dart';
import 'package:shopez/models/user.dart';
import 'package:shopez/providers/user_provider.dart';

class ShopInfoServices {
  void addShopCode({
  required BuildContext context,
  required String shopCode,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  try {
    if (shopCode.isEmpty) {
      throw Exception("Shop code cannot be empty");
    }

    if (userProvider.user.token.isEmpty) {
      throw Exception("User token is missing");
    }

    final response = await http.post(
      Uri.parse('$uri/api/add-to-shopcodes'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'shopCode': shopCode,
      }),
    );

    print('-----------------------------------$shopCode');

    if (response.statusCode == 200) {
      final Map<String, dynamic> userMap = jsonDecode(response.body);
      final user = User.fromMap(userMap);
      userProvider.setUserFromModel(user);
      print('Shop code added successfully');
    } else {
      print('Failed to add shop code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error adding shop code: $e');
  }
}


// Future<List<shopInfo>> fetchShopInfo({
//   required BuildContext context,
//   required String userId,
// }) async {
//   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   List<shopInfo> shopInfoList = [];
//   try {
//     print('Fetching shop info for user: $userId');
//     final Uri url = Uri.parse('$uri/api/user/$userId/shopCodes');
//     http.Response res = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'x-auth-token': userProvider.user.token,
//       },
//     );
//     print('Response status code: ${res.statusCode}');
//     print('Response body: ${res.body}');

//     httpErrorHandle(
//       response: res,
//       context: context,
//       onSuccess: () {
//         print('Processing response...');
//         final List<dynamic> responseData = jsonDecode(res.body);
//         for (var item in responseData) {
//           print('Adding shop info to shopInfoList: $item');
//           shopInfoList.add(shopInfo.fromJson(item));
//         }
//       },
//     );
//   } catch (e) {
//     print('Error occurred: $e');
//     showSnackBar(context, e.toString());
//   }
//   print('Returning shopInfoList: $shopInfoList');
//   return shopInfoList;
// }

Future<List<shopInfo>> fetchShopInfo({
  required BuildContext context,
  required String userId,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  List<shopInfo> shopInfoList = [];
  try {
    print('Fetching shop info for user: $userId');
    final Uri url = Uri.parse('$uri/api/user/$userId/shopCodes');
    http.Response res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );
    print('Response status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        print('Processing response...');
        final List<dynamic> responseData = jsonDecode(res.body);

        for (var item in responseData) {
          if (item is Map<String, dynamic>) {
            // Extract the nested shopInfo map
            final shopInfoData = item['shopInfo'];
            if (shopInfoData is Map<String, dynamic>) {
              print('Adding shop info to shopInfoList: $shopInfoData');
              shopInfoList.add(shopInfo.fromMap(shopInfoData));
            } else {
              print('Unexpected shopInfo format: $shopInfoData');
            }
          } else {
            print('Unexpected item format: $item');
          }
        }
      },
    );
  } catch (e) {
    print('Error occurred: $e');
    CustomSnackBar.show(context, e.toString());
  }
  print('Returning shopInfoList: $shopInfoList');
  return shopInfoList;
}



}
