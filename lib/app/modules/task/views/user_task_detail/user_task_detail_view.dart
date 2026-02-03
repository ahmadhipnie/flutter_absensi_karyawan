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
                ],
              ),
            ),
          ),
          const UserTaskBottomSection(),
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
