class RequestedCustomerModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String profileImageUrl;
  final String cityName;

  RequestedCustomerModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.email,
      required this.profileImageUrl,
      required this.cityName});

  factory RequestedCustomerModel.fromJson(Map<String, dynamic> json) =>
      RequestedCustomerModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        profileImageUrl: json['is_user_image']?.toString() ?? '',
        cityName: json['is_city_name']?.toString() ?? '',
      );
}
