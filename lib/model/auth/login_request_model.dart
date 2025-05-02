class LoginRequestModel {
  final String email;
  final String password;
  final String deviceType;
  final String deviceId;
  final String fcmId;

  LoginRequestModel(
      {required this.email,
      required this.password,
      required this.deviceType,
      required this.deviceId,
      required this.fcmId});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'device_type': deviceType,
        'device_id': deviceId,
        'fcm_id': fcmId,
      };
}
