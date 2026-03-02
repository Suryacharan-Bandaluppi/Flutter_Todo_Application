import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/theme/app_theme.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

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
          /// TITLE
          Text(task.title, style: AppTheme.titleStyle),

          const SizedBox(height: 6),

          /// DESCRIPTION
          if (task.description.isNotEmpty)
            Text(task.description, style: AppTheme.bodyStyle),

          const SizedBox(height: 10),

          /// TAGS
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

          /// CREATED AT + DEADLINE ROW
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppTheme.textWhite38),
              const SizedBox(width: 6),
              Text("Created at $createdAt", style: AppTheme.labelStyle),
              const Spacer(),
              if (deadline != null) ...[
                const Icon(Icons.flag, size: 14, color: AppTheme.accentRed),
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
