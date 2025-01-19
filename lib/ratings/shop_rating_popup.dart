import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:farcon/features/user/services/home_services.dart';

// class RatingPopup extends StatefulWidget {
//   final Function(double, String) onSubmit;
  
//   const RatingPopup({
//     Key? key,
//     required this.onSubmit,
//   }) : super(key: key);

//   @override
//   _RatingPopupState createState() => _RatingPopupState();
// }

// class _RatingPopupState extends State<RatingPopup> {
//   double _rating = 0;
//   final TextEditingController _feedbackController = TextEditingController();
  
//   @override
//   void dispose() {
//     _feedbackController.dispose();
//     super.dispose();
//   }

//   String _getFeedbackHint() {
//     if (_rating <= 2) {
//       return "We're sorry to hear that. Please let us know what went wrong...";
//     } else if (_rating <= 3) {
//       return "Thanks for your rating. How can we improve?";
//     }
//     return "We're glad you enjoyed your experience! Tell us more...";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Rate Your Shopping Experience',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             RatingBar.builder(
//               initialRating: _rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 40,
//               unratedColor: Colors.grey[300],
//               itemPadding: const EdgeInsets.symmetric(horizontal: 4),
//               itemBuilder: (context, _) => const Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             if (_rating > 0)
//               Text(
//                 _rating == 5
//                     ? 'Excellent!'
//                     : _rating >= 4
//                         ? 'Very Good!'
//                         : _rating >= 3
//                             ? 'Good'
//                             : _rating >= 2
//                                 ? 'Fair'
//                                 : 'Poor',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _feedbackController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: _getFeedbackHint(),
//                 hintStyle: TextStyle(color: Colors.grey[400]),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.blue),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[50],
//                 contentPadding: const EdgeInsets.all(16),
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_rating > 0) {
//                     widget.onSubmit(_rating, _feedbackController.text);
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.blue,
//                   onPrimary: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 2,
//                 ),
//                 child: const Text(
//                   'Submit Feedback',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Usage Example:
// void showRatingDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return RatingPopup(
//         onSubmit: (rating, feedback) {
//           // Handle the rating and feedback submission
//           print('Rating: $rating');
//           print('Feedback: $feedback');
//         },
//       );
//     },
//   );
// }


class RatingPopup extends StatefulWidget {
  final String shopCode;  // Added shopCode parameter
  final Function(double, String) onSubmit;
  
  const RatingPopup({
    Key? key,
    required this.shopCode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RatingPopupState createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final HomeServices _homeServices = HomeServices();
  
  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String _getFeedbackHint() {
    if (_rating <= 2) {
      return "We're sorry to hear that. Please let us know what went wrong...";
    } else if (_rating <= 3) {
      return "Thanks for your rating. How can we improve?";
    }
    return "We're glad you enjoyed your experience! Tell us more...";
  }

  void _handleSubmit() async {
    if (_rating > 0) {
      _homeServices.rateShop(
        context: context,
        shopCode: widget.shopCode,
        rating: _rating,
      );
      
      widget.onSubmit(_rating, _feedbackController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the build method remains the same as your original code
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rate Your Shopping Experience',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              unratedColor: Colors.grey[300],
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_rating > 0)
              Text(
                _rating == 5
                    ? 'Excellent!'
                    : _rating >= 4
                        ? 'Very Good!'
                        : _rating >= 3
                            ? 'Good'
                            : _rating >= 2
                                ? 'Fair'
                                : 'Poor',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _getFeedbackHint(),
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage Example:
void showRatingDialog(BuildContext context, String shopCode) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return RatingPopup(
        shopCode: shopCode,
        onSubmit: (rating, feedback) {
          print('Rating: $rating');
          print('Feedback: $feedback');
        },
      );
    },
  );
}