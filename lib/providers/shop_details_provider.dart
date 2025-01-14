
import 'package:flutter/material.dart';
import 'package:shopez/features/user/services/home_services.dart';
import 'package:shopez/models/category.dart';
import 'package:shopez/models/charges.dart';
import 'package:shopez/models/coupon.dart';
import 'package:shopez/models/shopDetails.dart';

class ShopDetailsProvider with ChangeNotifier {
  ShopDetails? _shopDetails;
  bool _isLoading = false;
  String? _error;

  ShopDetails? get shopDetails => _shopDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeShopDetails(BuildContext context) async {
    print('🚀 ENTRY POINT: initializeShopDetails called');  // Add this line
    if (_shopDetails != null) {
      print('⏭️ Shop details already exist, skipping initialization');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    print('⌛ Setting loading state to true');

    try {
      print('📞 Creating HomeServices instance');  // Add this line
      final homeServices = HomeServices();
      
      print('🔥 About to call fetchShopDetails');  // Add this line
      await HomeServices.fetchShopDetailsByCode(context, "123456");
      print('✅ fetchShopDetails completed');  // Add this line
      
      _error = null;
    } catch (e) {
      print('💥 Error in initializeShopDetails: $e');  // Enhanced error logging
      print('💥 Stack trace: ${StackTrace.current}');  // Add stack trace
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print('⌛ Setting loading state to false');
    }
  }

  void setShopDetails(ShopDetails shopDetails) {
    print('📝 Setting shop details: ${shopDetails.shopName}');
    _shopDetails = shopDetails;
    _isLoading = false;
    _error = null;
    notifyListeners();
    print('✅ Shop details updated successfully');
  }

List<Coupon> fetchLatestCoupons() {
  try {
    if (_shopDetails?.coupon == null) {
      print('📋 No coupon data available');
      return [];
    }

    print('🎫 Processing coupon data: ${_shopDetails!.coupon}');
    
    // Access the coupons array directly
    final couponsData = _shopDetails!.coupon!['coupons'] as List;
    print('📝 Found ${couponsData.length} coupons');
    
    final List<Coupon> processedCoupons = [];
    
    for (var i = 0; i < couponsData.length; i++) {
      try {
        final couponMap = couponsData[i] as Map<String, dynamic>;
        final coupon = Coupon.fromMap(couponMap);
        print('✅ Successfully processed coupon ${i + 1}:');
        print('- Code: ${coupon.couponCode}');
        print('- Discount: ${coupon.off}%');
        print('- Min Price: ₹${coupon.price}');
        processedCoupons.add(coupon);
      } catch (e) {
        print('⚠️ Error processing coupon at index $i: $e');
      }
    }
    
    print('🎉 Successfully processed ${processedCoupons.length} coupons');
    return processedCoupons;
  } catch (e, stackTrace) {
    print('💥 Error processing coupons: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}



  void updateShopDetails({
    String? shopName,
    String? number,
    String? address,
    String? shopCode,
    List<Category>? categories,
    double? delPrice,
    Map<String, dynamic>? coupon,
    Map<String, dynamic>? offerImages,
    Map<String, dynamic>? offerDes,
    DateTime? offertime,
    List<String>? socialLinks,
    DateTime? lastUpdated,
    Charges? charges,
  }) {
    print('🔄 Updating shop details...');
    print('Previous state: ${_shopDetails?.shopName}');
    
    if (_shopDetails != null) {
      _shopDetails = _shopDetails!.copyWith(
        shopName: shopName,
        number: number,
        address: address,
        shopCode: shopCode,
        categories: categories,
        delPrice: delPrice,
        coupon: coupon,
        offerImages: offerImages,
        offerDes: offerDes,
        offertime: offertime,
        socialLinks: socialLinks,
        lastUpdated: lastUpdated,
        charges: charges,
      );
      print('✅ Shop details updated successfully');
      print('New state: ${_shopDetails?.shopName}');
      notifyListeners();
    } else {
      print('⚠️ Cannot update: Shop details are null');
    }
  }

    double get averageRating {
    if (_shopDetails?.rating != null && _shopDetails!.rating!.isNotEmpty) {
      double total = _shopDetails!.rating!.map((r) => r.rating).reduce((a, b) => a + b);
      return total / _shopDetails!.rating!.length;
    }
    return 0.0; // Default if no ratings
  }


  void clearShopDetails() {
    print('🗑️ Clearing shop details');
    _shopDetails = null;
    notifyListeners();
    print('✅ Shop details cleared');
  }
}