import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_desafio/pages/task_list_page.dart';
import 'cubit/task_cubit.dart';
import 'services/task_service.dart'; // Importe a implementação concreta do TaskRepository

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Desafio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskCubit>(
            create: (context) => TaskCubit(
                TaskService()), // Certifique-se de passar uma instância válida de TaskRepository
          ),
        ],
        child: const TaskListPage(),
      ),
    );
  }
}
