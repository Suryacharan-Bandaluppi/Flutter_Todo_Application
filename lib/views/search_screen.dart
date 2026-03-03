import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import 'package:todo_application/views/task_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.darkGreen,
      appBar: AppBar(
        backgroundColor: AppTheme.darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Search & Filter",
          style: TextStyle(
            color: AppTheme.textWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: AppTheme.paddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: AppTheme.inputDecoration(
                hintText: "Search tasks, descriptions...",
                borderRadius: AppTheme.borderRadiusLarge,
              ),
              onChanged: vm.setSearchQuery,
            ),

            const SizedBox(height: 20),


            Wrap(
              spacing: 10,
              children: vm.tags.map((tag) {
                final isSelected = vm.filterTags.contains(tag);

                return GestureDetector(
                  onTap: () => vm.toggleFilterTag(tag),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: AppTheme.tagDecoration(
                        isSelected: isSelected,
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.textBlack
                              : AppTheme.textWhite,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: vm.filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        "No Results Found",
                        style: TextStyle(color: AppTheme.textWhite54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: vm.filteredTasks.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          task: vm.filteredTasks[index],
                          canEdited: false,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
