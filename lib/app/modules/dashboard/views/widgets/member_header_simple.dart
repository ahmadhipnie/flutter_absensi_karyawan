import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../routes/app_pages.dart';

class MemberHeaderSimple extends GetView<DashboardController> {
  const MemberHeaderSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Increased height untuk accommodate overlap
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF003AE6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.centerLeft,
          child: _buildProfileRow(),
        ),
      ),
    );
  }

  Widget _buildProfileRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(child: _buildUserInfo()),
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PROFILE),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.white.withOpacity(0.3),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            controller.userName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            controller.userPosition.value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: controller.openNotifications,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
