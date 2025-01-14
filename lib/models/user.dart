// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String password;
//   final String address;
//   final String type;
//   final String token;
//   String? shopCode;
//   final List<Map<String, dynamic>> cart;
//   final List<dynamic> shopCodes;
//   final List<dynamic> likedProducts;
//   String? time;
//   bool? locationStatus;
//   Map<String, double> location;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.address,
//     required this.type,
//     required this.token,
//     required this.cart,
//     required this.shopCodes, 
//     required this.likedProducts,
//     this.shopCode,
//     this.time,
//     this.locationStatus,
//     required this.location,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'password': password,
//       'address': address,
//       'type': type,
//       'token': token,
//       'cart': cart,
//       'shopCodes': shopCodes,
//       'likedProducts':likedProducts,
//       'time': time,
//       'shopCode': shopCode,
//       'locationStatus':locationStatus,
//       'location': location,
//     };
//   }

//   factory User.fromMap(Map<String, dynamic> map) {
//     print("Initializing User from Map: $map");
//     return User(
//       id: map['_id'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       password: map['password'] ?? '',
//       address: map['address'] ?? '',
//       type: map['type'] ?? '',
//       token: map['token'] ?? '',
//       shopCode: map['shopCode'] ?? '',
//       cart: List<Map<String, dynamic>>.from(
//         map['cart']?.map(
//           (x) => Map<String, dynamic>.from(x),
//         ),
//       ),
//       shopCodes: List<Map<String, dynamic>>.from(
//         map['shopCodes']?.map(
//           (x) => Map<String, dynamic>.from(x),
//         ),
//       ),
      
//       likedProducts: List<Map<String, dynamic>>.from(
//         map['likedProducts']?.map(
//           (x) => Map<String, dynamic>.from(x),
//         ),
//       ),
//       time: map['time'] ?? '',
//       locationStatus: map['locationStatus'] != null ? map['locationStatus'] as bool : null,
//      location: {
//         'latitude': (map['location']?['latitude'] ?? 0).toDouble(),
//         'longitude': (map['location']?['longitude'] ?? 0).toDouble(),
//       },
//     );
//   }
  
//   String toJson() => json.encode(toMap());

//   factory User.fromJson(String source) => User.fromMap(json.decode(source));

//   User copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? password,
//     String? address,  
//     String? type,
//     String? token,
//     String? shopCode,
//     List<dynamic>? cart,
//     List<dynamic>? shopCodes,
//     List<dynamic>? likedProducts,
//     String? time,
//     bool? locationStatus,
//     Map<String, double>? location,
//   }) {
//     return User(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       address: address ?? this.address,
//       type: type ?? this.type,
//       token: token ?? this.token,
//       cart: cart ?? this.cart,
//       shopCodes: shopCodes ?? this.shopCodes,
//       likedProducts: likedProducts ?? this.likedProducts,
//       time: time ?? this.time,
//       shopCode: shopCode ?? this.shopCode,
//       locationStatus: locationStatus ?? this.locationStatus,
//       location: location ?? this.location,
//     );
//   }
// }



import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  String? shopCode;
  late final List<Map<String, dynamic>> cart; // Updated: cart is now List<Map<String, dynamic>>
  final List<dynamic> shopCodes;
  final List<dynamic> likedProducts;
  String? time;
  bool? locationStatus;
  Map<String, double> location;
  int? cartTotal;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart, // cart as List<Map<String, dynamic>>
    required this.shopCodes,
    required this.likedProducts,
    this.shopCode,
    this.time,
    this.locationStatus,
    required this.location, 
    this.cartTotal,
  });

  // Converts the User object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart, // cart is already correctly typed as List<Map<String, dynamic>>
      'shopCodes': shopCodes,
      'likedProducts': likedProducts,
      'time': time,
      'shopCode': shopCode,
      'locationStatus': locationStatus,
      'location': location,
      'cartTotal':cartTotal,
    };
  }

  // Factory method to initialize User from a Map<String, dynamic>
  factory User.fromMap(Map<String, dynamic> map) {
    print("Initializing User from Map: $map");
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      shopCode: map['shopCode'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ), // cart conversion to List<Map<String, dynamic>>
      shopCodes: List<dynamic>.from(map['shopCodes'] ?? []),
      likedProducts: List<dynamic>.from(map['likedProducts'] ?? []),
      time: map['time'] ?? '',
      locationStatus: map['locationStatus'] != null ? map['locationStatus'] as bool : null,
      location: {
        'latitude': (map['location']?['latitude'] ?? 0).toDouble(),
        'longitude': (map['location']?['longitude'] ?? 0).toDouble(),
      },
      cartTotal: map['cartTotal'] ?? 0,
    );
  }

  // Converts the User object to a JSON string
  String toJson() => json.encode(toMap());

  // Factory method to initialize User from a JSON string
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // CopyWith method for creating a copy of the User object with optional new values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    String? shopCode,
    List<Map<String, dynamic>>? cart, // cart type updated here too
    List<dynamic>? shopCodes,
    List<dynamic>? likedProducts,
    String? time,
    bool? locationStatus,
    Map<String, double>? location,
    int? cartTotal,

  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart, // cart type consistency
      shopCodes: shopCodes ?? this.shopCodes,
      likedProducts: likedProducts ?? this.likedProducts,
      time: time ?? this.time,
      shopCode: shopCode ?? this.shopCode,
      locationStatus: locationStatus ?? this.locationStatus,
      location: location ?? this.location,
      cartTotal: cartTotal ?? this.cartTotal, 
    );
  }
}
