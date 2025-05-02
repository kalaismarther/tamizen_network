class RequestedCustomerListRequestModel {
  final String userId;
  final String postId;
  final int pageNo;

  RequestedCustomerListRequestModel(
      {required this.userId, required this.postId, required this.pageNo});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'product_id': postId,
        'pag_no': pageNo,
      };
}
