import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_message_model.dart';

class ChatDetailController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Chat info dari arguments
  late final String chatId;
  late final String chatName;
  late final String chatType;
  late final String? subtitle;
  late final String? avatarUrl;

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    _loadMessages();
  }

  void _parseArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    chatId = args['chatId'] ?? '';
    chatName = args['name'] ?? 'Chat';
    chatType = args['type'] ?? 'Personal';
    subtitle = args['subtitle'];
    avatarUrl = args['avatarUrl'];
  }

  bool get isGroupChat => chatType == 'Department';

  void _loadMessages() {
    // Dummy data untuk UI
    if (isGroupChat) {
      messages.value = [
        ChatMessage(
          id: '1',
          text: 'Hello team! Please ensure that all ongoing and upcoming community initiatives are clearly documented, including objectives, timelines, and assigned PICs.',
          senderId: 'me',
          senderName: 'Me',
          timestamp: DateTime.now(),
          isMe: true,
        ),
        ChatMessage(
          id: '2',
          text: 'Noted, thank you.',
          senderId: '2',
          senderName: 'Bambang',
          senderAvatar: null,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isMe: false,
        ),
        ChatMessage(
          id: '3',
          text: 'Please also include measurable outcomes or KPIs where possible, so we can better evaluate the impact of each initiative.',
          senderId: '3',
          senderName: 'Basuki',
          senderAvatar: null,
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isMe: false,
        ),
      ];
    } else {
      messages.value = [
        ChatMessage(
          id: '1',
          text: 'Please share the first update by the end of this week so we can review it together in the next executive meeting.',
          senderId: 'me',
          senderName: 'Me',
          timestamp: DateTime.now(),
          isMe: true,
        ),
        ChatMessage(
          id: '2',
          text: "Will do. We'll make sure the update is ready and shared before the deadline.",
          senderId: '2',
          senderName: 'Basuki',
          senderAvatar: avatarUrl,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isMe: false,
        ),
      ];
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'me',
      senderName: 'Me',
      timestamp: DateTime.now(),
      isMe: true,
    );

    messages.add(newMessage);
    messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void startVideoCall() {
    Get.snackbar('Video Call', 'Starting video call with $chatName...');
  }

  void startVoiceCall() {
    Get.snackbar('Voice Call', 'Starting voice call with $chatName...');
  }

  String get formattedDate {
    return 'Today';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
