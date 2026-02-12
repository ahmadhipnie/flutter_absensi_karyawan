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
      child: Obx(() {
        final avatarUrl = controller.userAvatarUrl.value;
        final hasValidUrl = avatarUrl.isNotEmpty && 
                           !avatarUrl.contains('ui-avatars.com');
        
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            color: hasValidUrl ? null : Colors.white.withOpacity(0.3),
            image: hasValidUrl
                ? DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasValidUrl
              ? const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 36,
                )
              : null,
        );
      }),
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
    return Obx(() {
      final unreadCount = controller.unreadNotificationCount.value;

      return GestureDetector(
        onTap: controller.openNotifications,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 28,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: _buildBadge(unreadCount),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBadge(int count) {
    // Show "99+" for counts >= 100
    final displayText = count >= 100 ? '99+' : count.toString();
    final badgeWidth = displayText.length == 1 ? 18.0 : displayText.length == 2 ? 24.0 : 30.0;

    return Container(
      width: badgeWidth,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF003AE6), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
    );
  }
}
