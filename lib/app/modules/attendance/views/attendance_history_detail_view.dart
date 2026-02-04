import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/app_back_button.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/attendance_history_detail_controller.dart';
import 'widgets/attendance_history_photo_section.dart';
import 'widgets/attendance_history_detail_item.dart';

class AttendanceHistoryDetailView extends GetView<AttendanceHistoryDetailController> {
  const AttendanceHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AttendanceHistoryPhotoSection(),
              const SizedBox(height: 24),
              AttendanceHistoryDetailItem(
                label: 'Notes (Optional)',
                icon: Icons.work_outline,
                value: controller.notes,
              ),
              const SizedBox(height: 16),
              AttendanceHistoryDetailItem(
                label: 'Location',
                icon: Icons.location_on_outlined,
                value: controller.location,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: const AppBackButton(),
      title: Obx(
        () => Text(
          controller.formattedDate.value,
          style: const TextStyle(
            color: AppTheme.gray900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
