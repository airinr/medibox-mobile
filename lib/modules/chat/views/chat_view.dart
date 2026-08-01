import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount:
                    controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (controller.isTyping.value && index == 0) {
                    return _buildTypingIndicator();
                  }
                  final msgIndex = controller.isTyping.value
                      ? index - 1
                      : index;
                  if (msgIndex < 0 || msgIndex >= controller.messages.length) {
                    return const SizedBox.shrink();
                  }
                  final msg = controller
                      .messages[controller.messages.length - 1 - msgIndex];
                  return _buildMessageBubble(msg, context);
                },
              ),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.isMe ? primary : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isMe
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottomRight: msg.isMe
                ? const Radius.circular(4)
                : const Radius.circular(16),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isMe ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.3, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[400]?.withAlpha((value * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Get.theme.colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
