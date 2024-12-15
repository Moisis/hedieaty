

import 'package:hedieaty/domain/entities/friend_entity.dart';
import 'package:hedieaty/domain/repos_head/friend_repository.dart';

class GetFriends {
  final FriendRepository repository;

  GetFriends(this.repository);

  Future<List<FriendEntity>> call(String id) async {
    return await repository.getFriends(id);
  }
}