import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';

class MedicineView extends GetView<MedicineController> {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Obat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.slots.length} Slot Obat',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap slot untuk mengganti nama obat',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: controller.slots.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final slot = controller.slots[index];
                          return Obx(
                            () => _buildSlotItem(context, index, slot),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotItem(BuildContext context, int index, MedicineSlot slot) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => controller.editSlot(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: slot.isEmpty
                          ? Colors.grey[100]
                          : primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      slot.isEmpty ? Icons.add_rounded : Icons.medical_services,
                      color: slot.isEmpty ? Colors.grey[400] : primary,
                    ),
                  ),
                  if (slot.isFilled.value)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Slot ${slot.label}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: slot.isFilled.value
                                ? Colors.green.withAlpha(30)
                                : Colors.grey.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            slot.isEmpty
                                ? 'Kosong'
                                : (slot.isFilled.value
                                    ? 'Ada Stok'
                                    : 'Stok Habis'),
                            style: TextStyle(
                              fontSize: 10,
                              color: slot.isFilled.value
                                  ? Colors.green[700]
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot.isEmpty ? 'Belum diisi' : slot.name.value,
                      style: TextStyle(
                        color: slot.isEmpty ? Colors.grey[500] : null,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
