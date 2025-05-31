import 'package:product_sharing/config/app_constants.dart';
import 'package:product_sharing/core/utils/auth_helper.dart';
import 'package:product_sharing/core/utils/dio_helper.dart';
import 'package:product_sharing/core/utils/response_status.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/auth/change_password_request_model.dart';
import 'package:product_sharing/model/auth/city_model.dart';
import 'package:product_sharing/model/auth/forgot_password_request_model.dart';
import 'package:product_sharing/model/auth/login_request_model.dart';
import 'package:product_sharing/model/auth/signup_request_model.dart';
import 'package:product_sharing/model/auth/verification_request_model.dart';
import 'package:product_sharing/model/category/category_list_request_model.dart';
import 'package:product_sharing/model/chat/add_chat_request_model.dart';
import 'package:product_sharing/model/chat/add_comment_request_model.dart';
import 'package:product_sharing/model/chat/chat_list_request_model.dart';
import 'package:product_sharing/model/chat/chat_model.dart';
import 'package:product_sharing/model/chat/comment_list_request_model.dart';
import 'package:product_sharing/model/chat/comment_model.dart';
import 'package:product_sharing/model/chat/delete_chat_request_model.dart';
import 'package:product_sharing/model/chat/delete_comment_request_model.dart';
import 'package:product_sharing/model/chat/like_chat_request_model.dart';
import 'package:product_sharing/model/chat/report_chat_request_model.dart';
import 'package:product_sharing/model/faq/faq_model.dart';
import 'package:product_sharing/model/notification/notification_model.dart';
import 'package:product_sharing/model/notification/notification_request_model.dart';
import 'package:product_sharing/model/post/add_post_request_model.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/delete_post_image_request_model.dart';
import 'package:product_sharing/model/post/delete_post_request_model.dart';
import 'package:product_sharing/model/post/edit_post_request_model.dart';
import 'package:product_sharing/model/post/post_detail_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:product_sharing/model/post/requested_customer_list_request_model.dart';
import 'package:product_sharing/model/post/requested_customer_model.dart';
import 'package:product_sharing/model/post/send_request_model.dart';
import 'package:product_sharing/model/profile/edit_profile_request_model.dart';

class ApiServices {
  static Map<String, String> _headersWithoutToken() =>
      {'Content-Type': 'Application/json'};

  static Map<String, String> _headersWithToken() {
    final user = StorageHelper.getUserDetail();
    return {'Content-Type': 'Application/json', 'Authorization': user.apiToken};
  }

  //<---------- SIGN UP SCREEN ------------------>

  static Future<List<CityModel>> getCityList(String keyword) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.cityListUrl,
        headers: _headersWithoutToken(),
        input: {'search': keyword});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final city in response.body['data'] ?? [])
            CityModel.fromJson(city)
        ];
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> getPolicy(String type) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.policyUrl,
        headers: _headersWithoutToken(),
        input: {'type': type});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data']?['message'] ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> userSignup(
      SignupRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.signupUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> userVerification(
      VerificationRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.verifyOtpUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  //<---------- LOGIN SCREEN ------------------>

  static Future<ResponseStatus> userLogin(LoginRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.loginUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        await StorageHelper.write('user', response.body['data'] ?? {});
        await StorageHelper.write('logged', true);
        return ResponseStatus.done;
      } else if (response.body['status']?.toString() == '2') {
        UiHelper.showToast(response.body['message']?.toString() ?? '');
        await StorageHelper.write('user', response.body['data'] ?? {});
        return ResponseStatus.otpNotVerified;
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<ResponseStatus> forgotPassword(
      ForgotPasswordRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.forgotPasswordUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return ResponseStatus.done;
      } else if (response.body['status']?.toString() == '2') {
        await StorageHelper.write('user', response.body['data'] ?? {});
        return ResponseStatus.otpNotVerified;
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> changePassword(
      ChangePasswordRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.changePasswordUrl,
        headers: _headersWithoutToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  //<---------- HOME SCREEN ------------------>

  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.userInfoUrl,
        headers: _headersWithToken(),
        input: {'user_id': userId});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> getCategoryList(
      CategoryListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.categoryListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body;
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<PostModel>> getPostList(PostListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.postListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final product in response.body['data'] ?? [])
            PostModel.fromJson(product)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<NotificationModel>> getNotificationList(
      NotificationRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.notificationListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final notification in response.body['data'] ?? [])
            NotificationModel.fromJson(notification)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<dynamic, dynamic>> postDetail(
      PostDetailRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.postDetailUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> sendRequest(SendRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.sendRequestUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<RequestedCustomerModel>> getRequestedCustomerList(
      RequestedCustomerListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.requestedCustomersUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final product in response.body['data'] ?? [])
            RequestedCustomerModel.fromJson(product)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> addPost(AddPostRequestModel input) async {
    var data = dio.FormData.fromMap({
      'user_id': input.userId,
      'name': input.productName,
      for (int i = 0; i < input.imagesPath.length; i++)
        'images[$i]': await dio.MultipartFile.fromFile(input.imagesPath[i]),
      'quantity': input.availableQuantity,
      'category_id': input.categoryId,
      'description': input.description,
      'contact_name': input.contactName,
      'contact_email': input.contactEmail,
      'contact_number': input.contactNumber,
      'city_id': input.cityId,
      'view_contact': input.showContactNumber ? '1' : '0',
      'status': 'ACTIVE',
    });
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addPostUrl,
        headers: _headersWithToken(),
        input: data);

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        UiHelper.showToast(response.body['message']?.toString() ?? '');
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> editPost(
      EditPostRequestModel input) async {
    var data = dio.FormData.fromMap({
      'user_id': input.userId,
      'id': input.postId,
      'name': input.productName,
      for (int i = 0; i < input.imagesPath.length; i++)
        'images[$i]': await dio.MultipartFile.fromFile(input.imagesPath[i]),
      'quantity': input.availableQuantity,
      'category_id': input.categoryId,
      'description': input.description,
      'contact_name': input.contactName,
      'contact_email': input.contactEmail,
      'contact_number': input.contactNumber,
      'view_contact': input.showContactNumber ? '1' : '0',
      'city_id': input.cityId,
      'status': input.status,
    });

    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addPostUrl,
        headers: _headersWithToken(),
        input: data);

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        UiHelper.showToast(response.body['message']?.toString() ?? '');
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> addToWishlist(
      AddWishlistRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addToWishlistUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deleteMyPost(DeletePostRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deletePostUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deletePostImage(
      DeletePostImageRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deletePostUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> editProfile(
      EditProfileRequestModel input) async {
    var data = dio.FormData.fromMap({
      'user_id': input.userId,
      'name': input.name,
      'mobile': input.mobile,
      'city_id': input.cityId,
      if (input.profileImagePath.isNotEmpty)
        'image': await dio.MultipartFile.fromFile(input.profileImagePath),
    });

    final response = await DioHelper.postHttpMethod(
        url: AppConstants.editProfileUrl,
        headers: _headersWithToken(),
        input: data);

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        UiHelper.showToast(response.body['message']?.toString() ?? '');
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> logout() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.logoutUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deleteUserAccount() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteAccountUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<dynamic, dynamic>> searchHistory() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.searchHistoryUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<dynamic, dynamic>> clearHistory() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.searchHistoryUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id, 'clear_all': '1'});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<dynamic, dynamic>> getHelpAndSupport() async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.helpAndSupportUrl,
        headers: _headersWithToken(),
        input: {});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['data'] ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<FaqModel>> getFaqList() async {
    final user = StorageHelper.getUserDetail();
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.faqUrl,
        headers: _headersWithToken(),
        input: {'user_id': user.id});

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final faq in response.body['data'] ?? []) FaqModel.fromJson(faq)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<ChatModel>> getChatList(ChatListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.chatListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final chat in response.body['data'] ?? [])
            ChatModel.fromJson(chat, input.userId)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<Map<String, dynamic>> addLikeToChat(
      LikeChatRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addLikeUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body ?? {};
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> addChat(AddChatRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addChatUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deleteChat(DeleteChatRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteChatUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<List<CommentModel>> getComments(
      CommentListRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.commentListUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return [
          for (final comment in response.body['data'] ?? [])
            CommentModel.fromJson(comment, input.userId)
        ];
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> addComment(AddCommentRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.addCommentUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> deleteComment(DeleteCommentRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.deleteCommentUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }

  static Future<String> reportChat(ReportChatRequestModel input) async {
    final response = await DioHelper.postHttpMethod(
        url: AppConstants.reportChatUrl,
        headers: _headersWithToken(),
        input: input.toJson());

    if (response.success) {
      if (response.body['status']?.toString() == '1') {
        return response.body['message']?.toString() ?? '';
      } else if (response.body['status']?.toString() == '5') {
        AuthHelper.logoutUser();
        throw Exception(response.body['message']?.toString() ?? '');
      } else {
        throw Exception(response.body['message']?.toString() ?? '');
      }
    } else {
      throw Exception(response.error);
    }
  }
}
