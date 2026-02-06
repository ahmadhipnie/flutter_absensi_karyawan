import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    required this.avatarUrl,
    this.onCameraTap,
    super.key,
  });

  final String? avatarUrl;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    final photoUrl = AppConfig.getProfilePhotoUrl(avatarUrl);
    
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
              onBackgroundImageError: photoUrl != null
                  ? (_, __) {}
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}