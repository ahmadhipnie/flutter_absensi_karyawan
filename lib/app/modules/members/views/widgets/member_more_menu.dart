import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_pages.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/services/user_service.dart';
import '../../controllers/members_controller.dart';

class MemberMoreMenu extends StatelessWidget {
  const MemberMoreMenu({required this.user, super.key});

  final UserModel user;
  
  static final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.black),
        onSelected: (value) => _handleMenuSelection(value),
        itemBuilder: (context) => [
          _buildMenuItem('edit', Icons.edit, 'Edit Profile'),
          const PopupMenuDivider(height: 8),
          _buildMenuItem('password', Icons.lock, 'Change Password'),
          const PopupMenuDivider(height: 8),
          _buildMenuItem('delete', Icons.delete, 'Delete Account', isDestructive: true),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String label, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? AppTheme.primaryColor : const Color(0xFF616161),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDestructive ? AppTheme.primaryColor : const Color(0xFF616161),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) async {
    switch (value) {
      case 'edit':
        final result = await Get.toNamed(Routes.EDIT_PROFILE, arguments: user);
        // If edit was successful, we could refresh the user data here
        // But since we're in a widget without controller, 
        // the parent screen will handle it via goToMemberDetail result
        if (result == true) {
          print('User edited successfully');
        }
        break;
      case 'password':
        await Get.toNamed(Routes.CHANGE_PASSWORD, arguments: user);
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.primaryColor, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this account?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username ?? 'No username',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone. All user data will be permanently deleted.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close confirm dialog first
              Get.back();
              // Small delay to ensure dialog is closed
              await Future.delayed(const Duration(milliseconds: 100));
              _deleteUser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _deleteUser() async {
    // Show loading dialog
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Deleting account...',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await _userService.deleteUser(user.id);

      // Close loading dialog - use a loop to ensure it's closed
      while (Get.isDialogOpen ?? false) {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // Refresh members list if controller is available
      if (Get.isRegistered<MembersController>()) {
        try {
          final membersCtrl = Get.find<MembersController>();
          await membersCtrl.fetchMembers();
        } catch (e) {
          print('Error refreshing members: $e');
        }
      }

      // If we're on the member detail page, pop it to reveal the members list
      if (Get.currentRoute == Routes.MEMBER_DETAIL) {
        Get.back(result: true);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Show success message
      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Account "${user.username ?? user.email}" deleted successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      // Close loading dialog - use a loop to ensure it's closed
      while (Get.isDialogOpen ?? false) {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 50));
      }

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to delete account: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error deleting user: $e');
    }
  }
}
