


import 'package:hedieaty/domain/entities/friend_entity.dart';


import '../../repos_head/friend_repository.dart';

class AddFriend {
  final FriendRepository friendRepository;

  AddFriend(this.friendRepository);

  Future<void> call(FriendEntity friend) async {
    return await friendRepository.addFriend(friend);
  }
}