import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task.dart';

class TaskData {
  static const _tasksKey = 'tasks';

  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey);
    if (tasksJson == null) {
      return [];
    }
    return tasksJson
        .map((taskJson) =>
            Task.fromJson(Map<String, dynamic>.from(json.decode(taskJson))))
        .toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, taskJsonList);
  }
}