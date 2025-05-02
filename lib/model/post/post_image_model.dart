class PostImageModel {
  final String id;
  final String url;

  PostImageModel({required this.id, required this.url});

  factory PostImageModel.fromJson(Map<String, dynamic> json) => PostImageModel(
      id: json['id']?.toString() ?? '',
      url: json['is_image']?.toString() ?? '');
}
