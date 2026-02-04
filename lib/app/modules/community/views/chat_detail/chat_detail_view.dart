import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/chat_detail_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_bubble.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(
        chatName: controller.chatName,
        isGroupChat: controller.isGroupChat,
        subtitle: controller.subtitle,
        avatarUrl: controller.avatarUrl,
        onVideoCall: controller.startVideoCall,
        onVoiceCall: controller.startVoiceCall,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingL,
                vertical: AppTheme.paddingS,
              ),
              itemCount: controller.messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _DateDivider(formattedDate: controller.formattedDate);
                }
                final message = controller.messages[index - 1];
                return ChatMessageBubble(
                  message: message,
                  isGroupChat: controller.isGroupChat,
                );
              },
            )),
          ),
          ChatInputField(
            controller: controller.messageController,
            onSend: controller.sendMessage,
            onCameraTap: () {
              // TODO: Open camera
            },
          ),
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.formattedDate});

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingL),
        child: Text(
          formattedDate,
          style: const TextStyle(
            color: AppTheme.gray500,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
