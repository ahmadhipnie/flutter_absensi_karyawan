import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/attendance_history_detail_controller.dart';

class AttendanceHistoryPhotoSection extends GetView<AttendanceHistoryDetailController> {
  const AttendanceHistoryPhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        color: AppTheme.gray100,
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(
        () {
          final url = controller.photoUrl.value;
          if (url.isNotEmpty) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    insetPadding: const EdgeInsets.all(8),
                    child: InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            );
          }

          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.gray100,
      child: Center(
        child: Icon(
          Icons.person,
          size: 100,
          color: AppTheme.gray400,
        ),
      ),
    );
  }
}
