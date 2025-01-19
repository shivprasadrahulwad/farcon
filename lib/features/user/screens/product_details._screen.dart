import 'package:flutter/material.dart';
import 'package:farcon/constants/global_variables.dart';
import 'package:farcon/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/products-details';
  final Product product; 
  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int price = widget.product.price; 
    int discountPrice = widget.product.discountPrice ?? 0; 
    double offer = ((price - discountPrice) / (discountPrice != 0 ? discountPrice : 1)) * 100;

    return Scaffold(
      backgroundColor:
          GlobalVariables.backgroundColor, // Background color for the screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image and Gradient Stack
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenWidth, // Image height matches screen width
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient at the bottom of the image
                Positioned(
                  bottom: 0, // Positioned at the bottom of the image
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    height: 40, // Increased height for the gradient effect
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          GlobalVariables.backgroundColor.withOpacity(1),
                          GlobalVariables.backgroundColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.share,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Product Details Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                clipBehavior: Clip.none, // Allows for overflow
                children: [
                  // The main container
                  Container(
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // Background color for product details
                      borderRadius:
                          BorderRadius.circular(15), // Circular corner radius
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                            '${widget.product.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold', // Font family
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '231g',
                            style: TextStyle(
                              fontSize: 16,
                              // fontFamily: 'Regular',

                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '₹${widget.product.discountPrice}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'SemiBold',
                                  color: Colors.black, // Price color
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'MRP ₹${widget.product.price}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration
                                      .lineThrough, // Strike through
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4), // Add padding for the text
                                decoration: BoxDecoration(
                                  color: GlobalVariables
                                      .blueBackground, // Light blue background color
                                  borderRadius: BorderRadius.circular(
                                      5), // Circular radius of 10
                                ),
                                child: Text(
                                  '${offer.toInt()}% OFF',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: GlobalVariables.blueTextColor,
                                    fontFamily: 'SemiBold',
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                         Padding(
                          padding: EdgeInsets.only(left: 5,right: 5),
                           child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to the start
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.only(
                                            right: 2), // Space between containers
                                        decoration: const BoxDecoration(
                                          color: GlobalVariables.blueBackground,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                        child: const Column(
                                          children: [
                                            Icon(Icons.motorcycle,size: 30,color: GlobalVariables.blueTextColor,),
                                            SizedBox(height: 8),
                                            Text(
                                              'Fast',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,fontFamily: 'SemiBold',fontSize: 14,),
                                            ),
                                            SizedBox(height: 2,),
                                            Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Regular',fontSize: 10,),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.only(
                                            left: 2), // Space between containers
                                        decoration: const BoxDecoration(
                                          color: GlobalVariables.blueBackground,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: const Column(
                                          children: [
                                            Icon(Icons.person,size: 30,color: GlobalVariables.blueTextColor,),
                                            SizedBox(height: 8),
                                            Text(
                                              '24/7',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,fontFamily: 'SemiBold',fontSize: 14,),
                                            ),
                                            SizedBox(height: 2,),
                                            Text('Support',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Regular',fontSize: 10,),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                         ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -30,
                    left: -0,
                    child: Container(
                      // width: 100,
                      height: 40,
                      child: CustomPaint(
                        painter: StretchCornerPainter(),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20,right: 20,top: 0,),
                            child: Text(
                              'Rating ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 3, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SemiBold',
                                    color: GlobalVariables.greenColor
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    _isExpanded
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                        color: GlobalVariables.greenColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_isExpanded)
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      '• Made with premium quality ingredients\n'
                                      '• Perfect for gifting\n'
                                      '• Contains assorted chocolates\n'
                                      '• Best before 6 months from manufacturing',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,)
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class StretchCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final radius = 15.0;

    // Create a path for the shape
    final path = Path()
      // Start from after the top-left rounded corner
      ..moveTo(radius, 0)
      // Top edge to before top-right rounded corner
      ..lineTo(size.width - radius, 0)
      // Top-right rounded corner
      ..arcToPoint(
        Offset(size.width, radius),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      // Right edge directly to stretched bottom-right corner
      ..lineTo(size.width + 0, size.height) // This creates the diagonal stretch
      // Bottom edge straight to bottom-left corner (no radius)
      ..lineTo(0, size.height)
      // Left edge to top-left rounded corner
      ..lineTo(0, radius)
      // Top-left rounded corner
      ..arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
