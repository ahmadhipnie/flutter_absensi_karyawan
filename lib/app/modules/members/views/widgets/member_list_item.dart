import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/members_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class MemberListItem extends StatelessWidget {
  final UserModel user;
  
  const MemberListItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = AppConfig.getProfilePhotoUrl(user.photoProfile);

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
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : null,
              child: photoUrl == null
                  ? Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                      size: 28,
                    )
                  : null,
              onBackgroundImageError: photoUrl != null
                  ? (exception, stackTrace) {}
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Name only
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
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
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
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