import 'package:hedieaty/domain/entities/gift_entity.dart';


abstract class GiftRepository {
  Future<void> addGift(GiftEntity gift);
  Future<void> deleteGift(GiftEntity gift);
  Future<void> updateGift(GiftEntity gift);
  Future<List<GiftEntity>> getGifts();
  Future<GiftEntity?> getGiftById(String id);
  Future<List<GiftEntity>> getGiftsListbyEventId(String eventId);

}