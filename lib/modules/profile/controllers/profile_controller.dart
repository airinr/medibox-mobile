import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/device_model.dart';
import '../../../data/providers/remote/auth_provider.dart';
import '../../../data/providers/remote/device_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/device_repository.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isSaving = false.obs;
  final isLoading = false.obs;
  final isDeleting = false.obs;
  final device = Rx<DeviceData?>(null);

  late final AuthRepository _authRepository;
  late final DeviceRepository _deviceRepository;

  @override
  void onInit() {
    super.onInit();
    _authRepository = AuthRepository(AuthProvider());
    _deviceRepository = DeviceRepository(DeviceProvider());
    _fetchProfile();
    _fetchDeviceByUserId();
  }

  Future<void> _fetchProfile() async {
    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) return;

    isLoading.value = true;
    try {
      final data = await _authRepository.getProfile(userId);
      nameController.text = data.fullName ?? '';
      emailController.text = data.email;
    } catch (_) {
      // gagal fetch profil, form tetap kosong
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    await _fetchProfile();
    await _fetchDeviceByUserId();
  }

  Future<void> _fetchDeviceByUserId() async {
    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) return;

    try {
      final result = await _deviceRepository.getDeviceByUserId(userId);
      device.value = result;
    } catch (_) {}
  }

  Future<void> saveProfile() async {
    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'Sesi tidak ditemukan, silakan login ulang');
      return;
    }

    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty && email.isEmpty && password.isEmpty) {
      Get.snackbar('Info', 'Tidak ada data yang diubah');
      return;
    }

    isSaving.value = true;
    try {
      await _authRepository.updateProfile(
        userId: userId,
        fullName: fullName.isNotEmpty ? fullName : null,
        email: email.isNotEmpty ? email : null,
        password: password.isNotEmpty ? password : null,
      );
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceAll('ApiException: ', ''),
      );
    } finally {
      isSaving.value = false;
    }
  }

  String formatMac(String raw) {
    final clean = raw.replaceAll(' ', '').replaceAll(':', '').toUpperCase();
    final parts = <String>[];
    for (int i = 0; i < clean.length; i += 2) {
      if (i + 2 <= clean.length) parts.add(clean.substring(i, i + 2));
    }
    return parts.join(':');
  }

  Future<void> deleteDevice() async {
    final mac = device.value?.macAddress;
    if (mac == null || mac.isEmpty) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Perangkat'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus perangkat ini?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isDeleting.value = true;
    try {
      await _deviceRepository.deleteDevice(mac);
      device.value = null;
      Get.snackbar('Berhasil', 'Perangkat berhasil dihapus');
    } catch (_) {
      Get.snackbar('Gagal', 'Tidak dapat menghapus perangkat');
    } finally {
      isDeleting.value = false;
    }
  }
}
