import 'package:product_sharing/model/auth/city_model.dart';

class PostModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  bool isWishlisted;
  final CityModel city;
  final String ownerName;
  final String ownerId;

  PostModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.isWishlisted,
      required this.city,
      required this.ownerName,
      required this.ownerId});

  factory PostModel.fromJson(Map<dynamic, dynamic> json) => PostModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        imageUrl: json['is_image']?.toString() ?? '',
        isWishlisted: (json['is_wishlist']?.toString() ?? '') == '1',
        city: CityModel.fromJson(json['city'] ?? {}),
        ownerName: json['contact_name']?.toString() ?? '',
        ownerId: json['user_id']?.toString() ?? '',
      );
}
