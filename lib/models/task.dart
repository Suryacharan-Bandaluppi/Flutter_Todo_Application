import 'package:realm/realm.dart';
import 'tag.dart';
import '../database/realm_models.dart' as realm_db;

class Task {
  final ObjectId? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? deadline;
  final List<Tag> tags;
  final bool? isCompleted;
  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.deadline,
    this.tags = const [],
    this.isCompleted
  });

  // Convert from Realm object to model
  factory Task.fromRealm(realm_db.Task realmTask) {
    return Task(
      id: realmTask.id,
      title: realmTask.title,
      description: realmTask.description,
      createdAt: realmTask.createdAt,
      deadline: realmTask.deadline,
      tags: realmTask.tags.map((t) => Tag.fromRealm(t)).toList(),
      isCompleted: realmTask.isCompleted
    );
  }

  // Convert to Realm object
  realm_db.Task toRealm() {
    return realm_db.Task(
      id ?? ObjectId(),
      title,
      description,
      createdAt,
      deadline: deadline,
      tags: tags.map((t) => t.toRealm()).toList(),
      isCompleted: isCompleted
    );
  }


}
