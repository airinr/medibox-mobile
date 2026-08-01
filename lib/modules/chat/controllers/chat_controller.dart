import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/remote/chat_provider.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({required this.text, required this.isMe, DateTime? time})
    : time = time ?? DateTime.now();
}

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final messageController = TextEditingController();
  final isTyping = false.obs;
  late final ChatRepository _chatRepository;

  @override
  void onInit() {
    super.onInit();
    _chatRepository = ChatRepository(ChatProvider());
    messages.add(
      ChatMessage(
        text:
            'Halo saya Medibot! Ceritakan keluhan anda dan saya akan memberikan rekomendasi obat berdasarkan obat yang tersedia di Medibox anda',
        isMe: false,
      ),
    );
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) return;

    try {
      final history = await _chatRepository.getChatHistory(userId);
      for (final item in history) {
        messages.add(ChatMessage(text: item.userMessage, isMe: true));
        messages.add(ChatMessage(text: item.botResponse, isMe: false));
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    messages.add(ChatMessage(text: text, isMe: true));

    final userId = GetStorage().read<String>('user_id');
    if (userId == null || userId.isEmpty) {
      messages.add(
        ChatMessage(text: 'Silakan login terlebih dahulu', isMe: false),
      );
      return;
    }

    isTyping.value = true;
    try {
      final response = await _chatRepository.sendMessage(
        userId: userId,
        message: text,
      );
      messages.add(ChatMessage(text: response.response, isMe: false));
    } catch (_) {
      messages.add(
        ChatMessage(
          text: 'Maaf, terjadi kesalahan. Coba lagi nanti.',
          isMe: false,
        ),
      );
    } finally {
      isTyping.value = false;
    }
  }
}
