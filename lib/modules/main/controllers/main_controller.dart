import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 2) {
      Get.find<ProfileController>().fetchData();
    }
  }
}
