import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_desafio/pages/task_page.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';
import '../widgets/custom_button.dart';

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
              return task.isCompleted
                  ? _taskComplete(task, BlocProvider.of<TaskCubit>(context))
                  : _taskUncomplete(task, BlocProvider.of<TaskCubit>(context));
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

  Widget _taskUncomplete(Task data, TaskCubit cubit) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskPage(
              taskCubit: cubit,
              task: data,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text("Deletar tarefa",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(data.title),
                        const SizedBox(
                          height: 24,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          buttonText: "Deletar",
                          onPressed: () {
                            cubit.deleteTask(data.id);
                            Navigator.of(context).pop();
                          },
                          color: const Color.fromRGBO(250, 30, 78, 1),
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Row(
        children: <Widget>[
          IconButton(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            iconSize: 20.0,
            icon: const Icon(Icons.radio_button_unchecked),
            color: const Color.fromRGBO(250, 30, 78, 1),
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Confirmar tarefa",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(data.title),
                            const SizedBox(
                              height: 24,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomButton(
                              buttonText: "Completa",
                              onPressed: () {
                                final updatedTask =
                                    data.copyWith(isCompleted: true);
                                cubit.updateTask(updatedTask);
                                Navigator.of(context).pop();
                              },
                              color: const Color.fromRGBO(250, 30, 78, 1),
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Text(
            data.title,
            style: const TextStyle(fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget _taskComplete(Task data, TaskCubit cubit) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskPage(
              taskCubit: cubit,
              task: data,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text("Deletar tarefa",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(data.title),
                        const SizedBox(
                          height: 24,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          buttonText: "Deletar",
                          onPressed: () {
                            cubit.deleteTask(data.id);
                            Navigator.of(context).pop();
                          },
                          color: const Color.fromRGBO(250, 30, 78, 1),
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Row(
        children: <Widget>[
          IconButton(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            icon: const Icon(Icons.check_box),
            color: const Color.fromRGBO(250, 30, 78, 1),
            iconSize: 20,
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Desmarcar tarefa",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(data.title),
                            const SizedBox(
                              height: 24,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomButton(
                              buttonText: "Desmarcar",
                              onPressed: () {
                                final updatedTask =
                                    data.copyWith(isCompleted: false);
                                cubit.updateTask(updatedTask);
                                Navigator.of(context).pop();
                              },
                              color: const Color.fromRGBO(250, 30, 78, 1),
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Text(
            data.title,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 20.0,
            ),
          )
        ],
      ),
    );
  }
}
