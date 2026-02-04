import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';

class EmployeeLogTabs extends GetView<AttendanceController> {
  const EmployeeLogTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Obx(() => Row(
            children: [
              _buildTabItem('Sudah Clock In', true),
              _buildTabItem('Belum Clock In', false),
            ],
          )),
    );
  }

  Widget _buildTabItem(String title, bool isClockedInTab) {
    final isSelected = controller.showClockedIn.value == isClockedInTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.showClockedIn.value = isClockedInTab,
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
