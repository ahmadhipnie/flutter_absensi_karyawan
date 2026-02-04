import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_task_detail_controller.dart';
import 'widgets/user_task_header.dart';
import 'widgets/user_task_description.dart';
import 'widgets/user_task_info.dart';
import 'widgets/user_task_bottom_section.dart';

class UserTaskDetailView extends GetView<UserTaskDetailController> {
  const UserTaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Main content yang bisa scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  UserTaskHeader(),
                  SizedBox(height: 24),
                  UserTaskDescription(),
                  SizedBox(height: 24),
                  UserTaskInfo(),
                  // Spacer untuk scroll saat bottom section besar
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Bottom section dengan max height constraint
          const _BottomSectionWrapper(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
    );
  }
}

/// Wrapper untuk bottom section dengan max height constraint
class _BottomSectionWrapper extends GetView<UserTaskDetailController> {
  const _BottomSectionWrapper();

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.45; // Max 45% screen height

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: const UserTaskBottomSection(),
    );
  }
}
