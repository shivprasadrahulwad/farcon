import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shopez/constants/global_variables.dart';

class QRScanPage extends StatefulWidget {
  static const String routeName = '/scan';

  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  void initState() {
    super.initState();
    // Trigger the QR code scanner when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scanQRCode();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back, // Back arrow icon
        color: GlobalVariables.greenColor, // Set the color to match your design
      ),
      onPressed: () {
        Navigator.pop(context); // Navigate back to the previous screen
      },
    ),
    title: const Text(
      'Scan QR',
      style: TextStyle(
        fontFamily: 'Regular',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: GlobalVariables.greenColor,
      ),
    ),
  ),
  body: Stack(
    children: [
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scan Result',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // You can add the QR code result text here if needed
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0), // 50 pixels from the bottom
          child: IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
              size: 25,
            ), // Scan icon
            onPressed: () async {
              Navigator.pushNamed(context, '/scan');
            },
          ),
        ),
      ),
    ],
  ),
);


  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      // Pass the scanned result back to the parent screen
      Navigator.pop(context, qrCode);
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
      Navigator.pop(context, qrCode); // Pass the error back if scanning fails
    }
  }
}


// class CustomQRScanPage extends StatefulWidget {
//   static const String routeName = '/custom-scan';

//   @override
//   State<StatefulWidget> createState() => _CustomQRScanPageState();
// }

// class _CustomQRScanPageState extends State<CustomQRScanPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String qrCode = 'Unknown';

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: GlobalVariables.greenColor,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Scan QR',
//           style: TextStyle(
//             fontFamily: 'Regular',
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: GlobalVariables.greenColor,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           buildQrView(context), // Camera preview for QR code
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 50.0),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.qr_code_scanner,
//                   color: Colors.black,
//                   size: 50, // Adjust icon size here
//                 ),
//                 onPressed: () {
//                   // Custom icon for QR scanning
//                   // Here you can trigger a function like re-scanning or show other UI elements
//                 },
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 50.0),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Align QR Code within the frame',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Icon(Icons.qr_code_rounded, size: 50, color: Colors.white70),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQrView(BuildContext context) {
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: GlobalVariables.greenColor,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: MediaQuery.of(context).size.width * 0.7,
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         qrCode = scanData.code ?? 'Unknown';
//       });

//       // Once scanned, navigate back with the result
//       Navigator.pop(context, qrCode);
//     });
//   }
// }
