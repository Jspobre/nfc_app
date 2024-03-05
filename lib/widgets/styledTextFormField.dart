import 'package:flutter/material.dart';

class StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  const StyledTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w400),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff16A637), // You can set the color of the border
          ),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // You can set the color of the border
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: "Roboto", fontWeight: FontWeight.w300, fontSize: 15),
        contentPadding: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
      ),
    );
  }
}
