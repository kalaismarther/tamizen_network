class AddWishlistRequestModel {
  final String userId;
  final String postId;

  AddWishlistRequestModel({required this.userId, required this.postId});

  Map<String, dynamic> toJson() => {'user_id': userId, 'product_id': postId};
}
