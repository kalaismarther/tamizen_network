class DeleteCommentRequestModel {
  final String userId;
  final String chatId;
  final String commentId;

  DeleteCommentRequestModel(
      {required this.userId, required this.chatId, required this.commentId});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'post_id': chatId, 'id': commentId};
}
