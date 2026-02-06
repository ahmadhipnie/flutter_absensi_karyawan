import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class NewChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  // Lazy initialization of AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

  final searchController = TextEditingController();
  final members = <UserModel>[].obs;
  final filteredMembers = <UserModel>[].obs;
  final isLoading = false.obs;
  final isCreatingChat = false.obs;
  final searchQuery = ''.obs;

  // Get current user ID to exclude from member list
  int? get currentUserId {
    final user = _authService?.currentUser;
    return user?.id;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  /// Fetch members from API
  Future<void> fetchMembers() async {
    try {
      isLoading.value = true;

      final result = await _chatService.getUsers();

      // Filter out current user from the list
      final filtered = result.where((m) => m.id != currentUserId).toList();

      members.assignAll(filtered);
      filteredMembers.assignAll(filtered);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load members');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      final query = value.toLowerCase();
      final displayName = value.toLowerCase();
      filteredMembers.assignAll(members.where((m) {
        return (m.username?.toLowerCase().contains(query) ?? false) ||
               m.email.toLowerCase().contains(query);
      }).toList());
    }
  }

  /// Start a personal chat with a member
  /// Creates a conversation via API, then navigates to chat detail
  Future<void> startPersonalChat(UserModel member) async {
    try {
      isCreatingChat.value = true;

      // Create conversation via API
      // Title is automatically set to member's name
      final response = await _chatService.createPrivateConversation(
        userId: member.id,
        title: member.displayName,
      );

      if (response != null && response.data != null) {
        final conversation = response.data!;

        // Navigate to Chat Detail with conversation data
        Get.toNamed(
          Routes.CHAT_DETAIL,
          arguments: {
            'chatId': conversation.id.toString(),
            'name': conversation.displayName,
            'type': conversation.type,
            'avatarUrl': member.avatarUrl,
            'conversation': conversation,
          },
        );
      } else {
        Get.snackbar('Error', 'Failed to create conversation');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreatingChat.value = false;
    }
  }

  void createNewGroup() {
    Get.snackbar('Coming Soon', 'Group chat creation is not implemented yet.');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
