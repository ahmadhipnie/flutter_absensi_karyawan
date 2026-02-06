import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/members_controller.dart';
import '../../../../core/theme/app_theme.dart';

class MemberListItem extends StatelessWidget {
  final MemberModel member;

  final UserModel user;
  
  const MemberListItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<MembersController>().goToMemberDetail(user);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              backgroundImage: user.photoProfile != null && user.photoProfile!.isNotEmpty
                  ? NetworkImage(user.photoProfile!)
                  : null,
              child: user.photoProfile == null || user.photoProfile!.isEmpty
                  ? Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                      size: 28,
                    )
                  : null,
              onBackgroundImageError: user.photoProfile != null
                  ? (exception, stackTrace) {}
                  : null,
            ),

            SizedBox(width: 16),

            
            const SizedBox(width: 16),
            
            // Name only
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  member.displayName,
                  style: TextStyle(
                  user.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Trailing: either Supervisor badge or menu button
            member.isSupervisor
            user.role == 'supervisor'
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Supervisor',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    onPressed: () {
                      _showMenu(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final controller = Get.find<MembersController>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.grey.shade700),
              title: const Text('View Detail'),
              onTap: () {
                Get.back();
                controller.goToMemberDetail(user);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.grey.shade700),
              title: const Text('Edit Profile'),
              onTap: () {
                Get.back();
                controller.goToEditProfile(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _showDeleteDialog(context, controller);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MembersController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Member'),
        content: Text('Are you sure you want to delete ${member.displayName}?'),
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMember(member.id.toString());
              controller.deleteUser(user.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
