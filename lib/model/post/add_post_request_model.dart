class AddPostRequestModel {
  final String userId;
  final String productName;
  final List<String> imagesPath;
  final int availableQuantity;
  final String categoryId;
  final String description;
  final String contactName;
  final String contactEmail;
  final String contactNumber;
  final bool showContactNumber;
  final String cityId;

  AddPostRequestModel(
      {required this.userId,
      required this.productName,
      required this.imagesPath,
      required this.availableQuantity,
      required this.categoryId,
      required this.description,
      required this.contactName,
      required this.contactEmail,
      required this.contactNumber,
      required this.showContactNumber,
      required this.cityId});
}
