import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/device_controller.dart';

class DeviceView extends GetView<DeviceController> {
  const DeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Icon(
                Icons.devices_other_outlined,
                size: 80,
                color: primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Daftarkan Perangkat',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan MAC address ESP32 Anda\nuntuk menghubungkan ke Medibox',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withAlpha(40)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'MAC address didapatkan dari alat. Nyalakan alat terlebih dahulu, lalu masukkan MAC address yang tertera di layar LCD alat.',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.macController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'MAC Address',
                  hintText: 'AA:BB:CC:DD:EE:FF',
                  prefixIcon: Icon(Icons.wifi_tethering),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Perangkat (opsional)',
                  hintText: 'MediBox Kamar Tidur',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed:
                        controller.isSaving.value ? null : controller.submit,
                    child: controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Simpan', style: TextStyle(fontSize: 16)),
                  )),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.skip,
                child: Text(
                  'Lewati',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
