import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/repositories/task_repositories.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import 'package:todo_application/views/task_home_screen.dart';
import 'database/database_helper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              TaskViewModel(TaskRepository(DatabaseHelper.instance))
                ..loadInitialData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Application',
      home: const TaskHomeScreen(),
    );
  }
}
