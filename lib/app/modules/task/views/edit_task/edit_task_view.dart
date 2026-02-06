import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/edit_task_controller.dart';
import './widgets/edit_task_app_bar.dart';
import './widgets/edit_task_cards.dart';

class EditTaskView extends GetView<EditTaskController> {
  const EditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray100,
      appBar: const EditTaskAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EditTaskFirstCard(),
                const SizedBox(height: 16),
                const EditTaskSecondCard(),
                const SizedBox(height: 16),
                const EditTaskThirdCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
