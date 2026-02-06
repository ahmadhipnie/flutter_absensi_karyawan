import 'package:flutter/material.dart';

/// Widget untuk menampilkan avatar/image department
/// Jika imageUrl ada, tampilkan gambar dari URL
/// Jika imageUrl null/empty, tampilkan icon default
class DepartmentAvatar extends StatelessWidget {
  final String? imageUrl;
  final String departmentName;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;

  const DepartmentAvatar({
    Key? key,
    this.imageUrl,
    required this.departmentName,
    this.size = 56,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.business_center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xFF003AE6).withOpacity(0.1);
    final iColor = iconColor ?? const Color(0xFF003AE6);
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // If image fails to load, will show icon instead
                },
              )
            : null,
      ),
      child: !hasImage
          ? Icon(
              icon,
              color: iColor,
              size: size * 0.5,
            )
          : null,
    );
  }
}
