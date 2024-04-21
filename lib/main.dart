import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'cubit/task_cubit.dart';
import 'pages/task_list_page.dart';
import 'services/task_service.dart';

void main() {
  initializeDateFormatting().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      title: 'Todo List Desafio',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(250, 30, 78, 1),
        ),
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
