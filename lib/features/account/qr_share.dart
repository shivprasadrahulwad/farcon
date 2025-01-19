import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:farcon/constants/global_variables.dart'; // Ensure you have this dependency

// class QrShare extends StatelessWidget {
//   final String name;
//   final String shopId;
//   final String qrData;

//   const QrShare({
//     Key? key,
//     required this.name,
//     required this.shopId,
//     required this.qrData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: GlobalVariables.blueBackground, // Change to your desired background color
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 35,
//                   height: 35,
//                   decoration: BoxDecoration(
//                     color: Colors.blueGrey,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'S',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontFamily: 'SemiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             RepaintBoundary(
//               key: ValueKey(qrData), // Ensures the QR code is unique based on data
//               child: Center(
//                 child: BarcodeWidget(
//                   barcode: Barcode.qrCode(),
//                   color: Colors.black,
//                   data: qrData,
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Scan this code to shop with us',
//               style: TextStyle(
//                 fontFamily: 'Regular',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Shop ID: $shopId',
//               style: const TextStyle(
//                 fontFamily: 'SemiBold',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }



class QrShare extends StatelessWidget {
  final String name;
  final String shopId;
  final String qrData;

  const QrShare({
    Key? key,
    required this.name,
    required this.shopId,
    required this.qrData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: GlobalVariables.blueBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'SemiBold',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            RepaintBoundary(
              key: ValueKey(qrData),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BarcodeWidget(
                    barcode: Barcode.qrCode(
                      errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                    ),
                    color: Colors.black,
                    data: qrData,
                    width: 200,
                    height: 200,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      'assets/images/offer.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Scan this code to shop with us',
              style: TextStyle(
                fontFamily: 'Regular',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Shop ID: $shopId',
              style: const TextStyle(
                fontFamily: 'SemiBold',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}