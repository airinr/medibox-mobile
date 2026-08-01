import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, primary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  _buildSectionTitle('Informasi Profil'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password Baru (opsional)',
                      hintText: 'Kosongkan jika tidak ingin mengubah',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton(
                        onPressed:
                            controller.isSaving.value ? null : controller.saveProfile,
                        child: controller.isSaving.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Simpan Profil', style: TextStyle(fontSize: 16)),
                      )),
                  const SizedBox(height: 32),
                  const Divider(),
                  Obx(() {
                    if (controller.device.value == null) {
                      return _buildAddDeviceCard(context, primary);
                    }
                    return _buildDeviceSection(context, primary);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 60,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withAlpha(180), primary.withAlpha(100)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withAlpha(30),
            child: const Icon(Icons.person, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'Profil Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    );
  }

  Widget _buildAddDeviceCard(BuildContext context, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Perangkat Terhubung'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withAlpha(30)),
          ),
          child: Column(
            children: [
              Icon(Icons.devices_other_outlined, color: primary.withAlpha(100), size: 48),
              const SizedBox(height: 12),
              Text(
                'Belum ada perangkat terhubung',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/device', arguments: 'profile'),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tambahkan Perangkat'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceSection(
    BuildContext context,
    Color primary,
  ) {
    final displayName = controller.device.value?.deviceName ?? '';
    final displayMac =
        controller.formatMac(controller.device.value?.macAddress ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Perangkat Terhubung'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.devices, color: primary, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    displayName.isNotEmpty ? displayName : 'Perangkat ESP32',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'MAC: $displayMac',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => OutlinedButton.icon(
              onPressed:
                  controller.isDeleting.value ? null : controller.deleteDevice,
              icon: controller.isDeleting.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red),
              label: Text(
                controller.isDeleting.value ? 'Menghapus...' : 'Hapus Perangkat',
                style: const TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            )),
      ],
    );
  }
}
