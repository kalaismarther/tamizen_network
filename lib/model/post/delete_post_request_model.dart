class DeletePostRequestModel {
  final String userId;
  final String postId;

  DeletePostRequestModel({required this.userId, required this.postId});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'id': postId, 'type': 'post'};
}
