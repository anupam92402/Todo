import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task.dart';

class TaskData {
  static const _tasksKey = 'tasks';

  static Future<Map<String, List<Task>>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getString(_tasksKey);
    if (dataJson == null) {
      return {};
    }

    final Map<String, dynamic> jsonData = jsonDecode(dataJson);

    final Map<String, List<Task>> map = {};
    jsonData.forEach((key, value) {
      final List<Task> list = (value as List<dynamic>)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();
      map[key] = list;
    });

    return map;
  }

  static Future<List<Task>> getTasksByDate({required String date}) async {
    Map<String, List<Task>> map = await getTasks();
    final List<Task> list = map[date] ?? [];
    return list;
  }

  static Future<void> saveTasks({required String date, required List<Task> taskList}) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, List<Task>> map = await getTasks();

    map[date] = taskList;

    Map<String, dynamic> jsonData = {};
    map.forEach((key, value) {
      jsonData[key] = value.map((task) => task.toJson()).toList();
    });

    await prefs.setString(_tasksKey, jsonEncode(jsonData));
  }
}