import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/select_member_controller.dart';
import 'member_item.dart';

class MemberList extends GetView<SelectMemberController> {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: controller.members.length,
      itemBuilder: (context, index) {
        final member = controller.members[index];
        final memberId = member['id'] as String;
        return MemberItem(
          member: member,
          isSelected: false,
          onTap: () => controller.toggleMember(memberId),
          showDivider: index < controller.members.length - 1,
        );
      },
    );
  }
}
