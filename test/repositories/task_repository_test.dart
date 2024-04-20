// task_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_desafio/models/task.dart';
import 'package:todo_list_desafio/repositories/task_repository.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository taskRepository;

    setUp(() {
      taskRepository = TaskRepository();
    });

    test('saveTasks and loadTasks', () async {
      final tasks = [
        Task(id: '1', title: 'Task 1'),
        Task(id: '2', title: 'Task 2', isCompleted: true),
      ];
      await taskRepository.saveTasks(tasks);
      final loadedTasks = await taskRepository.loadTasks();
      expect(loadedTasks, equals(tasks));
    });
  });
}
