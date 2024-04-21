import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  const CustomModalActionButton(
      {super.key, required this.onClose, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButton(
          onPressed: onClose,
          color: const Color.fromRGBO(250, 30, 78, 1),
          buttonText: "Fechar",
          textColor: Colors.white,
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: "Salvar",
          color: const Color.fromRGBO(250, 30, 78, 1),
          textColor: Colors.white,
        )
      ],
    );
  }
}
