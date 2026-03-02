import 'package:flutter/material.dart';
import 'package:todo_application/repositories/task_repositories.dart';
import '../models/task.dart';
import '../models/tag.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository repository;

  TaskViewModel(this.repository);

  List<Task> _tasks = [];
  List<Tag> _tags = [];
  List<Tag> _selectedTags = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = "";
  List<Tag> _filterTags = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  List<Tag> get tags => _tags;
  List<Tag> get selectedTags => _selectedTags;
  List<Tag> get filterTags => _filterTags;
  bool get isLoading => _isLoading;
  List<Task> get filteredTasks => _filteredTasks;

  Future<void> loadInitialData() async {
    _setLoading(true);
    await loadTasks();
    await loadTags();
    _applyFilters(); // Apply filters on load to show all tasks initially
    _setLoading(false);
  }

  Future<void> loadTasks() async {
    _tasks = await repository.getAllTasks();
    notifyListeners();
  }

  Future<void> loadTags() async {
    _tags = await repository.getAllTags();
    notifyListeners();
  }

  void toggleTag(Tag tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  void clearSelectedTags() {
    _selectedTags.clear();
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    DateTime? deadline,
  }) async {
    final newTask = Task(
      title: title,
      description: description,
      createdAt: DateTime.now(),
      deadline: deadline,
      tags: _selectedTags,
    );

    await repository.addTask(newTask);

    await loadTasks();
    clearSelectedTags();
  }

  // DELETE TASK
  Future<void> deleteTask(int taskId) async {
    await repository.deleteTask(taskId);
    await loadTasks();
  }

  // DELETE TAG
  Future<void> deleteTag(int tagId) async {
    await repository.deleteTag(tagId);
    await loadTags();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    _applyFilters();
  }

  void toggleFilterTag(Tag tag) {
    if (_filterTags.contains(tag)) {
      _filterTags.remove(tag);
    } else {
      _filterTags.add(tag);
    }
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    final tagIds = _filterTags.map((e) => e.id!).toList();

    _filteredTasks = await repository.searchTasks(
      query: _searchQuery,
      tagIds: tagIds.isEmpty ? null : tagIds, // If no tags selected, show all
    );

    notifyListeners();
  }
}
