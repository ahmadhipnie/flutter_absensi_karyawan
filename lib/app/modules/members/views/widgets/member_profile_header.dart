import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../../../core/config/app_config.dart';

class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = AppConfig.getProfilePhotoUrl(user.photoProfile);
    
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
            onBackgroundImageError: photoUrl != null ? (_, __) {} : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.role.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}