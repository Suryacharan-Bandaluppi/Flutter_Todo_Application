import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import 'package:todo_application/views/search_screen.dart';
import 'package:todo_application/views/task_card.dart';
import 'add_task_bottom_sheet.dart';

class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        elevation: 0,
        title: const Text(
          "Tasks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30, color: AppTheme.textWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTaskBottomSheet(),
          );
        },
        label: const Text(
          "New Task",
          style: TextStyle(
            color: AppTheme.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.add, color: AppTheme.textBlack),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.tasks.isEmpty
          ? const Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(color: AppTheme.textWhite54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: vm.tasks.length,
              itemBuilder: (context, index) {
                final task = vm.tasks[index];

                return Dismissible(
                  key: Key(task.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppTheme.accentRed,
                    child: const Icon(Icons.delete, color: AppTheme.textWhite),
                  ),
                  onDismissed: (_) {
                    if (task.id != null) {
                      vm.deleteTask(task.id!);
                    }
                  },
                  child: TaskCard(task: task),
                );
              },
            ),
    );
  }
}
