import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/department_controller.dart';
import '../../members/controllers/members_controller.dart';
import '../../../core/config/app_config.dart';

class DepartmentInfoView extends GetView<DepartmentController> {
  const DepartmentInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Only show Edit/Delete buttons when not in read-only mode
          if (!controller.isReadOnly.value) ...[
            Container(
              margin: const EdgeInsets.only(right: 8, top: 12, bottom: 12),
              child: ElevatedButton(
                onPressed: () async {
                  controller.loadDepartmentForEdit();
                  final result = await Get.toNamed(
                    Routes.EDIT_DEPARTMENT,
                    arguments: controller.department.value,
                  );
                  if (result == true) {
                    Get.back(result: true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E7FF),
                  foregroundColor: AppTheme.primaryColor,
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Edit'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              child: ElevatedButton(
                onPressed: () => controller.deleteDepartment(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[700],
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Delete'),
              ),
            ),
          ],
        ],
      ),
      body: Obx(() {
        final dept = controller.department.value;
        final photoUrl = AppConfig.getDepartmentPhotoUrl(dept?.photo);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: photoUrl != null
                              ? NetworkImage(photoUrl) as ImageProvider
                              : const AssetImage('assets/bg-login.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dept?.name ?? 'Department',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Show member count for this department
                    if (dept == null)
                      const SizedBox.shrink()
                    else if (!Get.isRegistered<MembersController>())
                      const Text(
                        '0 members',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      Obx(() {
                        try {
                          final membersCtrl = Get.find<MembersController>();
                          final memberCount = membersCtrl.members
                              .where((m) => m.departmentId == dept.id)
                              .length;

                          return Text(
                            '$memberCount member${memberCount == 1 ? '' : 's'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        } catch (e) {
                          return const Text(
                            '0 members',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dept?.description ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
