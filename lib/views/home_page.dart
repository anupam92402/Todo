import 'package:flutter/material.dart';
import '../data/task.dart';
import '../util/task_data.dart';
import 'add_task.dart';
import 'edit_task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await TaskData.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<void> _addTask(Task newTask) async {
    setState(() {
      tasks.add(newTask);
    });
    await TaskData.saveTasks(tasks);
  }

  Future<void> _toggleTaskCompletion(int index) async {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
    await TaskData.saveTasks(tasks);
  }

  Future<void> _deleteTask(int index) async {
    bool shouldDelete = false;
    shouldDelete = await _showDeleteConfirmationDialog();
    if (shouldDelete) {
      setState(() {
        tasks.removeAt(index);
      });
      await TaskData.saveTasks(tasks);
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

  Future<void> _editTask(int index) async {
    final editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: tasks[index]),
      ),
    );
    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
      });
      await TaskData.saveTasks(tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                _deleteTask(index);
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
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => _toggleTaskCompletion(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editTask(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTaskTitle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTaskTitle != null) {
            final newTask = Task(title: newTaskTitle, isCompleted: false);
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}