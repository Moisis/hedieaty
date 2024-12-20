import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/database/local/sqlite_barcode_dao.dart';
import 'package:hedieaty/data/models/gift.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fake_async/fake_async.dart';

class MockDatabase extends Mock implements Database {}
class MockGift extends Mock implements Gift {}

void main() {
  group('SQLiteBarcodeDataSource', () {
    late SQLiteBarcodeDataSource dataSource;
    late MockDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockDatabase();
      dataSource = SQLiteBarcodeDataSource();
      dataSource.db = mockDatabase;
    });

    test('getGift returns a Gift object when data is found', () async {
      // Arrange
      const barcodeId = '6001065600048';
      final mockGiftData = {
        'BarcodeId': barcodeId,
        'GiftName': 'Test Gift',
        'GiftDescription': 'Test Description',
        'GiftCar': 'Test Description',
        'GiftPrice': 50.0,
        'GiftStatus': 'Test Description',
        'GiftEventId': 'Test Description',
      };

      // Mocking the query method to return a future with mock data
      when(mockDatabase.query(
        'Barcodes',
        where: 'BarcodeId = ?',
        whereArgs: [barcodeId],
      )).thenAnswer((_) async => [mockGiftData]);  // Return a List of Maps

      // Act
      final gift = await dataSource.getGift(barcodeId);

      // Assert
      expect(gift, isA<Gift>());
      expect(gift?.GiftId, barcodeId);
      expect(gift?.GiftName, 'Test Gift');
      expect(gift?.GiftDescription, 'Test Description');
      expect(gift?.GiftPrice, 50.0);
    });

    test('getGift returns null when no data is found', () async {
      // Arrange
      const barcodeId = '123';

      // Mocking the query method to return an empty list
      when(mockDatabase.query(
        'Barcodes',
        where: 'BarcodeId = ?',
        whereArgs: [barcodeId],
      )).thenAnswer((_) async => []);  // Return an empty List

      // Act
      final gift = await dataSource.getGift(barcodeId);

      // Assert
      expect(gift, isNull);
    });
  });
}
