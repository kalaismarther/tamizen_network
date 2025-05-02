class EditPostRequestModel {
  final String userId;
  final String postId;
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
  final String status;

  EditPostRequestModel(
      {required this.userId,
      required this.postId,
      required this.productName,
      required this.imagesPath,
      required this.availableQuantity,
      required this.categoryId,
      required this.description,
      required this.contactName,
      required this.contactEmail,
      required this.contactNumber,
      required this.showContactNumber,
      required this.cityId,
      required this.status});
}
