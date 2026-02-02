import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  final filters = ['All', 'Department', 'Personal'];

  // Sample chat data
  final chats = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Executive Management',
      'message':
          'Bambang: Hi team, quick alignment for the Community division.',
      'timestamp': '2:30 PM',
      'unreadCount': 1,
      'isRead': false,
      'isSentByMe': false,
      'avatarText': 'S',
      'avatarColor': 0xFF0046BE,
      'type': 'Department',
    },
    {
      'id': '2',
      'name': 'Bambang',
      'message': 'quasi architect eatae vitae dicta sunt explid...',
      'timestamp': '2:30 PM',
      'unreadCount': 2,
      'isRead': false,
      'isSentByMe': false,
      'avatarImage':
          'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
      'type': 'Personal',
    },
    {
      'id': '3',
      'name': 'Xianying',
      'message': 'quasi architeo beatae vitae dicta sunt e...',
      'timestamp': '2:30 PM',
      'unreadCount': 0,
      'isRead': true,
      'isSentByMe': true,
      'avatarImage':
          'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
      'type': 'Personal',
    },
    {
      'id': '4',
      'name': 'Basuki',
      'message': 'quasi architecto beatae vitae dicta snet...',
      'timestamp': '2:30 PM',
      'unreadCount': 0,
      'isRead': false,
      'isSentByMe': true,
      'avatarImage':
          'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
      'type': 'Personal',
    },
  ].obs;

  /// Get filtered chats based on selected filter and search query
  List<Map<String, dynamic>> get filteredChats {
    var result = chats.where((chat) {
      // Filter by type
      if (selectedFilter.value != 'All' &&
          chat['type'] != selectedFilter.value) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final name = (chat['name'] as String).toLowerCase();
        final message = (chat['message'] as String).toLowerCase();
        return name.contains(query) || message.contains(query);
      }

      return true;
    }).toList();

    return result;
  }

  /// Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Update search query
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  /// Open chat
  void openChat(String chatId) {
    // TODO: Navigate to chat detail
    Get.snackbar('Chat', 'Opening chat: $chatId');
  }

  /// Create new chat
  void createNewChat() {
    // TODO: Navigate to create chat
    Get.snackbar('New Chat', 'Create new chat');
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
