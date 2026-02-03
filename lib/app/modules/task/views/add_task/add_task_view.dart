import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/add_task_controller.dart';
import 'widgets/add_task_app_bar.dart';
import 'widgets/add_task_cards.dart';

class AddTaskView extends GetView<TaskFormController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray100,
      appBar: const AddTaskAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddTaskFirstCard(),
                const SizedBox(height: 16),
                const AddTaskSecondCard(),
                const SizedBox(height: 16),
                const AddTaskThirdCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
