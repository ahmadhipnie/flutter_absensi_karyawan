import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class EmptyMembersState extends StatelessWidget {
  const EmptyMembersState({super.key});

  static const _iconColor = Color(0xFFE5E5EA);
  static const _textColor = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: _iconColor,
          ),
          SizedBox(height: AppTheme.paddingM),
          Text(
            'No members',
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
