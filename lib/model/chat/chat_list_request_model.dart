class ChatListRequestModel {
  final String userId;
  final int pageNo;

  ChatListRequestModel({required this.userId, required this.pageNo});

  Map<String, dynamic> toJson() => {'user_id': userId, 'pag_no': pageNo};
}
