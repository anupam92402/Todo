import 'package:flutter/material.dart';
import '../data/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            CheckboxListTile(
              title: const Text('Completed'),
              value: _isCompleted,
              onChanged: (newValue) {
                setState(() {
                  _isCompleted = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final editedTask = Task(
                  title: _titleController.text.trim(),
                  isCompleted: _isCompleted,
                );
                Navigator.pop(context, editedTask);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}