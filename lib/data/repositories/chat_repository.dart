import '../models/chat_model.dart';
import '../providers/remote/chat_provider.dart';

class ChatRepository {
  final ChatProvider _chatProvider;

  ChatRepository(this._chatProvider);

  Future<List<ChatHistoryItem>> getChatHistory(String userId) async {
    final data = await _chatProvider.getChatHistory(userId);
    return data
        .map((json) => ChatHistoryItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ChatResponse> sendMessage({
    required String userId,
    required String message,
  }) async {
    final data = await _chatProvider.sendMessage(userId: userId, message: message);
    return ChatResponse.fromJson(data);
  }
}
