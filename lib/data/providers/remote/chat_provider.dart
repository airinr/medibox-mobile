import 'package:get/get.dart';
import '../../../app/core/constants/api_constants.dart';
import '../../../app/core/network/dio_client.dart';

class ChatProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<List<dynamic>> getChatHistory(String userId) async {
    final response = await _dioClient.get(ApiConstants.chatHistory(userId));
    return (response.data as Map<String, dynamic>)['history'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.chat,
      data: {
        'user_id': userId,
        'message': message,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
