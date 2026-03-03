import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import '../models/task.dart';

// ignore: must_be_immutable
class TaskCard extends StatelessWidget {
  final Task task;
  final bool canEdited;
  const TaskCard({super.key, required this.task, required this.canEdited});

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkGreen,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.borderRadiusXLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(
                    AppTheme.borderRadiusSmall,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.textWhite),
              title: const Text(
                "Edit",
                style: TextStyle(color: AppTheme.textWhite),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.accentRed),
              title: const Text(
                "Delete",
                style: TextStyle(color: AppTheme.accentRed),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _showDeleteConfirmation(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final vm = context.read<TaskViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGreen,
        title: const Text(
          "Delete Task",
          style: TextStyle(color: AppTheme.textWhite),
        ),
        content: const Text(
          "Are you sure you want to delete this task?",
          style: TextStyle(color: AppTheme.textWhite70),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppTheme.textWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text(
              "Delete",
              style: TextStyle(color: AppTheme.textWhite),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && task.id != null) {
      vm.deleteTask(task.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat('MMM d, yyyy').format(task.createdAt);

    final deadline = task.deadline != null
        ? DateFormat('MMM d, yyyy').format(task.deadline!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(task.title, style: AppTheme.titleStyle),
              const Spacer(),
              if (canEdited)
                IconButton(
                  onPressed: () => _showOptionsBottomSheet(context),
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.textWhite70,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          if (task.description.isNotEmpty)
            Text(task.description, style: AppTheme.bodyStyle),

          const SizedBox(height: 10),

          if (task.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: task.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusLarge,
                        ),
                      ),
                      child: Text(
                        tag.name.toUpperCase(),
                        style: AppTheme.tagStyle,
                      ),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppTheme.textWhite38),
              const SizedBox(width: 6),
              Text("Created at $createdAt", style: AppTheme.labelStyle),
              const Spacer(),
              if (deadline != null) ...[
                const Icon(
                  Icons.calendar_month,
                  size: 14,
                  color: AppTheme.accentRed,
                ),
                const SizedBox(width: 6),
                Text(
                  "Due: $deadline",
                  style: const TextStyle(
                    color: AppTheme.accentRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          const Divider(color: AppTheme.textWhite38, height: 10),
        ],
      ),
    );
  }
}
