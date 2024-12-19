
import 'package:hedieaty/domain/repos_head/gift_repoitory.dart';

class DeleteGiftsEvent   {

  GiftRepository giftRepository;

  DeleteGiftsEvent(this.giftRepository);

  Future<void> call(String Eventid) async {
    return await giftRepository.deleteGiftsEvent(Eventid);
  }
}