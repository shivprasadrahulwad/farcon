import 'package:flutter/material.dart';
import 'package:farcon/constants/global_variables.dart';

class NotePopup extends StatefulWidget {
  NotePopup({super.key});

  @override
  State<NotePopup> createState() => _NotePopupState();
}

class _NotePopupState extends State<NotePopup> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/mark.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add Note for Shopkeeper',
                style: TextStyle(
                    fontFamily: 'SemiBold',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: ' Enter your note here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: GlobalVariables.greenColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 194, 194, 194),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 90, 228, 44),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.done,
                            size: 10,
                            color: Colors.white,
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Shopkeeper will provided you',
                    style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 90, 228, 44),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.done,
                            size: 10,
                            color: Colors.white,
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Unique identity of shop',
                    style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Added text display',
                style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(color: Colors.grey),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // AddressBottomSheet(context);
                  },
                  child: const Text('ADD',
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GlobalVariables.greenColor))),
            ],
          ),
        ),
      ),
    );
  }
}
