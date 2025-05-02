import 'package:product_sharing/model/auth/city_model.dart';

class SignupRequestModel {
  final String name;
  final String email;
  final String password;
  final String mobile;
  final CityModel city;
  final String deviceType;

  SignupRequestModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.mobile,
      required this.city,
      required this.deviceType});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
        'city_id': city.id,
        'device_type': deviceType,
      };
}
