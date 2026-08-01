import 'package:get/get.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/splash/controllers/splash_controller.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/device/controllers/device_controller.dart';
import '../../modules/device/views/device_view.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/medicine/controllers/medicine_controller.dart';
import '../../modules/chat/controllers/chat_controller.dart';
import '../../modules/profile/controllers/profile_controller.dart';
import '../../modules/main/controllers/main_controller.dart';
import '../../modules/main/views/main_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.device,
      page: () => const DeviceView(),
      binding: BindingsBuilder(() {
        Get.put(DeviceController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        Get.put(MainController());
        Get.put(DashboardController());
        Get.put(MedicineController());
        Get.put(ChatController());
        Get.put(ProfileController());
      }),
    ),
  ];
}
