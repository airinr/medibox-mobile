import 'package:get/get.dart';
import '../../../app/core/constants/api_constants.dart';
import '../../../app/core/network/dio_client.dart';

class SlotProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<List<dynamic>> getSlots(String userId) async {
    final response = await _dioClient.get('${ApiConstants.slots}/$userId');
    return (response.data as Map<String, dynamic>)['slots'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> addSlot(
    String userId,
    String slotLabel,
    String medicineName,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.addSlot(userId),
      data: {'slot_label': slotLabel, 'medicine_name': medicineName},
    );
    return (response.data as Map<String, dynamic>)['slot']
        as Map<String, dynamic>;
  }

  Future<void> updateSlotConfig(String slotId, String medicineName) async {
    await _dioClient.put(
      ApiConstants.slotConfig(slotId),
      data: {'medicine_name': medicineName},
    );
  }
}
