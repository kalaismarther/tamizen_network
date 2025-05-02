class SearchHistoryModel {
  final String id;
  final String keyword;

  SearchHistoryModel({required this.id, required this.keyword});

  factory SearchHistoryModel.fromJson(Map<dynamic, dynamic> json) =>
      SearchHistoryModel(
        id: json['id']?.toString() ?? '',
        keyword: json['keyword']?.toString() ?? '',
      );
}
