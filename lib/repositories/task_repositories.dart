import 'package:realm/realm.dart';
import 'package:todo_application/database/realm_services.dart';
import '../database/realm_models.dart' as realm_db;
import '../models/task.dart';
import '../models/tag.dart';

class TaskRepository {
  final RealmService realmService;

  TaskRepository(this.realmService);

  Realm get _realm => realmService.realm;

  Future<ObjectId> insertTag(Tag tag) async {
    final existing = _realm.query<realm_db.Tag>('name == \$0', [
      tag.name,
    ]).firstOrNull;

    if (existing != null) return existing.id;

    late ObjectId newId;

    _realm.write(() {
      final newTag = realm_db.Tag(ObjectId(), tag.name);
      _realm.add(newTag);
      newId = newTag.id;
    });

    return newId;
  }

  Future<List<Tag>> getAllTags() async {
    final realmTags = _realm.all<realm_db.Tag>();

    return realmTags.map((t) => Tag.fromRealm(t)).toList();
  }

  Future<void> deleteTag(ObjectId tagId) async {
    final tag = _realm.find<realm_db.Tag>(tagId);

    if (tag != null) {
      _realm.write(() {
        _realm.delete(tag);
      });
    }
  }

  Future<void> deleteAllTags() async {
    final tags = _realm.all<realm_db.Tag>();
    _realm.write(() {
      _realm.deleteMany(tags);
    });
  }



  Future<void> addTask(Task task) async {
    _realm.write(() {
      // Resolve tags (create if not exists)
      final realmTags = task.tags.map((tag) {
        final existing = _realm.query<realm_db.Tag>('name == \$0', [
          tag.name,
        ]).firstOrNull;

        return existing ?? _realm.add(realm_db.Tag(ObjectId(), tag.name));
      }).toList();

      _realm.add(
        realm_db.Task(
          ObjectId(),
          task.title,
          task.description,
          task.createdAt,
          deadline: task.deadline,
          tags: realmTags,
        ),
      );
    });
  }

  Future<List<Task>> getAllTasks() async {
    final realmTasks = _realm.all<realm_db.Task>();

    return realmTasks.map((realmTask) => Task.fromRealm(realmTask)).toList();
  }

  Future<void> deleteTask(ObjectId taskId) async {
    final task = _realm.find<realm_db.Task>(taskId);

    if (task != null) {
      _realm.write(() {
        _realm.delete(task);
      });
    }
  }

  Future<List<Task>> searchTasks({
    String? query,
    List<ObjectId>? tagIds,
  }) async {
    RealmResults<realm_db.Task> results = _realm.all<realm_db.Task>();

    // 🔍 Search by title or description
    if (query != null && query.isNotEmpty) {
      results = results.query(
        'title CONTAINS[c] \$0 OR description CONTAINS[c] \$0',
        [query],
      );
    }

    // 🏷 Filter by tags
    if (tagIds != null && tagIds.isNotEmpty) {
      results = results.query('ANY tags.id IN \$0', [tagIds]);
    }

    return results.map((realmTask) => Task.fromRealm(realmTask)).toList();
  }
}
