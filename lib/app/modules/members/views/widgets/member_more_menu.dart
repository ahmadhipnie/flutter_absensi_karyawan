import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_pages.dart';
import '../../models/member_model.dart';

class MemberMoreMenu extends StatelessWidget {
  const MemberMoreMenu({required this.member, super.key});

  final MemberModel member;

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

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        Get.toNamed(Routes.EDIT_PROFILE, arguments: member);
        break;
      case 'password':
        Get.toNamed(Routes.CHANGE_PASSWORD, arguments: member);
        break;
      case 'delete':
        // TODO: Implement delete logic
        break;
    }
  }
}
