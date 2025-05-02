class ChatModel {
  final String id;
  final String content;
  final String creatorImage;
  final String creatorName;
  final String createdTime;
  int likesCount;
  bool isLiked;
  int commentsCount;
  bool byMe;

  ChatModel(
      {required this.id,
      required this.content,
      required this.creatorImage,
      required this.creatorName,
      required this.createdTime,
      this.likesCount = 0,
      required this.isLiked,
      this.commentsCount = 0,
      this.byMe = false});

  factory ChatModel.fromJson(Map<dynamic, dynamic> json, String myUserId) =>
      ChatModel(
          id: json['id']?.toString() ?? '',
          content: json['comment']?.toString() ?? '',
          creatorImage: json['is_user']?.toString() ?? '',
          creatorName: json['is_user_name']?.toString() ?? '',
          createdTime: json['is_date']?.toString() ?? '',
          likesCount: int.tryParse(json['total_like']?.toString() ?? '0') ?? 0,
          isLiked: json['is_like']?.toString() == '1',
          commentsCount:
              int.tryParse(json['total_comment']?.toString() ?? '0') ?? 0,
          byMe: myUserId == (json['user_id']?.toString() ?? ''));
}
