import 'package:get_storage/get_storage.dart';
import 'package:product_sharing/model/user_model.dart';

class StorageHelper {
  static final storage = GetStorage();

  static Future<void> write(String keyName, dynamic value) async {
    await storage.write(keyName, value);
  }

  static read(String keyName) {
    return storage.read(keyName);
  }

  static Future<void> deleteAll() async {
    await storage.erase();
  }

  static UserModel getUserDetail() {
    final userDetail = read('user');

    return UserModel.fromJson(userDetail);
  }
}
