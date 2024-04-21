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
  late TextEditingController _searchController;
  late TaskCubit _taskCubit;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _taskCubit = BlocProvider.of<TaskCubit>(context);
    _taskCubit.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar tarefas...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _taskCubit.updateSearchTerm(value);
          },
        ),
      ),
      body: BlocBuilder<TaskCubit, List<Task>>(
        builder: (context, tasks) {
          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.all(6),
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
                                  titleOp1: 'Sair',
                                  titleOp2: 'Deletar',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _taskCubit.deleteTask(task.id);
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
                            taskCubit: _taskCubit,
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
                                  BorderRadius.all(Radius.circular(12)),
                            ),
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
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(task.title),
                                    const SizedBox(height: 24),
                                    const SizedBox(height: 24),
                                    CustomButton(
                                      buttonText: task.isCompleted
                                          ? "Desmarcar"
                                          : "Marcar como concluída",
                                      onPressed: () {
                                        final updatedTask = task.copyWith(
                                          isCompleted: !task.isCompleted,
                                        );
                                        _taskCubit.updateTask(updatedTask);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(taskCubit: _taskCubit),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
