import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;
  final String titleOp1;
  final String titleOp2;

  const CustomModalActionButton(
      {super.key,
      required this.onClose,
      required this.onSave,
      required this.titleOp1,
      required this.titleOp2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CustomButton(
          onPressed: onClose,
          color: Colors.white,
          buttonText: titleOp1,
          textColor: Colors.black,
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: titleOp2,
          color: const Color.fromRGBO(250, 30, 78, 1),
          textColor: Colors.white,
        )
      ],
    );
  }
}
