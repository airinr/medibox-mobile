import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final box = GetStorage();
    final token = box.read<String>('token');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
