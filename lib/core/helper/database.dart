import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../feature/data/model/datamodel.dart';

class DatabaseHelper {
  static const String _tableName = 'todos';
  static const String _dbName = 'todo.db';

  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initdatabase();
    return _database!;
  }

  Future<Database> initdatabase() async {
    final datapath = await getDatabasesPath();

    final path = join(datapath, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<Datamodel> insert(Datamodel datamodel) async {
    final db = await database;
    datamodel.id = await db.insert(_tableName, datamodel.toMap());
    return datamodel;
  }

  Future<List<Datamodel>> getTasks() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return maps.map((map) => Datamodel.fromMap(map)).toList();
  }

  Future<int> update(Datamodel datamodel) async {
    final db = await database;
    return await db.update(
      _tableName,
      datamodel.toMap(),
      where: 'id = ?',
      whereArgs: [datamodel.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
