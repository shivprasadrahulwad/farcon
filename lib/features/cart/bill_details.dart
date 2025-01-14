import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/features/cart/cart_subtotal.dart';
import 'package:shopez/models/charges.dart';
import 'package:shopez/providers/shop_details_provider.dart';
import 'package:shopez/widgets/sine_wave.dart';

class BillDetails extends StatefulWidget {
  final String selectedScheduleValue;
  const BillDetails({super.key, required this.selectedScheduleValue});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {

  bool shouldHideDeliveryCharges(Charges charges) {
  final now = DateTime.now();
  final startDate = charges.startDate;
  final endDate = charges.endDate;
  final startTime = charges.startTime;
  final endTime = charges.endTime;

  // Check if start and end date are not null and if 'now' is within the range
  if (startDate != null && endDate != null) {
    if (now.isBefore(startDate) || now.isAfter(endDate)) {
      return true; // Outside the date range
    }
  }

  // If the start and end time are not null, check if 'now' is within the time range
  if (startTime != null && endTime != null) {
    final nowTimeInMinutes = now.hour * 60 + now.minute;
    final startTimeInMinutes = Charges.timeOfDayToMinutes(startTime);
    final endTimeInMinutes = Charges.timeOfDayToMinutes(endTime);

    if (nowTimeInMinutes < startTimeInMinutes || nowTimeInMinutes > endTimeInMinutes) {
      return true; // Outside the time range
    }
  }

  return false; // Within date and time range
}

  @override
  Widget build(BuildContext context) {
    // Use Consumer for more granular rebuilds
    return Consumer<ShopDetailsProvider>(
      builder: (context, shopProvider, child) {
        final shopDetails = shopProvider.shopDetails;

        // If shop details aren't available yet, show loading or placeholder
        if (shopDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Bill details",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SemiBold',
                            color: GlobalVariables.faintBlackColor),
                      ),
                    ],
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Divider()),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_note_sharp,
                        color: GlobalVariables.faintBlackColor,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Items total",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                            color: GlobalVariables.faintBlackColor),
                      ),
                      Spacer(),
                      CartSubtotal(),
                    ],
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        color: GlobalVariables.faintBlackColor,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Handling Charge",
                        style: TextStyle(
                            color: GlobalVariables.faintBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular'),
                      ),
                      Spacer(),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '₹10  ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.greyTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              '  FREE',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.blueTextColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.motorcycle,
                        color: GlobalVariables.faintBlackColor,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Delivery Charge",
                        style: TextStyle(
                            fontSize: 14,
                            color: GlobalVariables.faintBlackColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular'),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          if (shouldHideDeliveryCharges(shopDetails.charges!)) 
                          Text(
                            '₹${shopDetails.charges?.isDeliveryChargesEnabled == true ? shopDetails.charges?.deliveryCharges?.toInt() ?? 0 : 0}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          if (!shouldHideDeliveryCharges(shopDetails.charges!)) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                '₹${shopDetails.charges?.isDeliveryChargesEnabled == true ? shopDetails.charges?.deliveryCharges?.toInt() ?? 0 : 0}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.greyTextColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                '  FREE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    ],
                  ),
                ),
                if (widget.selectedScheduleValue.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: GlobalVariables.faintBlackColor,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Tip for your delivery partner",
                          style: TextStyle(
                              fontSize: 14,
                              color: GlobalVariables.faintBlackColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular'),
                        ),
                        const Spacer(),
                        Text(
                          "+ ${widget.selectedScheduleValue}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.selectedScheduleValue.isNotEmpty)
                  const SizedBox(height: 10),
                if (GlobalVariables.appliedCouponOffer != null)
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: GlobalVariables.faintBlackColor,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Coupon Discount",
                          style: TextStyle(
                              fontSize: 14,
                              color: GlobalVariables.faintBlackColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular'),
                        ),
                        Spacer(),
                        CouponDiscount()
                      ],
                    ),
                  ),
                const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Divider()),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Grand total",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular'),
                      ),
                      const Spacer(),
                      CartTotal(tip: widget.selectedScheduleValue),
                    ],
                  ),
                ),
                if (shopDetails.delPrice != null)
                  Stack(
                    children: [
                      ClipPath(
                        clipper: SineWaveClipper(
                          amplitude: 3,
                          frequency: 15,
                        ),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(),
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: const BoxDecoration(
                                color: GlobalVariables.savingColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your total savings",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: GlobalVariables.blueTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                if (shopDetails.delPrice == 0)
                                  Text(
                                    "Includes ${shopDetails.charges?.isDeliveryChargesEnabled == true ? shopDetails.charges?.deliveryCharges?.toInt() ?? 0 : 0} savings through free delivery",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            GlobalVariables.lightBlueTextColor),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            const CartTotalSaving(),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
