import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import './widgets/profile_header.dart';
import './widgets/profile_card.dart';
import './widgets/profile_avatar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          const ProfileHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: ProfileCard(
              onAttendanceLogTap: () => Get.toNamed(Routes.ATTENDANCE_LOG),
              onEditProfileTap: () => Get.toNamed(Routes.EDIT_MY_PROFILE),
              onChangePasswordTap: () => Get.toNamed(Routes.CHANGE_MY_PASSWORD),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(() => ProfileAvatar(avatarUrl: controller.avatarUrl.value)),
          ),
        ],
      ),
    );
  }
}
