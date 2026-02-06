import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/new_chat_controller.dart';
import 'widgets/empty_members_state.dart';
import 'widgets/member_list_item.dart';
import 'widgets/simple_app_bar.dart';

class NewChatView extends GetView<NewChatController> {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SimpleAppBar(title: 'Members'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredMembers.isEmpty) {
          return const EmptyMembersState();
        }

        return Column(
          children: [
            // New Group button (only for supervisor)
            if (controller.isSupervisor)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingM,
                  vertical: AppTheme.paddingS,
                ),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.showCreateGroupModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003AE6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.group_add, size: 20),
                  label: const Text(
                    'New Group',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            
            // Member List
            Expanded(
              child: _MemberList(
                members: controller.filteredMembers,
                onTapMember: controller.startPersonalChat,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.members,
    required this.onTapMember,
  });

  final List<UserModel> members;
  final void Function(UserModel) onTapMember;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingS),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return MemberListItem(
          member: member,
          isSupervisor: member.role == 'supervisor',
          onTap: () => onTapMember(member),
        );
      },
    );
  }
}
