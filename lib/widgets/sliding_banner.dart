import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/models/offerDes.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class SlidingBannerWidget extends StatefulWidget {
  const SlidingBannerWidget({Key? key}) : super(key: key);

  @override
  State<SlidingBannerWidget> createState() => _SlidingBannerWidgetState();
}

class _SlidingBannerWidgetState extends State<SlidingBannerWidget> {
  final PageController _controller = PageController();
  bool _isFloatingContainerOpen = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopDetailsProvider>(
      builder: (context, shopProvider, child) {
        final offerDes = shopProvider.shopDetails?.offerDes;

        if (offerDes == null || offerDes['descriptions'] == null) {
          return const SizedBox.shrink(); // Don't show banner if no offers
        }

        final descriptions = (offerDes['descriptions'] as List)
            .map((map) => OfferDes.fromMap(map as Map<String, dynamic>))
            .toList();

        if (descriptions.isEmpty) {
          return const SizedBox.shrink(); // Don't show banner if no offers
        }

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isFloatingContainerOpen = false;
              });
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: GlobalVariables.blueBackground,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: descriptions
                            .map((offer) => _buildBannerItem(
                                  icon: offer.icon,
                                  title: offer.title,
                                  subtitle: offer.description,
                                ))
                            .toList(),
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: GlobalVariables.blueBackground,
                      ),
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: descriptions.length,
                          effect: const ExpandingDotsEffect(
                            expansionFactor: 6,
                            dotHeight: 5,
                            dotWidth: 5,
                            activeDotColor: GlobalVariables.blueTextColor,
                            dotColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannerItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 63,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: GlobalVariables.blueBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      // Safely parse the icon string to IconData
                      _parseIcon(icon),
                      color: GlobalVariables.blueTextColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: GlobalVariables.blueTextColor,
                      fontFamily: 'Regular',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final Map<String, IconData> _iconMap = {
    'Icons.motorcycle': Icons.motorcycle,
    'Icons.home': Icons.home,
    'Icons.shopping_cart': Icons.shopping_cart,
    'Icons.local_offer': Icons.local_offer,
    'Icons.star': Icons.star,
  };

  IconData _parseIcon(String icon) {
    return _iconMap[icon] ?? Icons.error;
  }
}
