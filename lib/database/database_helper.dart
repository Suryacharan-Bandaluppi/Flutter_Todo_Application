import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/tag.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        deadline TEXT
      )
    ''');

    // Tags table
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Junction table
    await db.execute('''
      CREATE TABLE task_tags (
        task_id INTEGER,
        tag_id INTEGER,
        PRIMARY KEY (task_id, tag_id),
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');
  }

  // TAG OPERATIONS
  Future<int> insertTag(Tag tag) async {
    final db = await instance.database;
    return await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Tag>> getAllTags() async {
    final db = await instance.database;
    final result = await db.query('tags');
    return result.map((map) => Tag.fromMap(map)).toList();
  }

  // DELETE TAG
  Future<void> deleteTag(int tagId) async {
    final db = await instance.database;
    await db.delete('tags', where: 'id = ?', whereArgs: [tagId]);
  }

  Future<void> deleteAllTags() async {
    final db = await instance.database;
    await db.delete('tags'); // Deletes all rows
  }

  // TASK OPERATIONS
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<void> insertTaskTag(int taskId, int tagId) async {
    final db = await instance.database;
    await db.insert('task_tags', {'task_id': taskId, 'tag_id': tagId});
  }

  // Fetch tasks with tags (JOIN)
  Future<List<Task>> getTasksWithTags() async {
    final db = await instance.database;

    final taskMaps = await db.query('tasks');

    List<Task> tasks = [];

    for (var taskMap in taskMaps) {
      final taskId = taskMap['id'] as int;

      final tagMaps = await db.rawQuery(
        '''
        SELECT tags.id, tags.name
        FROM tags
        INNER JOIN task_tags
        ON tags.id = task_tags.tag_id
        WHERE task_tags.task_id = ?
      ''',
        [taskId],
      );

      List<Tag> tags = tagMaps.map((map) => Tag.fromMap(map)).toList();

      tasks.add(Task.fromMap(taskMap).copyWith(tags: tags));
    }

    return tasks;
  }

  // DELETE TASK
  Future<void> deleteTask(int taskId) async {
    final db = await instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  // SEARCH TASKS
  Future<List<Task>> searchTasks({String? query, List<int>? tagIds}) async {
    final db = await instance.database;

    String whereClause = "";
    List<dynamic> whereArgs = [];

    if (query != null && query.isNotEmpty) {
      whereClause += "(tasks.title LIKE ? OR tasks.description LIKE ?)";
      whereArgs.add("%$query%");
      whereArgs.add("%$query%");
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += " AND ";
      }
      whereClause +=
          "tasks.id IN (SELECT task_id FROM task_tags WHERE tag_id IN (${List.filled(tagIds.length, '?').join(',')}))";
      whereArgs.addAll(tagIds);
    }

    final result = await db.rawQuery('''
    SELECT DISTINCT tasks.*
    FROM tasks
    ${whereClause.isNotEmpty ? "WHERE $whereClause" : ""}
  ''', whereArgs);

    List<Task> tasks = [];

    for (var taskMap in result) {
      final taskId = taskMap['id'] as int;

      final tagMaps = await db.rawQuery(
        '''
      SELECT tags.id, tags.name
      FROM tags
      INNER JOIN task_tags
      ON tags.id = task_tags.tag_id
      WHERE task_tags.task_id = ?
    ''',
        [taskId],
      );

      tasks.add(
        Task.fromMap(
          taskMap,
        ).copyWith(tags: tagMaps.map((e) => Tag.fromMap(e)).toList()),
      );
    }

    return tasks;
  }
}
