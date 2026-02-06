import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/widgets/filter_chips.dart';
import '../../../../common/widgets/app_fab.dart';
import '../../controllers/task_controller.dart';
import 'widgets/task_list.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            AppFilterChips(
              selectedFilter: controller.selectedFilter,
              filters: controller.filters,
              onFilterSelected: controller.selectFilter,
            ),
            const Expanded(child: TaskList()),
          ],
        ),
      ),
      floatingActionButton: controller.isSupervisor
          ? AppFAB(
              heroTag: 'task_fab',
              onPressed: () async {
                final result = await Get.toNamed('/add-task');
                // Refresh tasks if task was created successfully
                if (result == true) {
                  controller.refresh();
                }
              },
            )
          : null,
    ));
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Text(
        'Task',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
