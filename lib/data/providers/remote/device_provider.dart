import 'package:get/get.dart';
import '../../../app/core/constants/api_constants.dart';
import '../../../app/core/network/dio_client.dart';

class DeviceProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<Map<String, dynamic>?> getDeviceByUserId(String userId) async {
    final response = await _dioClient.get(ApiConstants.getDeviceByUserId(userId));
    final data = response.data as Map<String, dynamic>;
    return data['device'] as Map<String, dynamic>?;
  }

  Future<void> deleteDevice(String macAddress) async {
    await _dioClient.delete(ApiConstants.deleteDevice(macAddress));
  }

  Future<Map<String, dynamic>> registerDevice({
    required String userId,
    required String macAddress,
    String? deviceName,
  }) async {
    final data = <String, dynamic>{
      'user_id': userId,
      'mac_address': macAddress,
    };
    if (deviceName != null && deviceName.isNotEmpty) {
      data['device_name'] = deviceName;
    }
    final response = await _dioClient.post(ApiConstants.device, data: data);
    return response.data as Map<String, dynamic>;
  }
}
