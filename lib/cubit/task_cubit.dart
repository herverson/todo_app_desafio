import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskCubit extends Cubit<List<Task>> {
  TaskCubit() : super([]);

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> tasksData = json.decode(tasksJson);
      final List<Task> tasks =
          tasksData.map((data) => Task.fromJson(data)).toList();
      emit(tasks);
    }
  }

  Future<void> addTask(Task task) async {
    final List<Task> newState = List.from(state)..add(task);
    emit(newState);
    await _saveTasksLocally(newState);
  }

  Future<void> updateTask(Task updatedTask) async {
    final List<Task> newState = List.from(state);
    final int index = newState.indexWhere((task) => task.id == updatedTask.id);
    if (index >= 0) {
      newState[index] = updatedTask;
      emit(newState);
      await _saveTasksLocally(newState);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final List<Task> newState = List.from(state);
    newState.removeWhere((task) => task.id == taskId);
    emit(newState);
    await _saveTasksLocally(newState);
  }

  Future<void> _saveTasksLocally(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }
}
