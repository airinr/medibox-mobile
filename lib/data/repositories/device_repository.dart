import '../models/device_model.dart';
import '../providers/remote/device_provider.dart';

class DeviceRepository {
  final DeviceProvider _deviceProvider;

  DeviceRepository(this._deviceProvider);

  Future<DeviceData?> getDeviceByUserId(String userId) async {
    final data = await _deviceProvider.getDeviceByUserId(userId);
    if (data == null) return null;
    return DeviceData.fromJson(data);
  }

  Future<void> deleteDevice(String macAddress) async {
    await _deviceProvider.deleteDevice(macAddress);
  }

  Future<DeviceResponse> registerDevice({
    required String userId,
    required String macAddress,
    String? deviceName,
  }) async {
    final data = await _deviceProvider.registerDevice(
      userId: userId,
      macAddress: macAddress,
      deviceName: deviceName,
    );
    return DeviceResponse.fromJson(data);
  }
}
