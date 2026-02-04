import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

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
    final Iterable<Map<String, dynamic>> result = chats.where((chat) {
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
    });

    return result.toList();
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
  void openChat(Map<String, dynamic> chat) {
    final isDept = chat['type'] == 'Department';
    Get.toNamed(
      '/chat-detail',
      arguments: {
        'chatId': chat['id'],
        'name': chat['name'],
        'type': chat['type'],
        'subtitle': isDept ? '10 Members' : null,
        'avatarUrl': chat['avatarImage'],
      },
    );
  }

  /// Create new chat
  void createNewChat() {
    Get.toNamed(Routes.NEW_CHAT);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
