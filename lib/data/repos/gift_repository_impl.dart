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
  Future<List<GiftEntity>> getGifts() async {

    final gifts = await sqliteDataSource.getGifts();

    return gifts.map((event) => GiftEntity(
        GiftId: event.GiftId,
        GiftName: event.GiftName,
        GiftDescription: event.GiftDescription,
        GiftPrice: event.GiftPrice,
        GiftCat: event.GiftCat,
        GiftStatus: event.GiftStatus,
        GiftEventId: event.GiftEventId
    )).toList();
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


  Future<GiftEntity?> getGiftById(String id) async {
    final gift = await sqliteDataSource.getGiftById(id);
    if (gift == null) {
      return null;
    }
    return GiftEntity(
      GiftId: gift.GiftId,
      GiftName: gift.GiftName,
      GiftDescription: gift.GiftDescription,
      GiftPrice: gift.GiftPrice,
      GiftCat: gift.GiftCat,
      GiftStatus: gift.GiftStatus,
      GiftEventId: gift.GiftEventId,
    );
  }

  @override
  Future<List<GiftEntity>> getGiftsListbyEventId(String eventId) async {
    final gifts = await sqliteDataSource.getGiftsListbyEventId(eventId);
    return gifts.map((gift) => GiftEntity(
        GiftId: gift.GiftId,
        GiftName: gift.GiftName,
        GiftDescription: gift.GiftDescription,
        GiftPrice: gift.GiftPrice,
        GiftCat: gift.GiftCat,
        GiftStatus: gift.GiftStatus,
        GiftEventId: gift.GiftEventId
    )).toList();
  }

  @override
  Stream<List<GiftEntity>> getStreamGift(String eventId) {
    return firebaseDataSource.getGiftsStreambyEventId(eventId).map((gifts) => gifts.map((gift) => GiftEntity(
        GiftId: gift.GiftId,
        GiftName: gift.GiftName,
        GiftDescription: gift.GiftDescription,
        GiftPrice: gift.GiftPrice,
        GiftCat: gift.GiftCat,
        GiftStatus: gift.GiftStatus,
        GiftEventId: gift.GiftEventId
    )).toList());

  }

  @override
  Future<List<GiftEntity>?> getPledgedGifts(String userid) async {
    final gifts = await sqliteDataSource.getPledgedGifts(userid);
    return gifts.map((gift) => GiftEntity(
        GiftId: gift.GiftId,
        GiftName: gift.GiftName,
        GiftDescription: gift.GiftDescription,
        GiftPrice: gift.GiftPrice,
        GiftCat: gift.GiftCat,
        GiftStatus: gift.GiftStatus,
        GiftEventId: gift.GiftEventId
    )).toList();
  }

  @override
  Future<void> deleteGiftsEvent(String Eventid) async {
    await sqliteDataSource.deleteGiftsEvent(Eventid);
    await firebaseDataSource.deleteGiftsEvent(Eventid);

  }





}

