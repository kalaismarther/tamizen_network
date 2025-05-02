class LikeChatRequestModel {
  final String userId;
  final String chatId;
  final bool addLike;

  LikeChatRequestModel(
      {required this.userId, required this.chatId, required this.addLike});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'post_id': chatId, 'type': addLike ? '1' : '2'};
}
