import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/attendance_controller.dart';

void showEditTimeDialog(BuildContext context) {
  final controller = Get.find<AttendanceController>();
  
  // Use observables for reactive UI
  final startTime = controller.workStartTime.value.obs;
  final endTime = controller.workEndTime.value.obs;
  
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTimeInputs(context, startTime, endTime),
          const SizedBox(height: 32),
          _buildUpdateButton(controller, startTime, endTime),
          const SizedBox(height: 16),
        ],
      ),
    ),
    isDismissible: true,
    enableDrag: true,
  );
}

Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Edit Work Hours',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.close),
      ),
    ],
  );
}

Widget _buildTimeInputs(
  BuildContext context,
  RxString startTime,
  RxString endTime,
) {
  return Row(
    children: [
      Expanded(
        child: _buildTimeInput(
          context,
          'Clock In Time',
          startTime,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildTimeInput(
          context,
          'Clock Out Time',
          endTime,
        ),
      ),
    ],
  );
}

Widget _buildTimeInput(
  BuildContext context,
  String label,
  RxString timeValue,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 8),
      InkWell(
        onTap: () async {
          // Parse current time or use default
          TimeOfDay initialTime;
          try {
            final parts = timeValue.value.split(':');
            initialTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: parts.length > 1 ? int.parse(parts[1]) : 0,
            );
          } catch (e) {
            print('Error parsing time: $e');
            initialTime = const TimeOfDay(hour: 8, minute: 0);
          }

          print('Opening time picker with initial time: ${initialTime.hour}:${initialTime.minute}');

          // Show time picker
          final picked = await showTimePicker(
            context: context,
            initialTime: initialTime,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppTheme.primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            // Format as HH:MM
            final hour = picked.hour.toString().padLeft(2, '0');
            final minute = picked.minute.toString().padLeft(2, '0');
            final formattedTime = '$hour:$minute';
            
            print('Time picked: $formattedTime');
            
            // Update the observable
            timeValue.value = formattedTime;
          }
        },
        child: Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time_filled,
                  color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  timeValue.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    ],
  );
}

Widget _buildUpdateButton(
  AttendanceController controller,
  RxString startTime,
  RxString endTime,
) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: () async {
        final start = startTime.value;
        final end = endTime.value;
        
        print('Update button pressed');
        print('Start time: $start');
        print('End time: $end');
        
        // Validate times
        if (start.isEmpty || end.isEmpty) {
          Get.snackbar(
            'Error',
            'Please select both times',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
          );
          return;
        }
        
        // Close dialog first
        Get.back();
        
        // Update via controller (which will call API and handle loading/messages)
        await controller.updateScheduleTimes(start, end);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Update Time'),
    ),
  );
}


