import 'package:flutter/material.dart';
import 'package:farcon/constants/global_variables.dart';

class DeliveryInstructions extends StatefulWidget {
  const DeliveryInstructions({Key? key}) : super(key: key);

  @override
  _DeliveryInstructionsState createState() => _DeliveryInstructionsState();
}

class _DeliveryInstructionsState extends State<DeliveryInstructions> {
  bool isMarked1 = false;
  bool isMarked2 = false;
  bool isMarked3 = false;
  bool isMarked4 = false;
  bool isMarked5 = false;
  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;

  Widget _buildInstructionItem({
    required IconData icon,
    required String text,
    required bool isMarked,
    required bool? isChecked,
    required Function(bool?) onChanged,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMarked
            ? const Color.fromARGB(255, 215, 247, 216)
            : (isChecked! ? const Color.fromARGB(255, 211, 240, 212) : Colors.white),
        border: Border.all(
          color: GlobalVariables.greyBackgroundCOlor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  onChanged(!isMarked);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: Theme(
                      data: ThemeData(
                        checkboxTheme: CheckboxThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: isChecked,
                          activeColor: Colors.green,
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery instructions",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'SemiBold',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  _buildInstructionItem(
                    icon: Icons.door_back_door_outlined,
                    text: 'Leave at door',
                    isMarked: isMarked1,
                    isChecked: isChecked1,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked1 = newBool;
                        isMarked1 = newBool!;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildInstructionItem(
                    icon: Icons.call,
                    text: 'Avoid calling',
                    isMarked: isMarked2,
                    isChecked: isChecked2,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked2 = newBool;
                        isMarked2 = newBool!;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildInstructionItem(
                    icon: Icons.doorbell_outlined,
                    text: 'Don\'t ring the bell',
                    isMarked: isMarked3,
                    isChecked: isChecked3,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked3 = newBool;
                        isMarked3 = newBool!;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildInstructionItem(
                    icon: Icons.man,
                    text: 'Leave at guard',
                    isMarked: isMarked4,
                    isChecked: isChecked4,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked4 = newBool;
                        isMarked4 = newBool!;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildInstructionItem(
                    icon: Icons.pets,
                    text: 'Pet at home',
                    isMarked: isMarked5,
                    isChecked: isChecked5,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked5 = newBool;
                        isMarked5 = newBool!;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}