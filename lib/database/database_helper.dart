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

  // Add a tag if it doesn't exist
  Future<ObjectId> getOrCreateTag(String tagName) async {
    final existingTag = realm.all<realm_db.Tag>().firstWhere(
      (tag) => tag.name.toLowerCase() == tagName.toLowerCase(),
      orElse: () {
        final newTag = realm_db.Tag(ObjectId(), tagName);
        realm.write(() {
          realm.add(newTag);
        });
        return newTag;
      },
    );
    return existingTag.id;
  }

  // TASK OPERATIONS
  Future<ObjectId> addTask(Task task) async {
    // Resolve tags (create if not exists)
    final realmTags = task.tags.map((tag) {
      final existing = realm.all<realm_db.Tag>().firstWhere(
        (t) => t.name.toLowerCase() == tag.name.toLowerCase(),
        orElse: () {
          final newTag = realm_db.Tag(ObjectId(), tag.name);
          realm.add(newTag);
          return newTag;
        },
      );
      return existing;
    }).toList();

    late ObjectId newId;
    realm.write(() {
      final realmTask = realm_db.Task(
        ObjectId(),
        task.title,
        task.description,
        task.createdAt,
        deadline: task.deadline,
        tags: realmTags,
      );
      realm.add(realmTask);
      newId = realmTask.id;
    });
    return newId;
  }

  Future<List<Task>> getAllTasks() async {
    final realmTasks = realm.all<realm_db.Task>().toList();
    return realmTasks.map((t) => Task.fromRealm(t)).toList();
  }

  Future<List<Task>> searchTasks({
    String? query,
    List<ObjectId>? tagIds,
  }) async {
    RealmResults<realm_db.Task> results = realm.all<realm_db.Task>();

    //  Search by title or description
    if (query != null && query.isNotEmpty) {
      results = results.query(
        'title CONTAINS[c] \$0 OR description CONTAINS[c] \$0',
        [query.trim()],
      );
    }

    // Filter by tags
    if (tagIds != null && tagIds.isNotEmpty) {
      results = results.query('ANY tags.id IN \$0', [tagIds]);
    }

    return results.map((realmTask) => Task.fromRealm(realmTask)).toList();
  }

  // UPDATE TASK
  Future<void> updateTask(Task task) async {
    final existingTask = realm.find<realm_db.Task>(task.id!);
    if (existingTask == null) return;

    // Resolve tags (create if not exists)
    final realmTags = task.tags.map((tag) {
      final existing = realm.all<realm_db.Tag>().firstWhere(
        (t) => t.name.toLowerCase() == tag.name.toLowerCase(),
        orElse: () {
          final newTag = realm_db.Tag(ObjectId(), tag.name);
          realm.add(newTag);
          return newTag;
        },
      );
      return existing;
    }).toList();

    realm.write(() {
      existingTask.title = task.title;
      existingTask.description = task.description;
      existingTask.deadline = task.deadline;
      existingTask.isCompleted = task.isCompleted ?? existingTask.isCompleted;
      existingTask.tags.clear();
      for (final tag in realmTags) {
        existingTask.tags.add(tag);
      }
    });
  }

  // UPDATE TASK COMPLETION STATUS
  Future<void> updateTaskCompletion(ObjectId taskId, bool isCompleted) async {
    final existingTask = realm.find<realm_db.Task>(taskId);
    if (existingTask == null) return;

    realm.write(() {
      existingTask.isCompleted = isCompleted;
    });
  }

  void close() {
    realmService.close();
  }
}
