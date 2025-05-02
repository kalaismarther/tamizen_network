import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/faq/faq_model.dart';

class FaqController extends GetxController {
  @override
  void onInit() {
    Future.wait([getContactDetails(), getFaq()]);
    super.onInit();
  }

  var contactDetailLoading = false.obs;
  var emailAddress = ''.obs;
  var whatsappNo = ''.obs;
  var contactDetailError = Rxn<String>();

  var faqLoading = false.obs;

  var faqList = <FaqModel>[].obs;

  var faqError = Rxn<String>();

  Future<void> getContactDetails() async {
    try {
      contactDetailLoading.value = true;
      contactDetailError.value = null;
      final result = await ApiServices.getHelpAndSupport();

      emailAddress.value = result['contact_email'];
      whatsappNo.value = result['contact_mobile'];
    } catch (e) {
      contactDetailError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      contactDetailLoading.value = false;
    }
  }

  Future<void> getFaq() async {
    try {
      faqLoading.value = true;
      contactDetailError.value = null;
      final result = await ApiServices.getFaqList();

      faqList.value = result;
    } catch (e) {
      faqError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      faqLoading.value = false;
    }
  }
}
