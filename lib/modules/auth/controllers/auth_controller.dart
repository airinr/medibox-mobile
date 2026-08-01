import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/remote/auth_provider.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  late final AuthRepository _authRepository;

  @override
  void onInit() {
    super.onInit();
    _authRepository = AuthRepository(AuthProvider());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      _saveSession(response);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString().replaceAll('ApiException: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName.isNotEmpty ? fullName : null,
      );
      _saveSession(response);
      Get.offAllNamed('/device');
    } catch (e) {
      Get.snackbar(
        'Registrasi Gagal',
        e.toString().replaceAll('ApiException: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _saveSession(AuthResponse response) {
    final box = GetStorage();
    box.write('token', response.accessToken);
    box.write('user_id', response.userId);
  }

  void logout() {
    final box = GetStorage();
    box.remove('token');
    box.remove('user_id');
    Get.offAllNamed('/login');
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
