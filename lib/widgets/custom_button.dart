import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color color;
  final Color textColor;
  final Color borderColor;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      required this.color,
      required this.textColor,
      this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      color: color,
      textColor: textColor,
      padding: const EdgeInsets.all(14.0),
      child: Text(buttonText),
    );
  }
}
