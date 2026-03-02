import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/database/database_helper.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import '../models/tag.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _newTagController = TextEditingController();

  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _ensureDefaultTags();
    // deleteTags();
  }

  Future<void> _ensureDefaultTags() async {
    final vm = context.read<TaskViewModel>();
    final defaultTagNames = ['work', 'personal', 'urgent'];

    await vm.loadTags();

    for (final tagName in defaultTagNames) {
      final exists = vm.tags.any((tag) => tag.name.toLowerCase() == tagName);
      if (!exists) {
        await vm.repository.dbHelper.insertTag(Tag(name: tagName));
      }
    }

    await vm.loadTags();
  }

  Future<void> deleteTags() async {
    await DatabaseHelper.instance.deleteAllTags();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.darkGreen,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.borderRadiusXLarge),
            ),
          ),
          padding: AppTheme.paddingLarge,
          child: Form(
            key: _formKey,
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusSmall,
                      ),
                    ),
                  ),
                ),
                const Text("New Task", style: AppTheme.headingStyle),
                const SizedBox(height: 20),

                /// TITLE
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: AppTheme.textWhite),
                  decoration: AppTheme.inputDecoration(hintText: "Task Title"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title can't be empty";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),

                /// DESCRIPTION
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: AppTheme.textWhite),
                  maxLines: 3,
                  decoration: AppTheme.inputDecoration(hintText: "Description"),
                ),
                const SizedBox(height: 20),

                /// TAGS
                const Text(
                  "Tags",
                  style: TextStyle(color: AppTheme.textWhite70),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: vm.tags
                      .map(
                        (tag) => GestureDetector(
                          onTap: () => vm.toggleTag(tag),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: AppTheme.tagDecoration(
                                  isSelected: vm.selectedTags.contains(tag),
                                ),
                                child: Text(
                                  tag.name,
                                  style: TextStyle(
                                    color: vm.selectedTags.contains(tag)
                                        ? AppTheme.textBlack
                                        : AppTheme.textWhite,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 15),

                /// CREATE NEW TAG
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newTagController,
                        style: const TextStyle(color: AppTheme.textWhite),
                        decoration: AppTheme.inputDecoration(
                          hintText: "Create new tag",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.textWhite),
                      onPressed: () async {
                        if (_newTagController.text.isNotEmpty) {
                          final tagName = _newTagController.text
                              .trim()
                              .toLowerCase();

                          // Check if tag already exists (case-insensitive)
                          final existingTag = vm.tags.firstWhere(
                            (tag) => tag.name.toLowerCase() == tagName,
                            orElse: () => Tag(name: ''),
                          );

                          if (existingTag.name.isNotEmpty) {
                            // Tag already exists - show snackbar
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Tag "$tagName" already exists',
                                  ),
                                  backgroundColor: AppTheme.errorRed,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } else {
                            // Create new tag
                            final newTag = Tag(name: tagName);
                            await vm.repository.dbHelper.insertTag(newTag);
                            await vm.loadTags();

                            // Auto-select the newly created tag
                            final createdTag = vm.tags.firstWhere(
                              (tag) => tag.name == tagName,
                            );
                            vm.toggleTag(createdTag);
                          }

                          _newTagController.clear();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// DEADLINE
                const Text(
                  "Deadline",
                  style: TextStyle(color: AppTheme.textWhite70),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: AppTheme.datePickerTheme(),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedDeadline = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: AppTheme.paddingMedium,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium,
                      ),
                      border: Border.all(color: AppTheme.textWhite24),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDeadline == null
                              ? "Select Deadline"
                              : "${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}",
                          style: const TextStyle(color: AppTheme.textWhite),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: AppTheme.primaryButtonStyle(),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await vm.addTask(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              deadline: _selectedDeadline,
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Add Task",
                          style: TextStyle(color: AppTheme.textBlack),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration inputDecoration(String hint) {
    return AppTheme.inputDecoration(hintText: hint);
  }
}
