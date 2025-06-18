class BlockPostRequestModel {
  final String userId;
  final String postId;

  BlockPostRequestModel({required this.userId, required this.postId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'post_id': postId};
}
