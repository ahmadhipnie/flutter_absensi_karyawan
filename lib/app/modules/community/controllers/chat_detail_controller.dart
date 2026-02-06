import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  final selectedImage = Rx<File?>(null);
  final isUploadingImage = false.obs;

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

  bool get isGroupChat => chatType == 'group' || chatType == 'Department';

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

  /// Pick image from gallery/camera with built-in compression
  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      // Use image_picker's built-in compression
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,  // Max width 1024px
        maxHeight: 1024, // Max height 1024px
        imageQuality: 70, // Quality 70%
      );

      if (image != null) {
        final file = File(image.path);
        final size = file.lengthSync();
        print('Image size after picker compression: ${size} bytes (${(size / 1024).toStringAsFixed(1)} KB)');

        // Check if still too large (> 5MB)
        if (size > 5 * 1024 * 1024) {
          Get.snackbar(
            'Error',
            'Image too large. Please choose a smaller image.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        selectedImage.value = file;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  /// Clear selected image
  void clearSelectedImage() {
    selectedImage.value = null;
  }

  /// Send message via API
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final hasImage = selectedImage.value != null;

    if (text.isEmpty && !hasImage) return;
    if (myUserId == null) return;

    // Clear input
    messageController.clear();

    // Create temp message for UI
    final tempMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      senderId: myUserId!,
      senderName: myUserName,
      timestamp: DateTime.now(),
      isMe: true,
      image: hasImage ? selectedImage.value!.path : null, // Show local image while uploading
      messageType: hasImage ? 'image' : 'text',
    );

    // Keep local image path for replacement later
    final localImagePath = hasImage ? selectedImage.value!.path : null;

    messages.add(tempMessage);
    _scrollToBottom();

    // Send to API
    try {
      isSending.value = true;
      if (hasImage) {
        isUploadingImage.value = true;
      }

      final conversationId = int.tryParse(chatId);
      if (conversationId == null) return;

      final sentMessage = await _chatService.sendMessage(
        conversationId: conversationId,
        message: text,
        myUserId: myUserId!,
        imagePath: localImagePath,
      );

      // Clear selected image after sending
      if (hasImage) {
        selectedImage.value = null;
        isUploadingImage.value = false;
      }

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
      isUploadingImage.value = false;
    }
  }

  /// Refresh messages (pull-to-refresh)
  Future<void> refresh() async {
    await _loadMessages();
  }

  /// Delete a message (only own messages)
  Future<void> deleteMessage(ChatMessage message) async {
    if (!message.isMe) {
      Get.snackbar('Error', 'You can only delete your own messages');
      return;
    }

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Remove from UI immediately
    messages.remove(message);

    // Call API
    final success = await _chatService.deleteMessage(message.id);

    if (!success) {
      // Failed, add back to list
      messages.add(message);
      Get.snackbar('Error', 'Failed to delete message');
    }
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

  /// Leave conversation
  Future<void> leaveConversation() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Leave Conversation'),
        content: Text('Are you sure you want to leave this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final conversationId = int.tryParse(chatId);
    if (conversationId == null) return;

    final success = await _chatService.leaveConversation(conversationId);

    if (success) {
      // Go back to community list and refresh
      Get.back(result: 'left');
      Get.snackbar('Success', 'Left conversation');
    } else {
      Get.snackbar('Error', 'Failed to leave conversation');
    }
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
