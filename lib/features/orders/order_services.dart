import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:farcon/constants/error_handeling.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/constants/utils.dart';
import 'package:farcon/models/order.dart';
import 'package:farcon/providers/user_provider.dart';

class OrderServices{
  //user fetch alll orders
//fetch all past orders of user
 Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    const String shopId = '123456'; 
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
    return orderList;
  }

}