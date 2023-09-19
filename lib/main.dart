import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workroom_automation_task/provider/task_provider.dart';
import 'package:workroom_automation_task/views/add_task.dart';
import 'package:workroom_automation_task/views/task_screen.dart';
import 'package:workroom_automation_task/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Define named routes
        routes: {
          '/': (context) => const HomeScreen(),
          '/task': (context) => const TaskListScreen(),
          '/add': (context) => const AddTaskScreen(),
        },
        initialRoute: '/',
    ),
      );
  }
}