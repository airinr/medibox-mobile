import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context, primary),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildStatsRow(context, primary),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Slot Obat', 'Tap untuk mengatur obat'),
                      const SizedBox(height: 12),
                      ...List.generate(
                        controller.slots.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Obx(() =>
                              _buildSlotCard(context, i, controller.slots[i])),
                        ),
                      ),
                      _buildChatSuggestion(context, primary),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, Color primary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 20,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medical_services, color: Colors.white, size: 28),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: controller.logout,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Selamat Datang',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Medibox',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Berikut merupakan status obat anda',
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, Color primary) {
    final filled = controller.slots.where((s) => s.isFilled.value).length;
    final empty = controller.slots.length - filled;
    final total = controller.slots.length;
    final hasMedicine =
        controller.slots.any((s) => s.name.value.isNotEmpty);

    String filledLabel;
    String emptyLabel;
    if (hasMedicine) {
      filledLabel = 'Ada Stok';
      emptyLabel = 'Stok Habis';
    } else {
      filledLabel = 'Kosong';
      emptyLabel = 'Kosong';
    }

    return Transform.translate(
      offset: const Offset(0, -20),
      child: Row(
        children: [
          _buildStatCard(
              Icons.check_circle, filledLabel, '$filled', Colors.green),
          const SizedBox(width: 12),
          _buildStatCard(
              Icons.cancel, emptyLabel, '$empty', Colors.orange),
          const SizedBox(width: 12),
          _buildStatCard(Icons.medical_services, 'Total', '$total', primary),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
        Icon(Icons.refresh, color: Colors.grey[400], size: 22),
      ],
    );
  }

  Widget _buildSlotCard(BuildContext context, int index, DashboardSlot slot) {
    final primary = Theme.of(context).colorScheme.primary;
    final isFilled = slot.isFilled.value;
    final hasName = !slot.isEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => controller.editSlot(index),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: isFilled ? Colors.green : Colors.grey[300]!,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasName ? primary.withAlpha(25) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  hasName ? Icons.medication : Icons.add_rounded,
                  color: hasName ? primary : Colors.grey[400],
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
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
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isFilled
                                ? Colors.green.withAlpha(25)
                                : Colors.grey.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFilled ? Icons.circle : Icons.circle_outlined,
                                size: 6,
                                color: isFilled
                                    ? Colors.green[700]
                                    : Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                hasName
                                    ? (isFilled ? 'Ada Stok' : 'Stok Habis')
                                    : 'Kosong',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isFilled
                                      ? Colors.green[700]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasName ? slot.name.value : 'Belum ada obat',
                      style: TextStyle(
                        color: hasName ? Colors.black87 : Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[300], size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatSuggestion(BuildContext context, Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withAlpha(25), primary.withAlpha(10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.chat_outlined, color: primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Butuh saran obat?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jelaskan gejala yang Anda alami melalui fitur Chat',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Fitur Chat',
              style: TextStyle(
                color: primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
