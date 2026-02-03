import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/member_model.dart';
import '../../controllers/members_controller.dart';
import '../../../../core/theme/app_theme.dart';

class MemberListItem extends StatelessWidget {
  final MemberModel member;
  
  const MemberListItem({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<MembersController>().goToMemberDetail(member);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: member.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        member.avatarUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                            size: 28,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
            ),
            
            SizedBox(width: 16),
            
            // Name only
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            
            // Trailing: either Supervisor badge or menu button
            member.userType == 'Supervisor'
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.grey.shade700),
              title: Text('View Detail'),
              onTap: () {
                Get.back();
                controller.goToMemberDetail(member);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.grey.shade700),
              title: Text('Edit Profile'),
              onTap: () {
                Get.back();
                controller.goToEditProfile(member);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
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
        content: Text('Are you sure you want to delete ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMember(member.id);
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
