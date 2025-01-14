import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/location/set_location.dart';

void SelectLocationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    backgroundColor: GlobalVariables.backgroundColor,
    isScrollControlled: true,
    isDismissible: true, // Allow the bottom sheet to be dismissed
    enableDrag: true, // Allow dragging to dismiss
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SemiBold',
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetLocation()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Go to current location',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalVariables.greenColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ),
                      Icon(CupertinoIcons.right_chevron, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your saved addresses',
                style: TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.home, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Home Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '123 Main Street, City, Country',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showSnackBarOverlay(BuildContext context) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).viewPadding.top + 20,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Please select location',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the overlay entry after a delay
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}