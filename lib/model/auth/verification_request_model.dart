class VerificationRequestModel {
  final String userId;
  final String otp;
  final String? mobile;
  final String deviceId;

  VerificationRequestModel(
      {required this.userId,
      required this.otp,
      this.mobile,
      required this.deviceId});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'otp': otp,
        if (mobile != null) 'mobile': mobile,
        'device_id': deviceId,
        'fcm_id': 'fcmtoken'
      };
}
