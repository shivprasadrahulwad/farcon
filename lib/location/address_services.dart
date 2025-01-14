import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:shopez/local_storage/models/address.dart';


class AddressService {
  static const String boxName = 'addresses';
  static bool _isInitialized = false;

  // Initialize Hive and open the box
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Register the Address adapter if not already registered
      if (!Hive.isAdapterRegistered(3)) { // 3 is the typeId we defined in Address class
        Hive.registerAdapter(AddressAdapter());
      }

      // Check if box is already open
      if (!Hive.isBoxOpen(boxName)) {
        try {
          // Try to open the box normally first
          await Hive.openBox<Address>(boxName);
        } catch (e) {
          print('Error opening box: $e');
          
          // Get the application documents directory
          final appDir = await path_provider.getApplicationDocumentsDirectory();
          final boxPath = '${appDir.path}/hive/$boxName';
          
          // Safely try to delete corrupted box files
          try {
            if (await File('$boxPath.hive').exists()) {
              await File('$boxPath.hive').delete();
            }
            if (await File('$boxPath.lock').exists()) {
              await File('$boxPath.lock').delete();
            }
          } catch (e) {
            print('Error deleting box files: $e');
          }

          // Try to open the box again after cleaning up
          await Hive.openBox<Address>(boxName);
        }
      }
      
      _isInitialized = true;
    } catch (e) {
      print('Fatal error initializing address box: $e');
      // If all attempts fail, throw a more user-friendly error
      throw Exception('Unable to initialize address storage. Please restart the app.');
    }
  }

  // Get the address box with initialization check
  static Box<Address> _getBox() {
    if (!_isInitialized) {
      throw StateError('AddressService not initialized. Call init() first.');
    }
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError('Address box is not open.');
    }
    return Hive.box<Address>(boxName);
  }

  // Update existing address with validation
  static Future<void> updateAddress(String key, Address address) async {
  if (!address.isValid()) {
    throw ArgumentError('Invalid address data');
  }

  final box = _getBox();
  
  if (!box.containsKey(key)) {
    throw ArgumentError('Address with key $key not found');
  }

  try {
    if (address.isDefault) {
      await _updateOtherAddressesDefault();
    }

    if (address.isInUse) {
      await _updateOtherAddressesInUse();
    }

    await box.put(key, address);
  } catch (e) {
    print('Error updating address: $e');
    rethrow;
  }
}
  // Add this new method for adding addresses
  static Future<void> addAddress(Address address) async {
    if (!_isInitialized) {
      await init();
    }

    if (!address.isValid()) {
      throw ArgumentError('Invalid address data');
    }

    final box = _getBox();

    try {
      // If this is the first address or marked as default
      if (box.isEmpty || address.isDefault) {
        await _updateOtherAddressesDefault();
      }

      // If this address is marked as in use
      if (address.isInUse) {
        await _updateOtherAddressesInUse();
      }

      // Add the new address to the box
      await box.add(address);
    } catch (e) {
      print('Error adding address: $e');
      throw Exception('Failed to save address: $e');
    }
  }

  // Delete address with validation
  static Future<void> deleteAddress(int index) async {
    final box = _getBox();
    
    if (index < 0 || index >= box.length) {
      throw RangeError('Invalid address index');
    }

    try {
      await box.deleteAt(index);
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }

  // Get all addresses with error handling
  static List<Address> getAllAddresses() {
    try {
      final box = _getBox();
      return box.values.where((address) => address.isValid()).toList();
    } catch (e) {
      print('Error getting addresses: $e');
      return [];
    }
  }

  // Get default address with error handling
  static Address? getDefaultAddress() {
    try {
      final box = _getBox();
      return box.values.firstWhere(
        (address) => address.isValid() && address.isDefault,
        orElse: () => box.values.firstWhere(
          (address) => address.isValid(),
          orElse: () => throw StateError('No valid addresses found'),
        ),
      );
    } catch (e) {
      print('Error getting default address: $e');
      return null;
    }
  }

  // Helper methods remain the same but with added error handling
  static Future<void> _updateOtherAddressesDefault() async {
    final box = _getBox();
    try {
      for (var i = 0; i < box.length; i++) {
        final address = box.getAt(i);
        if (address != null && address.isDefault) {
          address.isDefault = false;
          await box.putAt(i, address);
        }
      }
    } catch (e) {
      print('Error updating other addresses default status: $e');
      rethrow;
    }
  }

  static Future<void> _updateOtherAddressesInUse() async {
    final box = _getBox();
    try {
      for (var i = 0; i < box.length; i++) {
        final address = box.getAt(i);
        if (address != null && address.isInUse) {
          address.isInUse = false;
          await box.putAt(i, address);
        }
      }
    } catch (e) {
      print('Error updating other addresses in-use status: $e');
      rethrow;
    }
  }
}