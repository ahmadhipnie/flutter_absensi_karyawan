import 'package:flutter/material.dart';
import '../../../../../common/widgets/user_avatar.dart';
import '../../../../../common/widgets/app_checkbox.dart';
import '../../../../../core/theme/app_theme.dart';

class MemberItem extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isAllOption;

  const MemberItem({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
    this.isAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final memberId = member['id'];
    final displayName = member['displayName'] as String? ?? member['name'] as String?;
    final email = member['email'] as String?;
    final avatarUrl = member['avatarUrl'] as String?;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppTheme.primaryColor.withValues(alpha: 0.05),
            highlightColor: AppTheme.primaryColor.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  _buildAvatar(displayName, avatarUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName ?? 'Unknown',
                          style: const TextStyle(
                            color: AppTheme.gray900,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (email != null && email.isNotEmpty)
                          Text(
                            email,
                            style: const TextStyle(
                              color: AppTheme.gray600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppCheckbox(isSelected: isSelected),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAvatar(String? name, String? avatarUrl) {
    if (isAllOption) {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.group,
          color: Colors.white,
          size: 24,
        ),
      );
    }
    
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }
    
    return UserAvatar(
      name: name ?? 'U',
      size: 48,
    );
  }
}
