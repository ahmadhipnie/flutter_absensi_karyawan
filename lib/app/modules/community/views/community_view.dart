import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/community_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../common/widgets/filter_chips.dart';
import '../../../common/widgets/app_fab.dart';
import 'widgets/chat_list_item.dart';
import 'widgets/community_search_bar.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            AppFilterChips(
              selectedFilter: controller.selectedFilter,
              filters: controller.filters,
              onFilterSelected: controller.selectFilter,
            ),
            const CommunitySearchBar(),
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
      floatingActionButton: AppFAB(
        heroTag: 'community_fab',
        onPressed: controller.createNewChat,
      ),
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
}
