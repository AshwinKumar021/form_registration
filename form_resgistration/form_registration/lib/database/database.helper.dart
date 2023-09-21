import 'dart:async';
import 'dart:io';
import 'package:form_registration/model/registration_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "crud.db";
  static final _databaseVersion = 1;
  static final table = 'logindata';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnMobilenum = 'mobileno';
  static final columnEmail = 'email';
  static final columnPwd = 'password';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Lazily instantiate the database if unavailable
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database, creating if it doesn't exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
           CREATE TABLE $table (
             $columnId INTEGER PRIMARY KEY,
             $columnName TEXT NOT NULL,
             $columnMobilenum TEXT NOT NULL,
             $columnEmail TEXT NOT NULL,
             $columnPwd TEXT NOT NULL
           )
           ''');
  }

  // Insert a note into the database
  Future<int> insert(Registrationform note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  // Retrieve all notes from the database
  Future<List<Registrationform>> getAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Registrationform.fromMap(maps[i]);
    });
  }

  // Update a note in the database
  Future<int> update(Registrationform note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  // Delete a note from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
