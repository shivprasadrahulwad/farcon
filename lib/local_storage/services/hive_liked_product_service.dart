// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:shopez/local_storage/models/LikedProduct.dart';

// class HiveLikedProductService {
//   static const String _boxName = 'likedProducts';

//   Future<void> init() async {
//     await Hive.initFlutter();
//     if (!Hive.isAdapterRegistered(0)) {
//       Hive.registerAdapter(LikedProductAdapter());
//     }
//     await Hive.openBox<LikedProduct>(_boxName);
//   }

//   Future<void> addLikedProduct(LikedProduct product) async {
//     final box = Hive.box<LikedProduct>(_boxName);
//     await box.put(product.id, product);
//   }

//   Future<void> removeLikedProduct(String productId) async {
//     final box = Hive.box<LikedProduct>(_boxName);
//     await box.delete(productId);
//   }

//   List<LikedProduct> getAllLikedProducts() {
//     final box = Hive.box<LikedProduct>(_boxName);
//     return box.values.toList();
//   }

//   bool isProductLiked(String productId) {
//     final box = Hive.box<LikedProduct>(_boxName);
//     return box.containsKey(productId);
//   }

//   Future<void> clearAllLikedProducts() async {
//     final box = Hive.box<LikedProduct>(_boxName);
//     await box.clear();
//   }
// }