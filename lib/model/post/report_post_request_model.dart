class ReportPostRequestModel {
  final String userId;
  final String postId;
  final String reason;

  ReportPostRequestModel(
      {required this.userId, required this.postId, required this.reason});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'post_id': postId, 'content': reason};
}
