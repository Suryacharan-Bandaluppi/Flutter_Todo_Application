import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/tag.dart';

class TaskRepository {
  final DatabaseHelper dbHelper;

  TaskRepository(this.dbHelper);

  Future<void> addTask(Task task) async {
    final taskId = await dbHelper.insertTask(task);

    for (var tag in task.tags) {
      int tagId;

      if (tag.id == null) {
        tagId = await dbHelper.insertTag(tag);
      } else {
        tagId = tag.id!;
      }

      await dbHelper.insertTaskTag(taskId, tagId);
    }
  }

  Future<List<Task>> getAllTasks() async {
    return await dbHelper.getTasksWithTags();
  }

  Future<List<Tag>> getAllTags() async {
    return await dbHelper.getAllTags();
  }

  Future<void> deleteTask(int taskId) async {
    await dbHelper.deleteTask(taskId);
  }

  Future<void> deleteTag(int tagId) async {
    await dbHelper.deleteTag(tagId);
  }

  Future<List<Task>> searchTasks({String? query, List<int>? tagIds}) async {
    return await dbHelper.searchTasks(query: query, tagIds: tagIds);
  }
}
