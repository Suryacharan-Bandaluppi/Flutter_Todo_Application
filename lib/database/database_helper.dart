import 'package:realm/realm.dart';
import '../models/task.dart';
import '../models/tag.dart';
import 'realm_services.dart';
import 'realm_models.dart' as realm_db;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  late final RealmService realmService;

  DatabaseHelper._init() {
    realmService = RealmService();
  }

  Realm get realm => realmService.realm;

  // TAG OPERATIONS
  Future<ObjectId> insertTag(Tag tag) async {
    final realmTag = tag.toRealm();
    realm.write(() {
      realm.add(realmTag);
    });
    return realmTag.id;
  }

  Future<List<Tag>> getAllTags() async {
    final realmTags = realm.all<realm_db.Tag>().toList();
    return realmTags.map((t) => Tag.fromRealm(t)).toList();
  }

  // DELETE TAG
  Future<void> deleteTag(ObjectId tagId) async {
    final tag = realm.find<realm_db.Tag>(tagId);
    if (tag != null) {
      realm.write(() {
        realm.delete(tag);
      });
    }
  }

  Future<void> deleteAllTags() async {
    final tags = realm.all<realm_db.Tag>();
    realm.write(() {
      realm.deleteMany(tags);
    });
  }

  // TASK OPERATIONS
  Future<ObjectId> insertTask(Task task) async {
    final realmTask = task.toRealm();
    realm.write(() {
      realm.add(realmTask);
    });
    return realmTask.id;
  }

  Future<void> insertTaskTag(ObjectId taskId, ObjectId tagId) async {
    final task = realm.find<realm_db.Task>(taskId);
    final tag = realm.find<realm_db.Tag>(tagId);
    if (task != null && tag != null) {
      realm.write(() {
        if (!task.tags.contains(tag)) {
          task.tags.add(tag);
        }
      });
    }
  }

  // Fetch tasks with tags
  Future<List<Task>> getTasksWithTags() async {
    final realmTasks = realm.all<realm_db.Task>().toList();
    return realmTasks.map((t) => Task.fromRealm(t)).toList();
  }

  // DELETE TASK
  Future<void> deleteTask(ObjectId taskId) async {
    final task = realm.find<realm_db.Task>(taskId);
    if (task != null) {
      realm.write(() {
        realm.delete(task);
      });
    }
  }

  // SEARCH TASKS
  Future<List<Task>> searchTasks({
    String? query,
    List<ObjectId>? tagIds,
  }) async {
    var realmTasks = realm.all<realm_db.Task>().toList();

    // Filter by query
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      realmTasks = realmTasks.where((task) {
        return task.title.toLowerCase().contains(lowerQuery) ||
            task.description.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // Filter by tag IDs
    if (tagIds != null && tagIds.isNotEmpty) {
      realmTasks = realmTasks.where((task) {
        return task.tags.any((tag) => tagIds.contains(tag.id));
      }).toList();
    }

    return realmTasks.map((t) => Task.fromRealm(t)).toList();
  }

  // Add a tag if it doesn't exist
  Future<ObjectId> getOrCreateTag(String tagName) async {
    final existingTag = realm.all<realm_db.Tag>().firstWhere(
      (tag) => tag.name.toLowerCase() == tagName.toLowerCase(),
      orElse: () => throw Exception('Tag not found'),
    );
    return existingTag.id;
  }

  void close() {
    realmService.close();
  }
}
