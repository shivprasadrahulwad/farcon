import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/features/auth/screens/signIn_screen.dart';
import 'package:farcon/features/auth/services/auth_services.dart';
import 'package:farcon/features/user/screens/code_input_screen.dart';
import 'package:farcon/local_storage/models/CartItem.dart';
import 'package:farcon/local_storage/models/UserLocation.dart';
import 'package:farcon/local_storage/models/address.dart';
import 'package:farcon/local_storage/models/shopInfo.dart';
import 'package:farcon/location/address_services.dart';
import 'package:farcon/notification/notifications.dart';
import 'package:farcon/providers/shop_details_provider.dart';
import 'package:farcon/providers/user_provider.dart';
import 'package:farcon/router.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'local_storage/models/LikedProduct.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Hive.initFlutter();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final notificationService = NotificationService(navigatorKey: navigatorKey);
  await notificationService.initNotification();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  // Hive.registerAdapter(LikedProductsAdapter());
  // await Hive.openBox<LikedProduct>('likedProducts');
   // Register Hive adapters
  Hive.registerAdapter(LikedProductAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(UserLocationAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(ShopInfoAdapter());


  // Open Hive boxes
  await Hive.openBox<LikedProduct>('likedProducts');
  await Hive.openBox<CartItem>('cartItems');
  await Hive.openBox<UserLocation>('userLocations');
  await Hive.openBox<ShopInfo>('shopInfo');
  // await Hive.openBox<Address>('addresses');
  await AddressService.init();

  
  runApp(
    MultiProvider(
      providers: [
        
        // ChangeNotifierProvider(create: (context) => UserProvider()..initializeCart()),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider<UserProvider>(create: (context) {
          final userProvider = UserProvider();
          // userProvider.initializeCartFromHive(context); // Initialize cart from Hive
          return userProvider;
        }),

        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ShopDetailsProvider()),

      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'farcon',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        fontFamily: 'Poppins',
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.user.token.isNotEmpty) {
            return userProvider.user.type == 'user'
                ? CodeInputScreen()
                : userProvider.user.type == 'admin'
                    ? const CodeInputScreen()
                    : const SignInScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}