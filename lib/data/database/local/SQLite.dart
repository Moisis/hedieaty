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
    String path = join(dbPath, 'Hedieaty.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
//  "UserEmail"	TEXT NOT NULL UNIQUE,
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE "Users" (
          "UserId"	TEXT NOT NULL,
          "UserName"	TEXT NOT NULL,
          "UserEmail"	TEXT NOT NULL ,
          "UserPass"	TEXT NOT NULL ,
          "UserPrefs"	TEXT,
          "UserPhone"	TEXT NOT NULL,
          PRIMARY KEY("UserId" )
        );
    ''');

    await db.execute('''
          CREATE TABLE "Events" (
              "EventId"	TEXT,
              "EventName"	TEXT NOT NULL,
              "EventDate"	TEXT NOT NULL,
              "EventImageUrl"	TEXT ,
              "EventLocation"	TEXT,
              "EventDescription"	TEXT,
              "UserId"	TEXT NOT NULL,
              PRIMARY KEY("EventId" ),
              FOREIGN KEY("UserId") REFERENCES "Users"("UserId")
          );
    ''');

    await db.execute('''
          CREATE TABLE "Gifts" (
            "GiftId"	TEXT,
            "GiftName"	TEXT NOT NULL,
            "GiftDescription"	TEXT,
            "GiftCat"	TEXT,
            "GiftPrice"	REAL,
            "GiftStatus"	TEXT,
            "GiftEventId"	TEXT,
            PRIMARY KEY("GiftId" ),
            FOREIGN KEY("GiftEventId") REFERENCES "Events"("EventId")
          );
    ''');

    await db.execute('''
        CREATE TABLE "Friends" (
                "UserId"	TEXT NOT NULL,
                "FriendId"	TEXT NOT NULL,
                PRIMARY KEY("UserID","FriendId"),
                FOREIGN KEY("FriendId") REFERENCES "Users"("UserId") ON DELETE CASCADE,
                FOREIGN KEY("UserId") REFERENCES "Users"("UserId") ON DELETE CASCADE
        );  
    ''');

    await db.execute('''
        CREATE TABLE "Barcodes" (
                "BarcodeId"	TEXT NOT NULL,
                 "GiftName"	TEXT NOT NULL,
                  "GiftDescription"	TEXT,
                  "GiftCat"	TEXT,
                  "GiftPrice"	REAL,
                  "GiftStatus"	TEXT,
                  PRIMARY KEY("BarcodeId")
        );  
    ''');

    // Insert 3 records
    await db.insert('Barcodes', {
      'BarcodeId': '3120605329065',
      'GiftName': 'T.Huer Link Lady Watch',
      'GiftDescription': 'A stylish and elegant watch designed for modern women, offering both sophistication and durability. Perfect for any occasion.',
      'GiftCat': 'Accessories',
      'GiftPrice': 200.0,
      'GiftStatus': 'Available',
    });

    await db.insert('Barcodes', {
      'BarcodeId': '6001065600048',
      'GiftName': 'Gadbury Daily Milk Chocolate',
      'GiftDescription': 'Smooth and creamy milk chocolate made with the finest cocoa. A delicious treat for any chocolate lover.',
      'GiftCat': 'Food & Drinks',
      'GiftPrice': 10.0,
      'GiftStatus': 'Available',

    });

    await db.insert('Barcodes', {
      'BarcodeId': '5060478371236',
      'GiftName': 'Xbox 360',
      'GiftDescription': 'A powerful gaming console offering a wide range of games, immersive graphics, and multimedia entertainment for all ages.',
      'GiftCat': 'Electronics',
      'GiftPrice': 300.0,
      'GiftStatus': 'Available',

    });

    // Close the database
    await db.close();


  }
}
