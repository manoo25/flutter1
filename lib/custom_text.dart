import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: 16,
      ),
    );
  }
}