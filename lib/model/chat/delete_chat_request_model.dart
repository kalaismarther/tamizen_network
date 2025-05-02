class DeleteChatRequestModel {
  final String userId;
  final String chatId;

  DeleteChatRequestModel({required this.userId, required this.chatId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'id': chatId};
}
