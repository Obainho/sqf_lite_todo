import 'package:sqflite/sqflite.dart';
import 'package:sqlite_provider_starter/models/todo.dart';
import 'package:sqlite_provider_starter/models/user.dart';
import 'package:path/path.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._initialize();
  static Database? _database;
  TodoDatabase._initialize();

  Future _createDB(Database db, int version) async {
    final userUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    // import user.dart
    await db.execute('''CREATE TABLE $userTable (
      ${UserFields.username} $userUsernameType,
      ${UserFields.name} $textType
    )''');

    // import todo.dart
    await db.execute('''CREATE TABLE $todoTable (
      ${TodoFields.username} $textType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType,
      ${TodoFields.created} $textType,
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.username})
    )''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filname) async {
    // creating the database
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filname); //import 'path/path.dart'

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future close() async {
    // closing the database
    final db = await instance.database;
    db!.close;
  }

  Future<Database?> get database async {
    // getting back the database or opening up a new database
    if (_database != null) {
      // if database already exists
      return _database;
    } else {
      // if database doesnt exist, then initialize
      _database = await _initDB('todo.db');
      return _database;
    }
  }

// CRUD operations - Create, Read, Update, and Delete users

  Future<User> createUser(User user) async {
    // Create
    final db = await instance.database;
    await db!.insert(
      userTable,
      user.toJson(),
    );
    return user;
  }

  Future<User> getUser(String username) async {
    // Read
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception(
          'The user, $username cannot be found, please verify entry.');
    }
  }

  Future<List<User>> getAllUsers() async {
    // Read
    final db = await instance.database;
    final result = await db!.query(
      userTable,
      orderBy: '${UserFields.username} ASC', // ASC is for Ascending order
    );
    return result.map((e) => User.fromJson(e)).toList();
  }

  Future<int> updateUser(User user) async {
    // update
    final db = await instance.database;
    return db!.update(
      userTable,
      user.toJson(), // this is the record being updated
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    // Delete
    final db = await instance.database;
    return db!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }

// CRUD operations for ToDo

  Future<Todo> createTodo(Todo todo) async {
    // Create
    final db = await instance.database;
    await db!.insert(
      todoTable,
      todo.toJson(),
    );
    return todo;
  }

  Future<int> toggleTodoDone(Todo todo) async {
    // update
    final db = await instance.database;
    todo.done = !todo.done;
    return db!.update(
      todoTable,
      todo.toJson(), // this is the record being updated
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }

  Future<List<Todo>> getTodos(String username) async {
    // Read
    final db = await instance.database;
    final result = await db!.query(
      todoTable,
      orderBy: '${TodoFields.created} DESC', // DESC is for Descending order
      where: '${TodoFields.username} = ?',
      whereArgs: [username],
    );
    return result.map((e) => Todo.fromJson(e)).toList();
  }

  Future<int> deleteTodo(Todo todo) async {
    // Delete
    final db = await instance.database;
    return db!.delete(
      todoTable,
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }
}
