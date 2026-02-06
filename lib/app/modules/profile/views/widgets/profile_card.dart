import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'profile_menu_item.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.onAttendanceLogTap,
    required this.onEditProfileTap,
    required this.onChangePasswordTap,
    super.key,
  });

  final VoidCallback onAttendanceLogTap;
  final VoidCallback onEditProfileTap;
  final VoidCallback onChangePasswordTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _NameSection(),
            const SizedBox(height: 32),
            _MenuItems(
              onAttendanceLogTap: onAttendanceLogTap,
              onEditProfileTap: onEditProfileTap,
              onChangePasswordTap: onChangePasswordTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NameSection extends StatelessWidget {
  const _NameSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Column(
      children: [
        Obx(() => Text(
          controller.userName.value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )),
        const SizedBox(height: 4),
        Obx(() => Text(
          controller.userRole.value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        )),
      ],
    );
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems({
    required this.onAttendanceLogTap,
    required this.onEditProfileTap,
    required this.onChangePasswordTap,
  });

  final VoidCallback onAttendanceLogTap;
  final VoidCallback onEditProfileTap;
  final VoidCallback onChangePasswordTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.analytics_outlined,
          text: 'Attendance Log',
          onTap: onAttendanceLogTap,
        ),
        _Divider(),
        ProfileMenuItem(
          icon: Icons.person_outline,
          text: 'Edit Profile',
          onTap: onEditProfileTap,
        ),
        _Divider(),
        ProfileMenuItem(
          icon: Icons.vpn_key_outlined,
          text: 'Change Password',
          onTap: onChangePasswordTap,
        ),
        _Divider(),
        ProfileMenuItem(
          icon: Icons.logout,
          text: 'Logout',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () => Get.find<ProfileController>().logout(),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE5E5E5));
  }
}
