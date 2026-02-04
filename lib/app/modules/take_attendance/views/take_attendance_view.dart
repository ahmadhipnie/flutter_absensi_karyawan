import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/app_back_button.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/take_attendance_controller.dart';
import 'widgets/attendance_photo_section.dart';
import 'widgets/attendance_notes_field.dart';
import 'widgets/attendance_location_field.dart';
import 'widgets/attendance_clock_in_button.dart';

class TakeAttendanceView extends GetView<TakeAttendanceController> {
  const TakeAttendanceView({super.key});

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
              const AttendancePhotoSection(),
              const SizedBox(height: 24),
              const AttendanceNotesField(),
              const SizedBox(height: 16),
              const AttendanceLocationField(),
              const SizedBox(height: 32),
              const AttendanceClockInButton(),
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
          controller.formattedDate,
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
