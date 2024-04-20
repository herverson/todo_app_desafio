// task_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskService implements TaskRepository {
  static const _key = 'tasks';

  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_key);
    if (tasksJson != null) {
      final List<dynamic> tasksData = json.decode(tasksJson);
      final List<Task> tasks =
          tasksData.map((data) => Task.fromJson(data)).toList();
      return tasks;
    }
    return [];
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_key, tasksJson);
  }
}
