import 'package:hedieaty/domain/entities/gift_entity.dart';


abstract class GiftRepository {
  Future<void> addGift(GiftEntity gift);
  Future<void> deleteGift(GiftEntity gift);
  Future<void> updateGift(GiftEntity gift);

  Future<void> deleteGiftsEvent(String Eventid);

  Future<List<GiftEntity>> getGifts();
  Future<GiftEntity?> getGiftById(String id);
  Future<List<GiftEntity>> getGiftsListbyEventId(String eventId);
  Stream<List<GiftEntity>> getStreamGift(String eventId);

  Future<List<GiftEntity>?> getPledgedGifts(String userid);

  Future<void> syncGifts();

}