import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_example/constants/constants.dart';

class VideoDatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final columnId = '_id';

  static final name = 'name';
  static final file_link = 'file_link';
  static final start_from = 'start_from';
  static final end_on = 'end_on';
  static final image_link = 'image_link';
  static final have_image = 'have_image';
  static final day_count = 'day_count';
  static final time_to_play_image = 'time_to_play_image';
  

  static final title = 'title';
  static final content = 'content';
  static final targeted_time = 'targeted_time';

  static final log_table = 'log_table';
  static final video_id = 'video_id';
  static final type = 'type';
  static final is_played = 'is_played';
  static final played_time = 'played_time';

  // make this a singleton class
  VideoDatabaseHelper._privateConstructor();
  static final VideoDatabaseHelper instance =
      VideoDatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $video_table (
            $name TEXT ,
            $columnId INTEGER PRIMARY KEY,
            $day_count INTEGER NOT NULL,
            $file_link TEXT NOT NULL,
            $start_from DATETIME NOT NULL,
            $end_on DATETIME NOT NULL,
            $image_link TEXT ,
            $have_image BOOLEAN NOT NULL,
            $time_to_play_image INTEGER
           
          )
          ''');

    await db.execute('''
          CREATE TABLE $notice_table (

            $columnId INTEGER PRIMARY KEY,
            $title TEXT NOT NULL,
            $content TEXT NOT NULL,
            $start_from DATETIME NOT NULL,
            $end_on DATETIME NOT NULL,
            $targeted_time DATETIME 
          
          )
          ''');
    await db.execute('''
          CREATE TABLE $log_table (

            $columnId INTEGER PRIMARY KEY,
            $video_id INTEGER ,
            $played_time DATETIME NOT NULL,
            $type BOOLEAN NOT NULL, 
            $is_played BOOLEAN NOT NULL
          
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String _table) async {
    Database db = await instance.database;
    return await db.insert(_table, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String _table) async {
    Database db = await instance.database;
    return await db.query(_table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String _table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_table'));
  }

  Future<int> queryRowCountWithId(String _table, int _video_id) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM $_table WHERE video_id = $_video_id'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String _table) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String _table) async {
    Database db = await instance.database;
    return await db.delete(_table, where: '$columnId = ?', whereArgs: [id]);
  }
}
