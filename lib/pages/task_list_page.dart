import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list_desafio/pages/task_page.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_delete_task.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Filtrar Tarefas'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Todas'),
                          onTap: () {
                            _taskCubit.applyFilter(TaskFilter.all);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Completadas'),
                          onTap: () {
                            _taskCubit.applyFilter(TaskFilter.completed);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Não Completadas'),
                          onTap: () {
                            _taskCubit.applyFilter(TaskFilter.incomplete);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, List<Task>>(
        builder: (context, tasks) {
          return tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Lottie
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            "assets/1.json",
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),
                      FadeInUp(
                        from: 30,
                        child: const Text("Todas as tarefas concluídas"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
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
                            return ModalDeleteTask(task: task);
                          },
                        );
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          _taskCubit.deleteTask(task.id);
                        }
                      },
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
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
                                                  final updatedTask =
                                                      task.copyWith(
                                                    isCompleted:
                                                        !task.isCompleted,
                                                  );
                                                  _taskCubit
                                                      .updateTask(updatedTask);
                                                  Navigator.of(context).pop();
                                                },
                                                color: const Color.fromRGBO(
                                                    250, 30, 78, 1),
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                DateFormat('EEE, dd/MM/yyyy', 'pt_BR')
                                    .format(task.date),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Color.fromRGBO(250, 30, 78, 1),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
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
