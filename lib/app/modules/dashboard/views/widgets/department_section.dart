import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/department_model.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/widgets/department_avatar.dart';
import '../../../../core/config/app_config.dart';

class DepartmentSection extends GetView<DashboardController> {
  const DepartmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 12),
        _buildDepartmentList(),
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

  Widget _buildDepartmentList() {
    return Obx(
      () {
        if (controller.isLoadingDepartments.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final filtered = controller.filteredDepartments;

        if (filtered.isEmpty && controller.searchQuery.value.isNotEmpty) {
          return Column(
            children: [
              _buildCreateDepartmentItem(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: Text(
                    'No departments found',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filtered.length + 1, // +1 for create button
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildCreateDepartmentItem();
            }
            return _buildDepartmentItem(filtered[index - 1]);
          },
        );
      },
    );
  }

  Widget _buildCreateDepartmentItem() {
    return GestureDetector(
      onTap: controller.createNewDepartment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Create New Department',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentItem(DepartmentModel department) {
    return GestureDetector(
      onTap: () => controller.openDepartment(department),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            DepartmentAvatar(
              imageUrl: AppConfig.getDepartmentPhotoUrl(department.photo),
              departmentName: department.name,
              size: 56,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              iconColor: AppTheme.primaryColor,
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
  }
}