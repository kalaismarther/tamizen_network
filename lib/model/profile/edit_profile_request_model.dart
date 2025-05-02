class EditProfileRequestModel {
  final String userId;
  final String name;
  final String mobile;
  final String cityId;
  final String profileImagePath;

  EditProfileRequestModel({required this.userId, required this.name, required this.mobile, required this.cityId, required this.profileImagePath});
}
