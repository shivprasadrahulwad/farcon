import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shopez/constants/global_variables.dart';

class TippingWidget extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const TippingWidget({Key? key, required this.schedule}) : super(key: key);

  @override
  _TippingWidgetState createState() => _TippingWidgetState();
}

class _TippingWidgetState extends State<TippingWidget> {
  int _selectedScheduleIndex = 0;
  String _selectedScheduleValue = '';

  @override
  void initState() {
    super.initState();
    _selectedScheduleValue = widget.schedule['tips'][0];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tip your delivery partner",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SemiBold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' $_selectedScheduleValue',
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 270),
              child: const Text(
                "Your kindness means a lot! 100% of your tip will go directly to your delivery partner.",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: GlobalVariables.greyTextColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (widget.schedule['tips'] as List).length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedScheduleIndex = index;
                        _selectedScheduleValue = (widget.schedule['tips'] as List)[index];
                      });
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: _selectedScheduleIndex == index
                            ? const Color.fromARGB(255, 207, 249, 215)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedScheduleIndex == index
                              ? GlobalVariables.greenColor
                              : Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${(widget.schedule['emoji'] as List)[index]} ${(widget.schedule['tips'] as List)[index]}',
                            style: TextStyle(
                              color: _selectedScheduleIndex == index
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}