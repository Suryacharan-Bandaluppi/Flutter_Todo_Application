// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Tag extends _Tag with RealmEntity, RealmObjectBase, RealmObject {
  Tag(ObjectId id, String name) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  Tag._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<Tag>> get changes =>
      RealmObjectBase.getChanges<Tag>(this);

  @override
  Stream<RealmObjectChanges<Tag>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Tag>(this, keyPaths);

  @override
  Tag freeze() => RealmObjectBase.freezeObject<Tag>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{'id': id.toEJson(), 'name': name.toEJson()};
  }

  static EJsonValue _toEJson(Tag value) => value.toEJson();
  static Tag _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'name': EJsonValue name} => Tag(
        fromEJson(id),
        fromEJson(name),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Tag._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Tag, 'Tag', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty(
        'name',
        RealmPropertyType.string,
        indexType: RealmIndexType.regular,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Task extends _Task with RealmEntity, RealmObjectBase, RealmObject {
  Task(
    ObjectId id,
    String title,
    String description,
    DateTime createdAt, {
    DateTime? deadline,
    bool? isCompleted,
    Iterable<Tag> tags = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'deadline', deadline);
    RealmObjectBase.set(this, 'isCompleted', isCompleted);
    RealmObjectBase.set<RealmList<Tag>>(this, 'tags', RealmList<Tag>(tags));
  }

  Task._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get deadline =>
      RealmObjectBase.get<DateTime>(this, 'deadline') as DateTime?;
  @override
  set deadline(DateTime? value) => RealmObjectBase.set(this, 'deadline', value);

  @override
  bool? get isCompleted =>
      RealmObjectBase.get<bool>(this, 'isCompleted') as bool?;
  @override
  set isCompleted(bool? value) =>
      RealmObjectBase.set(this, 'isCompleted', value);

  @override
  RealmList<Tag> get tags =>
      RealmObjectBase.get<Tag>(this, 'tags') as RealmList<Tag>;
  @override
  set tags(covariant RealmList<Tag> value) => throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Task>> get changes =>
      RealmObjectBase.getChanges<Task>(this);

  @override
  Stream<RealmObjectChanges<Task>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Task>(this, keyPaths);

  @override
  Task freeze() => RealmObjectBase.freezeObject<Task>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'createdAt': createdAt.toEJson(),
      'deadline': deadline.toEJson(),
      'isCompleted': isCompleted.toEJson(),
      'tags': tags.toEJson(),
    };
  }

  static EJsonValue _toEJson(Task value) => value.toEJson();
  static Task _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'createdAt': EJsonValue createdAt,
      } =>
        Task(
          fromEJson(id),
          fromEJson(title),
          fromEJson(description),
          fromEJson(createdAt),
          deadline: fromEJson(ejson['deadline']),
          isCompleted: fromEJson(ejson['isCompleted']),
          tags: fromEJson(ejson['tags']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Task._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Task, 'Task', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('deadline', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('isCompleted', RealmPropertyType.bool, optional: true),
      SchemaProperty(
        'tags',
        RealmPropertyType.object,
        linkTarget: 'Tag',
        collectionType: RealmCollectionType.list,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
