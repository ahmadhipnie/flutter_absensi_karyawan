import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/select_member_controller.dart';
import 'member_item.dart';

class MemberList extends GetView<SelectMemberController> {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.members.isEmpty) {
        return const Center(
          child: Text('No members available'),
        );
      }

      return Column(
        children: [
          // "All Members" option
          Obx(() => MemberItem(
            member: {
              'id': -1, // Special ID for "All"
              'displayName': 'All Members',
              'email': 'Select all members',
              'avatarUrl': '',
            },
            isSelected: controller.allMembersSelected.value,
            onTap: controller.toggleAllMembers,
            showDivider: true,
            isAllOption: true,
          )),
          
          // Individual members
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: controller.members.length,
              itemBuilder: (context, index) {
                final member = controller.members[index];
                return Obx(
                  () => MemberItem(
                    member: {
                      'id': member.id,
                      'displayName': member.displayName,
                      'email': member.email,
                      'avatarUrl': member.avatarUrl,
                    },
                    isSelected: controller.isSelected(member.id),
                    onTap: () => controller.toggleMember(member.id),
                    showDivider: index < controller.members.length - 1,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
