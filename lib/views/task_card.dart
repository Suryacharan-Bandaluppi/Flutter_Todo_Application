import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/utils/toast.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import 'package:todo_application/views/add_task_bottom_sheet.dart';
import '../models/task.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  final Task task;
  final bool canEdited;
  const TaskCard({super.key, required this.task, required this.canEdited});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool get isCompleted => widget.task.isCompleted ?? false;
  bool get hasTimeForDeadline =>
      widget.task.deadline != null &&
      DateTime.now().isBefore(widget.task.deadline!);

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat('MMM d, yyyy').format(widget.task.createdAt);

    final deadline = widget.task.deadline != null
        ? DateFormat('MMM d, yyyy').format(widget.task.deadline!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.task.title, style: AppTheme.titleStyle),
              const Spacer(),
              if (widget.canEdited)
                isCompleted
                    ? IconButton(
                        onPressed: () async {
                          await _showDeleteConfirmation(context);
                        },
                        icon: Icon(Icons.delete, color: AppTheme.accentRed),
                      )
                    : IconButton(
                        onPressed: () => _showOptionsBottomSheet(context),
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppTheme.textWhite70,
                        ),
                      ),
            ],
          ),

          const SizedBox(height: 6),

          if (widget.task.description.isNotEmpty)
            Text(widget.task.description, style: AppTheme.bodyStyle),

          const SizedBox(height: 10),

          if (widget.task.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: widget.task.tags
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
                isCompleted
                    ? Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppTheme.primaryGreen,
                      )
                    : Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: AppTheme.accentRed,
                      ),
                const SizedBox(width: 6),
                isCompleted
                    ? Text(
                        "Completed",
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        hasTimeForDeadline
                            ? "Due: $deadline"
                            : "Deadline Passed",
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

  void _showOptionsBottomSheet(BuildContext context) {
    final vm = context.read<TaskViewModel>();
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
            if (!isCompleted)
              ListTile(
                leading: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.primaryGreen,
                ),
                title: Text(
                  "Mark as Completed",
                  style: TextStyle(color: AppTheme.textWhite),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() {
                    vm.toggleTaskCompletion(widget.task);
                  });
                },
              ),
            if (!isCompleted)
              ListTile(
                leading: const Icon(Icons.edit, color: AppTheme.primaryGreen),
                title: const Text(
                  "Edit",
                  style: TextStyle(color: AppTheme.textWhite),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => AddTaskBottomSheet(taskToEdit: widget.task),
                  );
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
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppTheme.textWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              ToastUtil.success("Task Deleted Successfully");
            },
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

    if (confirmed == true && widget.task.id != null) {
      vm.deleteTask(widget.task.id!);
    }
  }
}
