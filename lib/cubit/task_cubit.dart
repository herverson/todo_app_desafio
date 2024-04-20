import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskCubit extends Cubit<List<Task>> {
  final TaskRepository _taskRepository;

  TaskCubit(this._taskRepository) : super([]);

  void loadTasks() async {
    final tasks = await _taskRepository.loadTasks();
    emit(tasks);
  }

  void addTask(Task task) async {
    final List<Task> newState = List.from(state)..add(task);
    emit(newState);
    await _taskRepository.saveTasks(newState);
  }

  void updateTask(Task updatedTask) async {
    final List<Task> newState = List.from(state);
    final int index = newState.indexWhere((task) => task.id == updatedTask.id);
    if (index >= 0) {
      newState[index] = updatedTask;
      emit(newState);
      await _taskRepository.saveTasks(newState);
    }
  }

  void deleteTask(String taskId) async {
    final List<Task> newState = List.from(state);
    newState.removeWhere((task) => task.id == taskId);
    emit(newState);
    await _taskRepository.saveTasks(newState);
  }
}
