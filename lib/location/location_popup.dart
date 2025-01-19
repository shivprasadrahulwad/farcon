import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/location/set_location.dart';
import 'package:farcon/providers/user_provider.dart';



class LocationPopup extends StatefulWidget {
    static const String routeName = '/location-popup';
  const LocationPopup({super.key});

  @override
  _LocationPopupState createState() => _LocationPopupState();
}

class _LocationPopupState extends State<LocationPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Duration for opening/closing
    );

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start the animation when the dialog opens
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the animation controller when the widget is disposed
    super.dispose();
  }

  Future<void> checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
    } else {
      print("Location services are enabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show custom Snackbar when back button is pressed
        _showCustomSnackbar(context, 'Please select a delivery location');
        return false; // Prevent the dialog from closing
      },
      child: GestureDetector(
        onTap: () {
          // Show custom Snackbar when tapping outside the dialog
          _showCustomSnackbar(context, 'Set current location');
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 34, vertical: 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Prevent tapping inside the dialog from triggering Snackbar
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/mark.png',
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Location permission not',
                          style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'enabled',
                          style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Please enable location permission for a',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'better delivery experience',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            // Update location status and close the dialog
                            Provider.of<UserProvider>(context, listen: false).setLocationStatus(true);
                            Navigator.of(context).pop();
                            // AddressBottomSheet(context);
                          },
                          child: const Text(
                            'Enable device location',
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.greenColor,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Update location status and navigate to SetLocation
                            Provider.of<UserProvider>(context, listen: false).setLocationStatus(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SetLocation()),
                            );
                          },
                          child: const Text(
                            'Select location manually',
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomSnackbar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.only(left: 23, right: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay entry after a duration with a fade-out
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
