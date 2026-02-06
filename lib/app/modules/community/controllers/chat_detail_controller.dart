import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/services/auth_service.dart';

class ChatDetailController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  // Lazy initialization of AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

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
  final isSending = false.obs;

  // Get current user ID
  String? get myUserId {
    final user = _authService?.currentUser;
    return user?.id.toString();
  }

  // Get current user name
  String get myUserName {
    final user = _authService?.currentUser;
    return user?.displayName ?? 'Me';
  }

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

  /// Load messages from API
  Future<void> _loadMessages() async {
    if (myUserId == null) return;

    try {
      isLoading.value = true;
      final conversationId = int.tryParse(chatId);
      if (conversationId == null) return;

      final messageList = await _chatService.getMessages(
        conversationId,
        myUserId: myUserId,
      );

      // API returns newest first, reverse so newest is at bottom
      final reversedList = messageList.reversed.toList();

      messages.value = reversedList;
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }

    _scrollToBottom();
  }

  /// Send message via API
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || myUserId == null) return;

    // Clear input first
    messageController.clear();

    // Optimistically add message to UI
    final tempMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      senderId: myUserId!,
      senderName: myUserName,
      timestamp: DateTime.now(),
      isMe: true,
    );

    messages.add(tempMessage);
    _scrollToBottom();

    // Send to API
    try {
      isSending.value = true;
      final conversationId = int.tryParse(chatId);
      if (conversationId == null) return;

      final sentMessage = await _chatService.sendMessage(
        conversationId: conversationId,
        message: text,
        myUserId: myUserId!,
      );

      if (sentMessage != null) {
        // Remove temp message and add the real one
        messages.remove(tempMessage);
        messages.add(sentMessage);
      } else {
        // API returned null, remove temp message
        messages.remove(tempMessage);
        Get.snackbar('Error', 'Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
      // Remove temp message on error
      messages.remove(tempMessage);
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  /// Refresh messages (pull-to-refresh)
  Future<void> refresh() async {
    await _loadMessages();
  }

  void _scrollToBottom() {
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
