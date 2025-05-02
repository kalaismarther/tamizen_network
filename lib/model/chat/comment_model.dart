class CommentModel {
  final String id;
  final String content;
  final String creatorImage;
  final String creatorName;
  final String createdTime;
  bool byMe;

  CommentModel(
      {required this.id,
      required this.content,
      required this.creatorImage,
      required this.creatorName,
      required this.createdTime,
      this.byMe = false});

  factory CommentModel.fromJson(Map<dynamic, dynamic> json, String myUserId) =>
      CommentModel(
          id: json['id']?.toString() ?? '',
          content: json['comment']?.toString() ?? '',
          creatorImage: json['is_user']?.toString() ?? '',
          creatorName: json['is_user_name']?.toString() ?? '',
          createdTime: json['is_date']?.toString() ?? '',
          byMe: myUserId == (json['user_id']?.toString() ?? ''));
}
