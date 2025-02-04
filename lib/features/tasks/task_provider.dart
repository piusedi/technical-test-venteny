import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'domain/entities/task.dart';

class TaskProvider extends ChangeNotifier {
	late Box<Task> _taskBox;
	bool _isInitialized = false;

	List<Task> get tasks => _isInitialized ? _taskBox.values.toList() : [];

	Future<void> initTasks() async {
		_taskBox = await Hive.openBox<Task>('tasks');
		_isInitialized = true;
		notifyListeners();
	}

	void addTask(Task task) async {
		await _taskBox.put(task.id, task);
		notifyListeners();
	}

	void updateTask(Task task) {
		final index = tasks.indexWhere((t) => t.id == task.id);
		if (index != -1) {
		tasks[index] = task;
		notifyListeners();
		}
	}

	void deleteTask(Task task) async {
		await _taskBox.delete(task.id);
		notifyListeners();
	}
}
