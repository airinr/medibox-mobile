import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/remote/device_provider.dart';
import '../../../data/repositories/device_repository.dart';

class DeviceController extends GetxController {
  final macController = TextEditingController();
  final nameController = TextEditingController();
  final isSaving = false.obs;
  late final DeviceRepository _deviceRepository;

  @override
  void onInit() {
    super.onInit();
    _deviceRepository = DeviceRepository(DeviceProvider());
  }

  @override
  void onClose() {
    macController.dispose();
    nameController.dispose();
    super.onClose();
  }

  String formatMacAddress(String input) {
    String clean = input.replaceAll(' ', '').replaceAll(':', '').toUpperCase();
    if (clean.length == 8) {
      clean = '240AC4$clean';
    }
    List<String> parts = [];
    for (int i = 0; i < clean.length; i += 2) {
      if (i + 2 <= clean.length) {
        parts.add(clean.substring(i, i + 2));
      }
    }
    return parts.join(':');
  }

  Future<void> submit() async {
    final raw = macController.text.trim();
    final mac = formatMacAddress(raw);
    final name = nameController.text.trim();

    if (mac.length < 17) {
      Get.snackbar('Error', 'MAC address tidak valid');
      return;
    }

    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'Sesi tidak ditemukan, silakan login ulang');
      return;
    }

    isSaving.value = true;
    try {
      await _deviceRepository.registerDevice(
        userId: userId,
        macAddress: mac,
        deviceName: name.isNotEmpty ? name : null,
      );
      if (Get.arguments == 'profile') {
        Get.back();
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat mendaftarkan perangkat. Coba lagi.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  void skip() {
    if (Get.arguments == 'profile') {
      Get.back();
    } else {
      Get.offAllNamed('/home');
    }
  }
}
