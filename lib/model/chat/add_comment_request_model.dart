class AddCommentRequestModel {
  final String userId;
  final String chatId;
  final String content;

  AddCommentRequestModel(
      {required this.userId, required this.chatId, required this.content});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'comment': content, 'post_id': chatId};
}
