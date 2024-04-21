import 'package:flutter/material.dart';

import '../models/task.dart';
import 'custom_modal_action.dart';

class ModalDeleteTask extends StatelessWidget {
  const ModalDeleteTask({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Deletar tarefa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Text(task.title),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              CustomModalActionButton(
                onClose: () {
                  Navigator.of(context).pop(false);
                },
                onSave: () {
                  Navigator.of(context).pop(true);
                },
                titleOp1: 'Cancelar',
                titleOp2: 'Deletar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
