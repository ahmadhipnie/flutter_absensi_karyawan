import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = avatarUrl != null && 
                        avatarUrl!.isNotEmpty && 
                        !avatarUrl!.contains('ui-avatars.com');
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: hasValidUrl ? NetworkImage(avatarUrl!) : null,
          child: !hasValidUrl
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
        ),
      ),
    );
  }
}
