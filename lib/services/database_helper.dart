import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'plant_care.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create plants table
    await db.execute('''
      CREATE TABLE plants(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        species TEXT,
        image_path TEXT,
        date_added TEXT NOT NULL,
        last_watered TEXT,
        watering_frequency INTEGER,
        notes TEXT
      )
    ''');

    // Create watering history table
    await db.execute('''
      CREATE TABLE watering_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id TEXT NOT NULL,
        watering_date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (plant_id) REFERENCES plants (id)
      )
    ''');

    // Create plant health records table
    await db.execute('''
      CREATE TABLE health_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id TEXT NOT NULL,
        record_date TEXT NOT NULL,
        condition TEXT NOT NULL,
        diagnosis TEXT,
        treatment TEXT,
        image_path TEXT,
        FOREIGN KEY (plant_id) REFERENCES plants (id)
      )
    ''');
  }

  // Helper methods for Plants

  Future<String> insertPlant(Map<String, dynamic> plant) async {
    final Database db = await database;
    await db.insert('plants', plant);
    return plant['id'];
  }

  Future<List<Map<String, dynamic>>> getAllPlants() async {
    final Database db = await database;
    return await db.query('plants', orderBy: 'date_added DESC');
  }

  Future<Map<String, dynamic>?> getPlant(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updatePlant(Map<String, dynamic> plant) async {
    final Database db = await database;
    return await db.update(
      'plants',
      plant,
      where: 'id = ?',
      whereArgs: [plant['id']],
    );
  }

  Future<int> deletePlant(String id) async {
    final Database db = await database;
    return await db.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper methods for Watering History

  Future<int> insertWateringRecord(Map<String, dynamic> record) async {
    final Database db = await database;
    return await db.insert('watering_history', record);
  }

  Future<List<Map<String, dynamic>>> getWateringHistory(String plantId) async {
    final Database db = await database;
    return await db.query(
      'watering_history',
      where: 'plant_id = ?',
      whereArgs: [plantId],
      orderBy: 'watering_date DESC',
    );
  }

  // Helper methods for Health Records

  Future<int> insertHealthRecord(Map<String, dynamic> record) async {
    final Database db = await database;
    return await db.insert('health_records', record);
  }

  Future<List<Map<String, dynamic>>> getHealthRecords(String plantId) async {
    final Database db = await database;
    return await db.query(
      'health_records',
      where: 'plant_id = ?',
      whereArgs: [plantId],
      orderBy: 'record_date DESC',
    );
  }
} 