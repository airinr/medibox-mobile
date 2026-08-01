import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/remote/slot_provider.dart';
import '../../../data/repositories/slot_repository.dart';

class DashboardSlot {
  final String label;
  final RxString name;
  final RxBool isFilled;
  final RxString slotId;

  DashboardSlot({
    required this.label,
    String name = '',
    bool isFilled = false,
    String slotId = '',
  }) : name = name.obs,
       isFilled = isFilled.obs,
       slotId = slotId.obs;

  bool get isEmpty => name.value.isEmpty;
  bool get hasSlotId => slotId.value.isNotEmpty;
}

class DashboardController extends GetxController {
  final slots = <DashboardSlot>[];
  final isLoading = true.obs;
  final isSaving = false.obs;
  late final SlotRepository _slotRepository;
  Timer? _pollTimer;

  static const List<String> labels = ['A', 'B', 'C', 'D', 'E'];

  @override
  void onInit() {
    super.onInit();
    _slotRepository = SlotRepository(SlotProvider());
    _initSlots();
    _fetchData();
    _startPolling();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchData(silent: true),
    );
  }

  void _initSlots() {
    for (final label in labels) {
      slots.add(DashboardSlot(label: label));
    }
  }

  Future<void> _fetchData({bool silent = false}) async {
    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      final data = await _slotRepository.getSlots(userId);
      for (final slotData in data) {
        final index = labels.indexOf(slotData.slotLabel);
        if (index >= 0) {
          slots[index].slotId.value = slotData.id;
          slots[index].name.value = slotData.medicineName ?? '';
          slots[index].isFilled.value = slotData.isFilled;
        }
      }
    } catch (_) {
      // API gagal, slot tetap kosong
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  void editSlot(int index) {
    final slot = slots[index];
    final controller = TextEditingController(text: slot.name.value);

    Get.dialog(
      AlertDialog(
        title: Text('Slot ${slot.label}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nama Obat',
            hintText: 'Masukkan nama obat',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          Obx(
            () => ElevatedButton(
              onPressed: isSaving.value
                  ? null
                  : () => _saveSlotName(index, controller),
              child: isSaving.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSlotName(
    int index,
    TextEditingController controller,
  ) async {
    final slot = slots[index];
    final name = controller.text.trim();
    isSaving.value = true;

    if (name.isEmpty) {
      isSaving.value = false;
      Get.back();
      return;
    }

    try {
      final userId = GetStorage().read<String>('user_id');
      if (slot.hasSlotId) {
        await _slotRepository.updateSlotConfig(slot.slotId.value, name);
      } else {
        final newSlot =
            await _slotRepository.addSlot(userId!, slot.label, name);
        slot.slotId.value = newSlot.id;
        slot.isFilled.value = newSlot.isFilled;
      }
      slot.name.value = name;
    } catch (_) {
      Get.snackbar('Gagal', 'Tidak dapat menyimpan, coba lagi');
    }

    isSaving.value = false;
    Get.back();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await _fetchData();
  }

  void logout() {
    GetStorage().remove('token');
    GetStorage().remove('user_id');
    Get.offAllNamed('/login');
  }
}
