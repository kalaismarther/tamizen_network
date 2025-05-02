class ReportChatRequestModel {
  final String userId;
  final String chatId;
  final String content;

  ReportChatRequestModel(
      {required this.userId, required this.chatId, required this.content});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'post_id': chatId, 'content': content};
}
