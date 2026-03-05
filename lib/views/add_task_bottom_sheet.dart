import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/theme/app_theme.dart';
import 'package:todo_application/utils/toast.dart';
import 'package:todo_application/view_models/task_viewmodel.dart';
import '../models/task.dart';
import '../models/tag.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskBottomSheet({super.key, this.taskToEdit});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _newTagController = TextEditingController();

  DateTime? _selectedDeadline;
  List<Tag> _initialTags = [];
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.taskToEdit?.description ?? '',
    );
    _selectedDeadline = widget.taskToEdit?.deadline;

    if (_isEditMode && widget.taskToEdit != null) {
      _initialTags = List.from(widget.taskToEdit!.tags);
    }

    _ensureDefaultTags();
  }

  bool get _isEditMode => widget.taskToEdit != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newTagController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    if (!_isEditMode) {
      setState(() {
        _hasChanges = _titleController.text.trim().isNotEmpty;
      });
      return;
    }

    final titleChanged =
        _titleController.text.trim() != widget.taskToEdit?.title;
    final descriptionChanged =
        _descriptionController.text.trim() != widget.taskToEdit?.description;
    final deadlineChanged = _selectedDeadline != widget.taskToEdit?.deadline;

    final currentSelectedTags = context.read<TaskViewModel>().selectedTags;
    final tagsChanged =
        _initialTags.length != currentSelectedTags.length ||
        !_initialTags.every(
          (tag) => currentSelectedTags.any((t) => t.id == tag.id),
        );

    setState(() {
      _hasChanges =
          titleChanged || descriptionChanged || deadlineChanged || tagsChanged;
    });
  }

  Future<void> _ensureDefaultTags() async {
    final vm = context.read<TaskViewModel>();
    final defaultTagNames = ['work', 'personal', 'urgent'];

    await vm.loadTags();

    for (final tagName in defaultTagNames) {
      final exists = vm.tags.any((tag) => tag.name.toLowerCase() == tagName);
      if (!exists) {
        final newTag = Tag(name: tagName);
        await vm.repository.insertTag(newTag);
      }
    }

    await vm.loadTags();

    // If editing, set initial selected tags
    if (_isEditMode && widget.taskToEdit != null) {
      vm.setSelectedTags(widget.taskToEdit!.tags);
    } else {
      // For add task mode, clear any previously selected tags
      vm.clearSelectedTags();
    }
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
                Text(
                  _isEditMode ? "Edit Task" : "New Task",
                  style: AppTheme.headingStyle,
                ),
                const SizedBox(height: 20),

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
                  onChanged: (_) => _checkForChanges(),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: AppTheme.textWhite),
                  maxLines: 3,
                  decoration: AppTheme.inputDecoration(hintText: "Description"),
                  onChanged: (_) => _checkForChanges(),
                ),
                const SizedBox(height: 20),

                const Text("Tags", style: AppTheme.bodyStyle),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: vm.tags
                      .map(
                        (tag) => GestureDetector(
                          onTap: () {
                            vm.toggleTag(tag);
                            _checkForChanges();
                          },
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

                          final existingTag = vm.tags.firstWhere(
                            (tag) => tag.name.toLowerCase() == tagName,
                            orElse: () => Tag(name: ''),
                          );

                          if (existingTag.name.isNotEmpty) {
                            // Tag already exists - show snackbar
                            if (context.mounted) {
                              ToastUtil.error('Tag "$tagName" already exists');
                            }
                          } else {
                            // Create new tag
                            final newTag = Tag(name: tagName);
                            await vm.repository.insertTag(newTag);
                            await vm.loadTags();

                            // Auto-select the newly created tag
                            final createdTag = vm.tags.firstWhere(
                              (tag) => tag.name == tagName,
                            );
                            vm.toggleTag(createdTag);
                            _checkForChanges();
                          }

                          _newTagController.clear();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text("Deadline", style: AppTheme.bodyStyle),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDeadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: AppTheme.datePickerTheme(),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      // Store as UTC to avoid timezone issues when persisting to Realm
                      setState(() {
                        _selectedDeadline = DateTime.utc(
                          picked.year,
                          picked.month,
                          picked.day,
                        );
                      });
                      _checkForChanges();
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

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: AppTheme.textWhite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: _hasChanges
                            ? AppTheme.primaryButtonStyle()
                            : AppTheme.secondaryButtonStyle(),
                        onPressed: () async {
                          if (!_hasChanges) return;
                          if (_formKey.currentState!.validate()) {
                            if (_isEditMode && widget.taskToEdit != null) {
                              await vm.updateTask(
                                task: widget.taskToEdit!,
                                title: _titleController.text,
                                description: _descriptionController.text,
                                deadline: _selectedDeadline,
                              );
                              ToastUtil.success("Task Updated Successfully");
                            } else {
                              await vm.addTask(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                deadline: _selectedDeadline,
                              );
                              ToastUtil.success("Task Added Successfully");
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },

                        child: Text(
                          _isEditMode ? "Update Task" : "Add Task",
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
