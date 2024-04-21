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
        _dateController.text = DateFormat('yyyy-MM-dd').format(task!.date);
        _notesController.text = task!.notes;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(task != null ? 'Edit Task' : 'Add Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date'),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    locale: const Locale('pt', 'BR'),
                  );
                  if (pickedDate != null) {
                    _dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _saveTask(context, taskCubit);
                },
                child: Text(task != null ? 'Save Changes' : 'Add Task'),
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
    final date = DateTime.parse(_dateController.text.trim());

    if (title.isNotEmpty) {
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
          title: const Text('Error'),
          content: const Text('Task title cannot be empty.'),
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
