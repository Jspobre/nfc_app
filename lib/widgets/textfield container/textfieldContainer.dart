import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final String label;
  final Widget inputWidget;
  String? example;
  TextFieldContainer(
      {super.key,
      required this.label,
      required this.inputWidget,
      this.example});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "Roboto", fontSize: 16),
          ),
          example != null ? Text("Ex. $example") : const SizedBox(),
          inputWidget,
        ],
      ),
    );
  }
}
