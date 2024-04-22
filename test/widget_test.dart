import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_desafio/cubit/task_cubit.dart';
import 'package:todo_list_desafio/models/task.dart';
import 'package:todo_list_desafio/pages/task_list_page.dart';

class MockTaskCubit extends MockCubit<List<Task>> implements TaskCubit {}

void main() {
  group('TaskListPage', () {
    late MockTaskCubit taskCubit;

    setUp(() {
      taskCubit = MockTaskCubit();
    });

    testWidgets('should show center when task list is empty',
        (WidgetTester tester) async {
      when(() => taskCubit.state).thenReturn([]);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskCubit>.value(
            value: taskCubit,
            child: TaskListPage(),
          ),
        ),
      );

      await tester
          .pumpAndSettle(); // Aguarda o término de todas as operações assíncronas

      expect(find.text('Nenhuma tarefa encontrada'), findsOneWidget);
    });

    testWidgets('should show task list when task list is not empty',
        (WidgetTester tester) async {
      when(() => taskCubit.state).thenReturn([
        Task(
            id: '1',
            title: 'Task 1',
            isCompleted: false,
            date: DateTime.now(),
            notes: ''),
        Task(
            id: '2',
            title: 'Task 2',
            isCompleted: false,
            date: DateTime.now(),
            notes: ''),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskCubit>.value(
            value: taskCubit,
            child: TaskListPage(),
          ),
        ),
      );

      await tester
          .pumpAndSettle(); // Aguarda o término de todas as operações assíncronas

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
