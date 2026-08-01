class DeviceResponse {
  final String status;
  final DeviceData? device;

  DeviceResponse({required this.status, this.device});

  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      status: json['status'] as String,
      device: json['device'] != null
          ? DeviceData.fromJson(json['device'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DeviceData {
  final String id;
  final String macAddress;
  final String? deviceName;
  final String createdAt;

  DeviceData({
    required this.id,
    required this.macAddress,
    this.deviceName,
    required this.createdAt,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['id'] as String? ?? json['user_id'] as String? ?? '',
      macAddress: json['mac_address'] as String,
      deviceName: json['device_name'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
