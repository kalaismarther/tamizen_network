import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/response_status.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/forgot_password_request_model.dart';
import 'package:product_sharing/view/screens/auth/verification_screen.dart';

class ForgotPasswordController extends GetxController {
  var email = ''.obs;

  void proceed() async {
    try {
      if (email.value.isEmpty) {
        UiHelper.showToast('Please enter email address');
      } else if (!ValidationHelper.emailRegex.hasMatch(email.value)) {
        UiHelper.showToast('Invalid email address');
      } else {
        UiHelper.unfocus();
        UiHelper.showLoadingDialog();
        final input = ForgotPasswordRequestModel(email: email.value.trim());

        final result = await ApiServices.forgotPassword(input);

        if (result == ResponseStatus.otpNotVerified) {
          UiHelper.closeLoadingDialog();
          Get.off(() => const VerificationScreen(type: 'forgot_password'));
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
