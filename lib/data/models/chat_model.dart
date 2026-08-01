class ChatResponse {
  final String response;

  ChatResponse({required this.response});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(response: json['response'] as String);
  }
}

class ChatHistoryItem {
  final String userMessage;
  final String botResponse;

  ChatHistoryItem({
    required this.userMessage,
    required this.botResponse,
  });

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) {
    return ChatHistoryItem(
      userMessage: json['user_message'] as String,
      botResponse: json['bot_response'] as String,
    );
  }
}
