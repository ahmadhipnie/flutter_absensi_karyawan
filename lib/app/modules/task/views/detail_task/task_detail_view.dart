import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_back_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/task_detail_controller.dart';
import './widgets/task_detail_tab_view.dart';
import './widgets/employee_work_tab_view.dart';
import './widgets/edit_task_button.dart';
import './widgets/task_detail_tab_bar.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AppBackButton(),
        actions: [
          EditTaskButton(onPressed: controller.editTask),
        ],
      ),
      body: Column(
        children: [
          TaskDetailTabBar(controller: controller.tabController),
          Expanded(
            child: Container(
              color: AppTheme.gray100,
              child: TabBarView(
                controller: controller.tabController,
                children: const [
                  TaskDetailTabView(),
                  EmployeeWorkTabView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
