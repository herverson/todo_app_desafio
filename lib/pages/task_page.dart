import 'package:flutter/material.dart';
import '../cubit/task_cubit.dart';
import '../models/task.dart';

class TaskPage extends StatelessWidget {
  final Task? task;
  final TaskCubit taskCubit;

  TaskPage({Key? key, required this.taskCubit, this.task}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      _titleController.text = task!.title;
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
            Row(
              children: [
                const Text('Completed?'),
                const SizedBox(width: 8.0),
                Checkbox(
                  value: task != null ? task!.isCompleted : false,
                  onChanged: (value) {
                    // Implementar a lógica de marcação da tarefa como concluída ou não
                  },
                ),
              ],
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
  }

  void _saveTask(BuildContext context, TaskCubit taskCubit) {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final taskToUpdate =
          task?.copyWith(title: title, isCompleted: task!.isCompleted);
      if (task != null) {
        taskCubit.updateTask(taskToUpdate!);
      } else {
        taskCubit.addTask(Task(id: DateTime.now().toString(), title: title));
      }
      Navigator.of(context).pop();
    } else {
      // Exibir um alerta ou mensagem de erro ao usuário informando que o título da tarefa é obrigatório
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
