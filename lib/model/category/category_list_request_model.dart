class CategoryListRequestModel {
  final String userId;
  final int pageNo;
  final String search;
  final String apiToken;

  CategoryListRequestModel(
      {required this.userId,
      required this.pageNo,
      required this.search,
      required this.apiToken});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'pag_no': pageNo, 'search': search};
}
