class PostDetailRequestModel {
  final String userId;
  final String postId;

  PostDetailRequestModel({required this.userId, required this.postId});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'product_id': postId,
      };
}
