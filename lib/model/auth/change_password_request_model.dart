class ChangePasswordRequestModel {
  final String userId;
  final String password;

  ChangePasswordRequestModel({required this.userId, required this.password});

  Map<String, dynamic> toJson() => {'user_id': userId, 'password': password};
}
