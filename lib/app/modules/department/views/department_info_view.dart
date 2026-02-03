import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/department_controller.dart';

class DepartmentInfoView extends GetView<DepartmentController> {
  const DepartmentInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
         title: const Text(''), // Empty
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.EDIT_DEPARTMENT),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF),
                foregroundColor: AppTheme.primaryColor,
                elevation: 0,
                 textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
               child: const Text('Edit'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                      image: const DecorationImage(
                        image: AssetImage('assets/bg-login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Executive Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                   const SizedBox(height: 4),
                  const Text(
                    '5 Members',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
             const Text(
               'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate',
               style: TextStyle(
                 fontSize: 14,
                 height: 1.5,
                 color: Color(0xFF374151),
               ),
             ),
          ],
        ),
      ),
    );
  }
}
