import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final String? taskTitle =
    ModalRoute.of(context)?.settings.arguments as String?;
    if (taskTitle != '') {
      _taskController.text = taskTitle ?? '';
    }
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, null);
                        },
                        child: const Icon(Icons.cancel),
                      ),
                      const Expanded(
                        child: Text(
                          'New Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  const Text('What tasks are you planning to perform'),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Task Title',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final newTaskTitle = _taskController.text.trim();
                  if (newTaskTitle.isNotEmpty) {
                    Navigator.pop(context, newTaskTitle);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Set border radius to zero
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}