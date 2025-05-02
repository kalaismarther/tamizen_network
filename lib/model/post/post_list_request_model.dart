class PostListRequestModel {
  final String userId;
  final int pageNo;
  final String cityId;
  final String? search;
  final String? type;
  final String? categoryId;
  final bool? myPost;
  final bool? wishlist;
  final String apiToken;

  PostListRequestModel(
      {required this.userId,
      required this.pageNo,
      required this.cityId,
      this.search,
      this.type,
      this.categoryId,
      this.myPost,
      this.wishlist,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'pag_no': pageNo,
        'city_id': cityId,
        if (search != null && search?.isNotEmpty == true) 'search': search,
        if (type != null) 'type': type,
        if (categoryId != null) 'category_id': categoryId,
        if (myPost == true) 'my_post': '1',
        if (wishlist == true) 'is_wishlist': '1',
      };
}
