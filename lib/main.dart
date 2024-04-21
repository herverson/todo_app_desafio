import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'cubit/task_cubit.dart';
import 'pages/task_list_page.dart';
import 'services/task_service.dart';

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
        primarySwatch: Colors.red,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskCubit>(
            create: (context) => TaskCubit(TaskService()),
          ),
        ],
        child: const TaskListPage(),
      ),
    );
  }
}
