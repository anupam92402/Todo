import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workroom_automation_task/util/task_data.dart';

import '../data/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  int todayTasksToDo = 0;

  LinearGradient changeContainerColor(int index) {
    if (index % 2 == 0) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.orange, Colors.red],
      );
    }
    return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blue, Colors.green],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white60,
        ),
        title: const Text(
          'TODO',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: Colors.white60,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: changeContainerColor(0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Hello, Jane.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Looks like feel good.',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'You have $todayTasksToDo tasks to do today.',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'TODAY : $formattedDate',
                  style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 400,
                    child: FutureBuilder<Map<String, List<Task>>>(
                      future: TaskData.getTasks(),
                      // Fetch a map of DateTime to List<Task>
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While data is being fetched, you can show a loading indicator.
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // If there is an error, you can display an error message.
                          log('${snapshot.error}');
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // When data is loaded successfully, you can build your ListView.
                          Map<String, List<Task>> map = snapshot.data ??
                              {}; // Get the map of tasks from the snapshot

                          // Check if the data is empty or if there's no data for the current date
                          if (map.isEmpty) {
                            // Display a message when there are no tasks for the current date or if data is empty.
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/task',
                                  arguments: formattedDate,
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 16, bottom: 32),
                                elevation: 8,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(24),
                                  child: const Icon(
                                    Icons.add,
                                    size: 200,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          List<List<Task>> allTasksList = [];
                          map.forEach((key, value) {
                            allTasksList.add(map[key] ?? []);
                          });

                          return ListView.builder(
                            itemBuilder: (context, index) {
                              List<Task> currentTaskList = allTasksList[index];
                              int taskCompletedCount = 0;
                              for (int i = 0; i < currentTaskList.length; i++) {
                                if (currentTaskList[i].isCompleted) {
                                  taskCompletedCount++;
                                }
                              }
                              todayTasksToDo = currentTaskList.length - taskCompletedCount;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/task',
                                      arguments: currentTaskList[0].date);
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.only(right: 16, bottom: 32),
                                  elevation: 8,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Container(
                                    width: 250,
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.more_vert,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${currentTaskList.length} Tasks',
                                              // You can replace this with the actual task count
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              currentTaskList.isNotEmpty
                                                  ? currentTaskList[0].date
                                                  : '',
                                              // You can replace this with the actual date
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            LinearProgressIndicator(
                                              value: 1.0 *
                                                  taskCompletedCount /
                                                  currentTaskList.length,
                                              backgroundColor: Colors.grey,
                                              // Background color
                                              valueColor:
                                                  const AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: allTasksList.length,
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ))
              ],
            ),
          )),
    );
  }
}