import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_desafio/pages/task_page.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_modal_action.dart';

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
          final cubit = BlocProvider.of<TaskCubit>(context);
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text("Deletar tarefa",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(task.title),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  CustomModalActionButton(
                                    onClose: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    onSave: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    titleOp1: 'Sair',
                                    titleOp2: 'Deletar',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    BlocProvider.of<TaskCubit>(context).deleteTask(task.id);
                  }
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: task.isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
                          : null,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(
                            taskCubit: cubit,
                            task: task,
                          ),
                        ),
                      );
                    },
                    leading: IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: const Color.fromRGBO(250, 30, 78, 1),
                      ),
                      iconSize: 32,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      task.isCompleted
                                          ? "Desmarcar tarefa"
                                          : "Marcar tarefa como concluída",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Text(task.title),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    CustomButton(
                                      buttonText: task.isCompleted
                                          ? "Desmarcar"
                                          : "Marcar como concluída",
                                      onPressed: () {
                                        final updatedTask = task.copyWith(
                                            isCompleted: !task.isCompleted);
                                        cubit.updateTask(updatedTask);
                                        Navigator.of(context).pop();
                                      },
                                      color:
                                          const Color.fromRGBO(250, 30, 78, 1),
                                      textColor: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
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
