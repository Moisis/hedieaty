import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'test.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE "Users" (
          "UserId"	INTEGER NOT NULL,
          "UserName"	TEXT NOT NULL,
          "UserEmail"	TEXT NOT NULL UNIQUE,
          "UserPrefs"	TEXT,
          "UserPhone"	TEXT NOT NULL,
          PRIMARY KEY("UserId" AUTOINCREMENT)
        );
    ''');

    await db.execute('''
          CREATE TABLE "Events" (
              "EventId"	INTEGER,
              "EventName"	TEXT NOT NULL,
              "EventDate"	TEXT NOT NULL,
              "EventLocation"	TEXT,
              "EventDescription"	TEXT,
              "UserId"	INTEGER NOT NULL,
              PRIMARY KEY("EventId" AUTOINCREMENT),
              FOREIGN KEY("UserId") REFERENCES "Users"("UserId")
          );
    ''');

    await db.execute('''
          CREATE TABLE "Gifts" (
            "GiftId"	INTEGER,
            "GiftName"	TEXT NOT NULL,
            "GiftDescription"	TEXT,
            "GiftCat"	TEXT,
            "GiftPrice"	REAL,
            "GiftStatus"	TEXT,
            "GiftEventId"	INTEGER,
            PRIMARY KEY("GiftId" AUTOINCREMENT),
            FOREIGN KEY("GiftEventId") REFERENCES "Events"("EventId")
          );
    ''');

    await db.execute('''
        CREATE TABLE "Friends" (
                "UserID"	INTEGER NOT NULL,
                "FriendID"	INTEGER NOT NULL,
                PRIMARY KEY("UserID","FriendID"),
                FOREIGN KEY("FriendID") REFERENCES "Users"("UserId") ON DELETE CASCADE,
                FOREIGN KEY("UserID") REFERENCES "Users"("UserId") ON DELETE CASCADE
        );  
    ''');

  }
}
