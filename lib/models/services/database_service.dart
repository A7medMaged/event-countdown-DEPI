import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data_models/event_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  eventDate TEXT NOT NULL,
  userId TEXT NOT NULL
)
''');
  }

  Future<int> createEvent(Event event) async {
    final db = await database;
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getAllEvents(String userId) async {
    final db = await database;
    final result = await db.query('events', where: 'userId = ?', whereArgs: [userId], orderBy: 'eventDate ASC');
    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update('events', event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Map<String, dynamic>>> getRawEventsData() async {
    final db = await database;
    return await db.query('events');
  }
}
