class AddChatRequestModel {
  final String userId;
  final String content;

  AddChatRequestModel({required this.userId, required this.content});

  Map<String, dynamic> toJson() => {'user_id': userId, 'comment': content};
}
