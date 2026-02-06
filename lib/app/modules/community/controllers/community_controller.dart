import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/models/conversation_model.dart';
import '../../../routes/app_pages.dart';

class CommunityController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final filters = ['All', 'Department', 'Personal'];

  // Conversation list from API
  final conversations = <ConversationModel>[].obs;

  // Polling timer
  Timer? _pollTimer;

  // Polling interval (30 seconds)
  static const Duration _pollInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
    _startPolling();
  }

  @override
  void onClose() {
    _stopPolling();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Start smart polling
  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      fetchConversations(silent: true);
    });
  }

  /// Stop smart polling
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Pause polling (e.g., when user opens chat detail)
  void pausePolling() {
    _stopPolling();
  }

  /// Resume polling (e.g., when user back from chat detail)
  void resumePolling() {
    _startPolling();
  }

  /// Refresh conversations (manual refresh via pull-to-refresh or button)
  Future<void> refresh() async {
    await fetchConversations();
  }

  /// Fetch conversations from API
  Future<void> fetchConversations({bool silent = false}) async {
    try {
      if (!silent) isLoading.value = true;

      final result = await _chatService.getConversations();
      conversations.assignAll(result);
    } catch (e) {
      if (!silent) {
        Get.snackbar('Error', 'Failed to load conversations');
      }
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  /// Get filtered chats based on selected filter and search query
  List<ConversationModel> get filteredChats {
    final Iterable<ConversationModel> result = conversations.where((chat) {
      // Filter by type (map UI filter to API type)
      // Personal → private, Department → group
      if (selectedFilter.value != 'All') {
        final filterType = selectedFilter.value.toLowerCase();
        final chatType = chat.type.toLowerCase();

        // Map Personal → private, Department → group
        if (filterType == 'personal' && chatType != 'private') {
          return false;
        }
        if (filterType == 'department' && chatType != 'group') {
          return false;
        }
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final name = chat.displayName.toLowerCase();
        return name.contains(query);
      }

      return true;
    });

    return result.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Capitalize first letter of string
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Update search query
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  /// Open chat (pause polling while in chat detail)
  void openChat(ConversationModel conversation) {
    pausePolling(); // Stop polling saat buka chat
    Get.toNamed(
      Routes.CHAT_DETAIL,
      arguments: {
        'chatId': conversation.id.toString(),
        'name': conversation.displayName,
        'type': conversation.type,
        'subtitle': conversation.subtitle,
        'conversation': conversation,
      },
    );
  }

  /// Resume polling when back from chat detail
  void onResume() {
    resumePolling();
  }

  /// Create new chat
  void createNewChat() {
    Get.toNamed(Routes.NEW_CHAT);
  }
}
