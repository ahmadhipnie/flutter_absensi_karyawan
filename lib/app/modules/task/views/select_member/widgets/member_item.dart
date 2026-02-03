import 'package:flutter/material.dart';
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
                  _buildAvatar(),
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
                  _buildCheckbox(),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAvatar() {
    final avatarColor = member['avatarColor'] as int;
    final avatarText = member['avatarText'] as String;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Color(avatarColor),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        avatarText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : const Color(0xFFBDBDBD),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}
