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

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppTheme.primaryColor.withOpacity(0.05),
            highlightColor: AppTheme.primaryColor.withOpacity(0.03),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  UserAvatar(
                    name: member['name'] as String,
                    size: 48,
                    backgroundColor: avatarColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      member['name'] as String,
                      style: const TextStyle(
                        color: Colors.black,
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
}
