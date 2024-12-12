import 'package:hedieaty/domain/entities/gift_entity.dart';
import 'package:hedieaty/domain/repos_head/gift_repoitory.dart';

import '../database/local/sqlite_gift_dao.dart';
import '../database/remote/firebase_gift_dao.dart';
import '../models/gift.dart';


class GiftRepositoryImpl implements GiftRepository {
  final SQLiteGiftDataSource sqliteDataSource;
  final FirebaseGiftDataSource firebaseDataSource;

  GiftRepositoryImpl({
    required this.sqliteDataSource,
    required this.firebaseDataSource,
  });

  @override
  Future<void> addGift(GiftEntity gift) async {

    final giftModel = Gift(
      GiftId: gift.GiftId,
      GiftName: gift.GiftName,
      GiftDescription: gift.GiftDescription,
      GiftPrice: gift.GiftPrice,
      GiftCat: gift.GiftCat,
      GiftStatus: gift.GiftStatus,
      GiftEventId: gift.GiftEventId
    );

    final existingGift = await sqliteDataSource.getGiftById(gift.GiftId);

    if (existingGift != null) {
      print("Gift already exists in SQLite, skipping insert.");
      return;
    }

    final firebaseGift = await firebaseDataSource.getGiftById(gift.GiftId);

    if (firebaseGift != null) {
      print("Gift already exists in Firebase, skipping insert.");
      return;
    }

    await sqliteDataSource.addGift(giftModel);
    await firebaseDataSource.addGift(giftModel);

  }

  @override
  Future<void> deleteGift(GiftEntity gift)  async{

    await sqliteDataSource.deleteGift(gift.GiftId);
    await firebaseDataSource.deleteGift(gift.GiftId);
  }

  @override
  Future<List<GiftEntity>> getGifts() {
    syncGifts();
    return sqliteDataSource.getGifts();
  }

  @override
  Future<void> updateGift(GiftEntity gift)  async{

    final giftModel = Gift(
      GiftId: gift.GiftId,
      GiftName: gift.GiftName,
      GiftDescription: gift.GiftDescription,
      GiftPrice: gift.GiftPrice,
      GiftCat: gift.GiftCat,
      GiftStatus: gift.GiftStatus,
      GiftEventId: gift.GiftEventId
    );

    await sqliteDataSource.updateGift(giftModel);
    await firebaseDataSource.updateGift(giftModel);

  }

  @override
  Future<void> syncGifts() async {
    firebaseDataSource.getGiftsStream().listen((gifts) async {
      for (var gift in gifts) {
        final existingGift = await sqliteDataSource.getGiftById(gift.GiftId);
        if (existingGift == null) {
          await sqliteDataSource.addGift(gift);
        }else{
          await sqliteDataSource.updateGift(gift);
        }
      }
    });
  }

  @override
  Future<GiftEntity?> getGiftById(String id) {
    syncGifts();
    return sqliteDataSource.getGiftById(id);
  }


  @override
  Future<List<GiftEntity>> getGiftsListbyEventId(String eventId) {
    syncGifts();
    return sqliteDataSource.getGiftsListbyEventId(eventId);
  }







}

