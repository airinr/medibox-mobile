import '../models/slot_model.dart';
import '../providers/remote/slot_provider.dart';

class SlotRepository {
  final SlotProvider _slotProvider;

  SlotRepository(this._slotProvider);

  Future<List<SlotModel>> getSlots(String userId) async {
    final data = await _slotProvider.getSlots(userId);
    return data
        .map((json) => SlotModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<SlotModel> addSlot(
    String userId,
    String slotLabel,
    String medicineName,
  ) async {
    final data = await _slotProvider.addSlot(userId, slotLabel, medicineName);
    return SlotModel.fromJson(data);
  }

  Future<void> updateSlotConfig(String slotId, String medicineName) async {
    await _slotProvider.updateSlotConfig(slotId, medicineName);
  }
}
