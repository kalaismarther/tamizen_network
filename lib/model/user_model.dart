import 'package:product_sharing/model/auth/city_model.dart';

class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final CityModel city;
  final String profileImageUrl;
  final String apiToken;

  UserModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.email,
      required this.city,
      required this.profileImageUrl,
      required this.apiToken});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        city: CityModel(
          id: json['city_id']?.toString() ?? '',
          name: json['is_city_name']?.toString() ?? '',
        ),
        profileImageUrl: json['is_user_image']?.toString() ?? '',
        apiToken: json['auth_token']?.toString() ?? '',
      );
}
