

import 'package:sqflite/sqflite.dart';

import '../../models/gift.dart';
import 'SQLite.dart';

class SQLiteBarcodeDataSource {
  late Database db;
  bool _isInitialized = false;

  Future<void> init() async {
    db = await DatabaseHelper().database; // Use DatabaseHelper to get the database instance
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<Gift?> getGift(String BarcodeId) async {
    await _ensureInitialized();

    // Query to get a single record by BarcodeId
    final List<Map<String, dynamic>> maps = await db.query(
      'Barcodes',
      where: 'BarcodeId = ?', // filter by BarcodeId
      whereArgs: [BarcodeId], // pass BarcodeId as argument
    );

    // Check if any record is found
    if (maps.isNotEmpty) {
      // Convert the first record to a Gift object

      print(" Gift Parsed     ${maps.first}");
      return Gift.fromJson(maps.first);

    }
    return null; // Return null if no match is found
  }
}
