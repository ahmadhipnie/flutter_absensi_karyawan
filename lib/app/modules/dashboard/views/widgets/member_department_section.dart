import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../common/widgets/department_avatar.dart';

class MemberDepartmentSection extends GetView<DashboardController> {
  const MemberDepartmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 12),
        _buildDepartmentItem(),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Department',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDepartmentItem() {
    return Obx(
      () {
        final department = controller.userDepartment.value;
        
        if (department == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => controller.openDepartment(department),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                DepartmentAvatar(
                  imageUrl: department.photo,
                  departmentName: department.name,
                  size: 56,
                  backgroundColor: const Color(0xFF003AE6).withOpacity(0.1),
                  iconColor: const Color(0xFF003AE6),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    department.name,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
