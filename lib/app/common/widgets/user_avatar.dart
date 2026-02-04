import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final int? backgroundColor;
  final TextStyle? textStyle;
  final String? imageUrl;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.backgroundColor,
    this.textStyle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final defaultColor = backgroundColor ?? AppTheme.primaryColor.value;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(defaultColor),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: size * 0.375,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
