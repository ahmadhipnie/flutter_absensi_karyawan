import 'package:flutter/material.dart';
import '../../../../../common/widgets/user_avatar.dart';
import '../../../../../common/widgets/app_checkbox.dart';
import '../../../../../core/theme/app_theme.dart';

class MemberItem extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const MemberItem({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = member['avatarColor'] as int;
    final isAllMember = member['id'] == 'all';

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
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  _buildAvatar(isAllMember, avatarColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      member['name'] as String,
                      style: const TextStyle(
                        color: AppTheme.gray900,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildAvatar(bool isAllMember, int avatarColor) {
    if (isAllMember) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(avatarColor),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
          size: 24,
        ),
      );
    }
    return UserAvatar(
      name: member['name'] as String,
      size: 48,
      backgroundColor: avatarColor,
    );
  }
}
