import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../members/models/member_model.dart';

class MemberListItem extends StatelessWidget {
  const MemberListItem({
    required this.member,
    required this.isSupervisor,
    required this.onTap,
    super.key,
  });

  final MemberModel member;
  final bool isSupervisor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingL,
          vertical: 10,
        ),
        child: Row(
          children: [
            _MemberAvatar(member: member),
            const SizedBox(width: AppTheme.paddingM),
            Expanded(
              child: Text(
                member.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSupervisor) _SupervisorBadge(),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.member});

  final MemberModel member;

  static const _avatarSize = 44.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _avatarSize,
      height: _avatarSize,
      child: member.avatarUrl != null
          ? _NetworkAvatar(member: member)
          : _InitialsAvatar(name: member.name),
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  const _NetworkAvatar({required this.member});

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        member.avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _InitialsAvatar(name: member.name);
        },
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _SupervisorBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingM,
        vertical: AppTheme.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        'Supervisor',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
