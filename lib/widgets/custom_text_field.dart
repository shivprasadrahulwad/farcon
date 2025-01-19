import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final double? width;
  final double? height;
  final IconData? prefixIcon;
  final TextEditingController? controller; 
  final TextInputType? keyboardType; 

  const CustomTextFields({
    Key? key,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.width,
    this.height,
    this.prefixIcon,
    this.controller, 
    this.keyboardType, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? (maxLines > 1 ? null : 50),
      child: TextFormField(
        controller: controller, // Add this line to use the controller
        keyboardType: keyboardType, // Use the keyboardType parameter here
        decoration: InputDecoration(
          hintText: hintText,
          alignLabelWithHint: maxLines > 1,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Icon(prefixIcon, color: Colors.grey),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}



class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isRequired;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (isFocused) {
        setState(() {
          _isFocused = isFocused;
        });
      },
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: widget.onSubmitted,
        validator: (value) {
          if (widget.isRequired && (value == null || value.trim().isEmpty)) {
            return 'This field is required';
          }
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: _isFocused || _hasText ? '' : widget.hintText,
          labelText: _isFocused || _hasText ? widget.hintText : null,
          labelStyle: TextStyle(
            color: _isFocused ? Colors.black : Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          suffixIcon: _hasText
              ? Container(
                  margin: const EdgeInsets.all(15),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _hasText = false;
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 12,
                    ),
                  ),
                )
              : widget.isRequired
                  ? const Text(
                      ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  : null,
        ),
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}