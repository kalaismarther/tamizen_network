class DeletePostImageRequestModel {
  final String userId;
  final String postId;
  final String imageId;

  DeletePostImageRequestModel(
      {required this.userId, required this.postId, required this.imageId});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'type': 'post_image',
        'id': imageId,
        'product_id': postId,
      };
}
