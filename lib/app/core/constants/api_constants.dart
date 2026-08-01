class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://medibox.rutherweb.my.id/';

  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sensorUpdate = '/sensor/update';
  static const String slots = '/slots';

  static String addSlot(String userId) => '$slots/$userId';
  static String slotConfig(String slotId) => '$slots/$slotId/config';
  static String profile(String userId) => '/auth/profile/$userId';
  static String updateProfile(String userId) => '/auth/profile/$userId';
  static const String chat = '/chat';
  static String chatHistory(String userId) => '/chat/history/$userId';
  static const String device = '/device';
  static String getDeviceByUserId(String userId) => '/device/$userId';
  static String deleteDevice(String mac) => '/device/$mac';
}
