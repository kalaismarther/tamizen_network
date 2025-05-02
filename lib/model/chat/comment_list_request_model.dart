class CommentListRequestModel {
  final String userId;
  final String chatId;
  final int pageNo;

  CommentListRequestModel(
      {required this.userId, required this.chatId, required this.pageNo});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'post_id': chatId, 'pag_no': pageNo};
}
