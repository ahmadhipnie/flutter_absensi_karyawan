import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';
import 'widgets/add_task_app_bar.dart';
import 'widgets/add_task_first_card.dart';
import 'widgets/add_task_second_card.dart';
import 'widgets/add_task_third_card.dart';

class AddTaskView extends GetView<AddTaskController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
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
