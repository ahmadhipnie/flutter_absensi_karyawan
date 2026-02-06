import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';

class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = user.photoProfile != null && user.photoProfile!.isNotEmpty;
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: hasValidUrl ? NetworkImage(user.photoProfile!) : null,
            child: !hasValidUrl
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
            onBackgroundImageError: hasValidUrl ? (_, __) {} : null,
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
