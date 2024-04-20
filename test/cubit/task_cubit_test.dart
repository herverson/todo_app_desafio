import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_desafio/cubit/task_cubit.dart';
import 'package:todo_list_desafio/models/task.dart';

void main() {
  group('TaskCubit', () {
    late TaskCubit taskCubit;

    setUp(() {
      taskCubit = TaskCubit();
    });

    tearDown(() {
      taskCubit.close();
    });

    test('initial state is empty', () {
      expect(taskCubit.state, isEmpty);
    });

    test('addTask adds task', () {
      final task = Task(id: '1', title: 'Test Task');
      taskCubit.addTask(task);
      expect(taskCubit.state, contains(task));
    });

    test('updateTask updates task', () {
      final task = Task(id: '1', title: 'Test Task');
      taskCubit.addTask(task);
      final updatedTask =
          Task(id: '1', title: 'Updated Task', isCompleted: true);
      taskCubit.updateTask(updatedTask);
      expect(taskCubit.state, contains(updatedTask));
    });

    test('deleteTask removes task', () {
      final task = Task(id: '1', title: 'Test Task');
      taskCubit.addTask(task);
      taskCubit.deleteTask(task.id);
      expect(taskCubit.state, isNot(contains(task)));
    });
  });
}
