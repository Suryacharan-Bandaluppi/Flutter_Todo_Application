import 'package:realm/realm.dart';
import '../database/database_helper.dart';
import '../database/realm_models.dart' as realm_db;
import '../models/task.dart';
import '../models/tag.dart';

class TaskRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  TaskRepository();

  Future<ObjectId> insertTag(Tag tag) async {
    final existing = dbHelper.realm.all<realm_db.Tag>().firstWhere(
      (t) => t.name.toLowerCase() == tag.name.toLowerCase(),
      orElse: () => realm_db.Tag(ObjectId(), ''),
    );

    if (existing.name.isNotEmpty &&
        existing.name.toLowerCase() == tag.name.toLowerCase()) {
      return existing.id;
    }

    return await dbHelper.insertTag(tag);
  }

  Future<List<Tag>> getAllTags() async {
    return dbHelper.getAllTags();
  }

  Future<void> deleteTag(ObjectId tagId) async {
    await dbHelper.deleteTag(tagId);
  }

  Future<void> deleteAllTags() async {
    await dbHelper.deleteAllTags();
  }

  Future<void> addTask(Task task) async {
    await dbHelper.addTask(task);
  }

  Future<List<Task>> getAllTasks() async {
    return await dbHelper.getAllTasks();
  }

  Future<void> deleteTask(ObjectId taskId) async {
    await dbHelper.deleteTask(taskId);
  }

  Future<List<Task>> searchTasks({
    String? query,
    List<ObjectId>? tagIds,
  }) async {
    return await dbHelper.searchTasks(query: query, tagIds: tagIds);
  }

  Future<void> updateTask(Task task) async {
    await dbHelper.updateTask(task);
  }

  Future<void> updateTaskCompletion(ObjectId taskId, bool isCompleted) async {
    await dbHelper.updateTaskCompletion(taskId, isCompleted);
  }
}
