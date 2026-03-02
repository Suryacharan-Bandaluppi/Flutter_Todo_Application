import 'tag.dart';

class Task {
  final int? id;
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
    int? id,
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
