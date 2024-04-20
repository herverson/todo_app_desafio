import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_desafio/pages/task_page.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: BlocBuilder<TaskCubit, List<Task>>(
        builder: (context, tasks) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    final updatedTask = task.copyWith(isCompleted: value);
                    BlocProvider.of<TaskCubit>(context).updateTask(updatedTask);
                  },
                ),
                onTap: () {
                  final taskCubit = BlocProvider.of<TaskCubit>(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(
                        taskCubit: taskCubit,
                        task: task,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  BlocProvider.of<TaskCubit>(context).deleteTask(task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final taskCubit = BlocProvider.of<TaskCubit>(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(taskCubit: taskCubit),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
