import 'dart:developer';

import 'package:flutter/material.dart';
import '../data/task.dart';
import '../util/task_data.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasksList = [];
  String? taskDate = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadTasks(String? date) async {
    final loadedTasks = await TaskData.getTasksByDate(date: date ?? '');
    setState(() {
      tasksList = loadedTasks;
    });
  }

  Future<void> _addTask(Task newTask, String date) async {
    setState(() {
      tasksList.add(newTask);
    });
    await TaskData.saveTasks(date: date, taskList: tasksList);
  }

  Future<void> _toggleTaskCompletion(int index, String date) async {
    setState(() {
      tasksList[index].isCompleted = !tasksList[index].isCompleted;
    });
    await TaskData.saveTasks(date: date, taskList: tasksList);
  }

  Future<void> _deleteTask(int index, String date) async {
    bool shouldDelete = false;
    shouldDelete = await _showDeleteConfirmationDialog();
    if (shouldDelete) {
      setState(() {
        tasksList.removeAt(index);
      });
      await TaskData.saveTasks(date: date, taskList: tasksList);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Don't delete
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTask(int index, String date) async {
    final editedTask = await Navigator.pushNamed(
      context,
      '/add',
      arguments: tasksList[index].title,
    );
    if (editedTask != null) {
      setState(() {
        tasksList[index].title = editedTask as String;
      });
      await TaskData.saveTasks(date: date, taskList: tasksList);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskDate = ModalRoute.of(context)?.settings.arguments as String?;
    log('$taskDate');
    _loadTasks(taskDate);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_outlined),
                      ),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    '${tasksList.length} Tasks',
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    taskDate ?? '',
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: tasksList.length,
                      itemBuilder: (context, index) {
                        final task = tasksList[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            setState(() {
                              _deleteTask(index, taskDate ?? '');
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                _toggleTaskCompletion(index, taskDate ?? '');
                              },
                              child: task.isCompleted
                                  ? const Icon(Icons.check_box)
                                  : const Icon(Icons.check_box_outline_blank),
                            ),
                            title: GestureDetector(
                              onTap: () => _editTask(index, taskDate ?? ''),
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Floating Action Button
            Positioned(
              bottom: 16, // Adjust the position as needed
              right: 16, // Adjust the position as needed
              child: FloatingActionButton(
                onPressed: () async {
                  // Implement your FAB action here
                  final newTaskTitle = await Navigator.pushNamed(
                    context,
                    '/add',
                    arguments: '',
                  );
                  if (newTaskTitle != null) {
                    final newTask = Task(
                        title: newTaskTitle as String,
                        isCompleted: false,
                        date: taskDate ?? '');
                    _addTask(newTask, taskDate ?? '');
                  }
                },
                shape: const CircleBorder(),
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.add,
                  color: Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}