import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/community_controller.dart';
import 'widgets/chat_list_item.dart';
import 'widgets/community_filter_chips.dart';
import 'widgets/community_search_bar.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const CommunityFilterChips(),
            const CommunitySearchBar(),
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Text(
        'Community',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      final chats = controller.filteredChats;

      if (chats.isEmpty) {
        return const Center(
          child: Text(
            'No conversations found',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
          ),
        );
      }

      return ListView.separated(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: chats.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          return ChatListItem(chat: chats[index]);
        },
      );
    });
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: controller.createNewChat,
      backgroundColor: const Color(0xFF0046BE),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
