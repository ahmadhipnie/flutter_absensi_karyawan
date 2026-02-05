import 'package:flutter/material.dart';
import '../../models/member_model.dart';

class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({required this.member, super.key});

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = member.avatarUrl != null && member.avatarUrl!.isNotEmpty;
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: hasValidUrl ? NetworkImage(member.avatarUrl!) : null,
            child: !hasValidUrl
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
            onBackgroundImageError: hasValidUrl ? (_, __) {} : null,
          ),
          const SizedBox(height: 16),
          Text(
            member.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.department,
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
