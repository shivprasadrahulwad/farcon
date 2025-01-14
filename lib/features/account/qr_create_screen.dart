import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/constants/utils.dart';
import 'package:shopez/features/account/qr_share.dart';

// class QRCreateScreen extends StatefulWidget {
//   static const String routeName = '/qr-create';

//   @override
//   _QRCreateScreenState createState() => _QRCreateScreenState();
// }

// class _QRCreateScreenState extends State<QRCreateScreen> {
//   final GlobalKey _globalKey = GlobalKey();

//   final ScreenshotController screenshotController = ScreenshotController();
//   String message = 'Scan and shop with ShopEz';

//   shareImage() async {
//     XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//     Share.shareXFiles([image], text: message);
//   }

//   Future<void> _downloadQrCode(BuildContext context) async {
//     // Retrieve the boundary of the QR code widget
//     RenderRepaintBoundary boundary =
//         _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

//     // Capture the image of the QR code
//     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     Uint8List pngBytes = byteData!.buffer.asUint8List();

//     // Save image to device
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = '${directory.path}/qr_code.png';
//     await File(imagePath).writeAsBytes(pngBytes);

//     // Save to gallery
//     final response = await ImageGallerySaver.saveFile(imagePath);
//     print("QR Code saved to gallery: $response");

//     // Show SnackBar
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('QR Code downloaded successfully!'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: const Text(
//             'QR Code',
//             style: TextStyle(
//               fontFamily: 'Regular',
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: GlobalVariables.greenColor,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(
//                 Icons.download,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 _downloadQrCode(context);
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Spacer(),
//             QrShare(
//               name: 'Shivprasad Rahulwad',
//               shopId: GlobalVariables.shopCode,
//               qrData: GlobalVariables.shopCode, // Data for the QR code
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           border:
//                               Border.all(color: GlobalVariables.blueTextColor),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             InkWell(
//                                 onTap: () {
//                                   FlutterClipboard.copy(
//                                       GlobalVariables.shopCode);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Copied successfully!'),
//                                       duration: Duration(seconds: 2),
//                                     ),
//                                   );
//                                 },
//                                 child: const Icon(Icons.copy,
//                                     size: 20,
//                                     color: GlobalVariables.blueTextColor)),
//                             const SizedBox(
//                                 width: 8), // Space between icon and text
//                             const Text(
//                               'Copy Shop ID',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.bold,
//                                 color: GlobalVariables.blueTextColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: GlobalVariables.blueTextColor,
//                             border: Border.all(
//                                 color: GlobalVariables.blueTextColor),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   // Capture the widget as an image
//                                   final image = await screenshotController
//                                       .captureFromWidget(
//                                     QrShare(
//                                       name: 'Shivprasad Rahulwad',
//                                       shopId: GlobalVariables.shopCode,
//                                       qrData: GlobalVariables
//                                           .shopCode, // Data for the QR code
//                                     ),
//                                     pixelRatio: 2,
//                                   );

//                                   // Share the captured image
//                                   await Share.shareXFiles(
//                                       [XFile.fromData(image, mimeType: 'png')]);
//                                 },
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.share,
//                                       size: 20,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                             8), // Space between icon and text
//                                     const Text(
//                                       'Share QR code',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontFamily: 'Regular',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   const Center(
//                     child: Text(
//                       '-- ShopEz --',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'SemiBold',
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
// }




class QRCreateScreen extends StatefulWidget {
  static const String routeName = '/qr-create';

  @override
  _QRCreateScreenState createState() => _QRCreateScreenState();
}

class _QRCreateScreenState extends State<QRCreateScreen> {
  final GlobalKey qrKey = GlobalKey();
  final ScreenshotController screenshotController = ScreenshotController();
  String message = 'Scan and shop with ShopEz';

  shareImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Share.shareXFiles([image], text: message);
  }

  // Future<void> _downloadQrCode(BuildContext context) async {
  //   try {
  //     // First, capture the QR widget using screenshotController
  //     final bytes = await screenshotController.captureFromWidget(
  //       RepaintBoundary(
  //         child: Container(
  //           color: Colors.white,
  //           child: QrShare(
  //             name: 'Shivprasad Rahulwad',
  //             shopId: GlobalVariables.shopCode,
  //             qrData: GlobalVariables.shopCode,
  //           ),
  //         ),
  //       ),
  //       pixelRatio: 3.0,
  //       targetSize: const Size(1080, 1080),
  //     );

  //     // Get the application documents directory
  //     final directory = await getApplicationDocumentsDirectory();
  //     final imagePath = '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
      
  //     // Write the file
  //     final file = File(imagePath);
  //     await file.writeAsBytes(bytes);

  //     // Save to gallery
  //     final result = await ImageGallerySaver.saveFile(imagePath);
      
  //     if (result['isSuccess']) {
  //       CustomSnackBar.show(context, 'QR Code downloaded successfully!');

  //     } else {
  //       throw Exception('Failed to save to gallery');
  //     }
  //   } catch (e) {
  //     CustomSnackBar.show(context, 'Error saving QR Code: ${e.toString()}');
  //   }
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'QR Code',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(
          //       Icons.download,
          //       color: Colors.black,
          //     ),
          //     onPressed: () => _downloadQrCode(context),
          //   ),
          // ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Screenshot(
              controller: screenshotController,
              child: QrShare(
                name: 'Shivprasad Rahulwad',
                shopId: GlobalVariables.shopCode,
                qrData: GlobalVariables.shopCode,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: GlobalVariables.blueTextColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                FlutterClipboard.copy(GlobalVariables.shopCode);
                                CustomSnackBar.show(context, 'Copied successfully!');
                              },
                              child: const Icon(
                                Icons.copy,
                                size: 20,
                                color: GlobalVariables.blueTextColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Copy Shop ID',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.blueTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GlobalVariables.blueTextColor,
                          border: Border.all(color: GlobalVariables.blueTextColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final image = await screenshotController.capture(
                                  pixelRatio: 2.0,
                                );
                                if (image != null) {
                                  await Share.shareXFiles(
                                    [XFile.fromData(image, mimeType: 'image/png')],
                                    text: message,
                                  );
                                }
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Share QR code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      '-- ShopEz --',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SemiBold',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}