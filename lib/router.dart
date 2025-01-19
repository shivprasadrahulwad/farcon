import 'package:flutter/material.dart';
import 'package:farcon/coupon/coupon_screen.dart';
import 'package:farcon/features/account/account_screen.dart';
import 'package:farcon/features/account/qr_create_screen.dart';
import 'package:farcon/features/auth/screens/signUp_screen.dart';
import 'package:farcon/features/auth/screens/signin_screen.dart';
import 'package:farcon/features/cart/cart_screen.dart';
import 'package:farcon/features/orders/order_details_screen.dart';
import 'package:farcon/features/orders/order_history_screen.dart';
import 'package:farcon/features/payment/payment_options.dart';
import 'package:farcon/features/user/screens/home_screen.dart';
import 'package:farcon/features/user/screens/product_details._screen.dart';
import 'package:farcon/features/user/screens/shop_screen.dart';
import 'package:farcon/location/address_list_screen.dart';
import 'package:farcon/location/location_popup.dart';
import 'package:farcon/location/set_location.dart';
import 'package:farcon/models/order.dart';
import 'package:farcon/models/product.dart';
import 'package:farcon/sample_screen.dart';
import 'package:farcon/scanner/qr_scanner_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignInScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignInScreen(),
      );

    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );


    case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AccountScreen(),
      );

    case ProductInfoScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductInfoScreen(),
      ); 

    case ShopDetailsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ShopDetailsScreen(),
      );    
    
    case UserCartProducts.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UserCartProducts(totalPrice: 0, address: '', index: 0, instruction: [], tips: null, totalSave: '', shopCode: '', note: null, number: null, name: null, paymentType: 0, location: null,),
      );

    case CouponScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CouponScreen(),
      );

    case ProductDetailsScreen.routeName:
      final product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailsScreen(product: product),
      );  

    case QRCreateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => QRCreateScreen(),
      );  

    case QRScanPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => QRScanPage(),
      );

    case OrderHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderHistoryScreen( userId: '',),
      );

    case PaymentOptions.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PaymentOptions(),
      );

    // case ShopInfoScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => ShopInfoScreen(),
    //   );  

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(shopCode: '',),
      );  

    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(order: order),
      );

    case SetLocation.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SetLocation(),
      );

    case LocationPopup.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LocationPopup(),
      );  
      
    // case AddAddressScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => AddAddressScreen(),
    //   );

    case AddressListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressListScreen(),
      ); 

    case AddressScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(),
      );    


    case FshopScreen.routeName:
      var args = routeSettings.arguments as Map<String,
          dynamic>; // Assuming arguments contain both category and userId
      var category = args['category']; // Extracting category from arguments
      var shopCode = args['shopCode']; // Extracting userId from arguments
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FshopScreen(
          category: category,
          shopCode: shopCode, // Pass userId to shopScreen
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen Dosen't Exist !!!"),
          ),
        ),
      );
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Error: $message'),
      ),
    ),
  );
}
