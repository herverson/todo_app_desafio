import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';

class TaskPage extends StatelessWidget {
  final Task? task;
  final TaskCubit taskCubit;

  TaskPage({Key? key, required this.taskCubit, this.task}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      String formattedDate =
          task?.date != null ? _dateFormat.format(task!.date) : '';

      if (task != null) {
        _titleController.text = task!.title;
        _dateController.text = formattedDate;
        _notesController.text = task!.notes;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(task != null ? 'Editar Tarefa' : 'Adicionar Tarefa'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                    labelText: 'Data', prefixIcon: Icon(Icons.calendar_today)),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _dateController.text = _dateFormat.format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 16.0),
              const Expanded(
                child: SizedBox(),
              ),
              MaterialButton(
                onPressed: () {
                  _saveTask(context, taskCubit);
                },
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12)),
                color: const Color.fromRGBO(250, 30, 78, 1),
                textColor: Colors.white,
                padding: const EdgeInsets.all(14.0),
                child: Text(
                    task != null ? 'Salvar Alterações' : 'Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _saveTask(BuildContext context, TaskCubit taskCubit) {
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();

    DateTime? date;
    try {
      date = _dateFormat.parse(_dateController.text.trim());
    } catch (e) {
      print('Erro ao formatar a data: $e');
    }

    if (title.isNotEmpty && date != null) {
      final taskToUpdate = task?.copyWith(
        title: title,
        date: date,
        notes: notes,
        isCompleted: task!.isCompleted,
      );
      if (task != null) {
        taskCubit.updateTask(taskToUpdate!);
      } else {
        taskCubit.addTask(Task(
          id: DateTime.now().toString(),
          title: title,
          date: date,
          notes: notes,
        ));
      }
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Título não pode ser vazio.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
