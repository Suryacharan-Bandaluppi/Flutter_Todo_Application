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
  Task({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.deadline,
    this.tags = const [],
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title, 
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'])
          : null,
    );
  }
  Task copyWith({
    ObjectId? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? deadline,
    List<Tag>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      tags: tags ?? this.tags,
    );
  }
}
