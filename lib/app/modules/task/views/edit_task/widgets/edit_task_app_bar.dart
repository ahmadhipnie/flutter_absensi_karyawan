import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/edit_task_controller.dart';

class EditTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditTaskAppBar({super.key});

  EditTaskController get controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        alignment: Alignment.centerRight,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      centerTitle: false,
      title: const Text(
        'Edit Task',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Obx(() => TextButton.icon(
            onPressed: controller.isSubmitting.value ? null : controller.saveTask,
            style: TextButton.styleFrom(
              backgroundColor: controller.isSubmitting.value 
                  ? Colors.grey.withOpacity(0.1)
                  : AppTheme.primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: controller.isSubmitting.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.check, size: 16, color: AppTheme.primaryColor),
            label: Text(
              controller.isSubmitting.value ? 'Saving...' : 'Save',
              style: TextStyle(
                color: controller.isSubmitting.value ? Colors.grey : AppTheme.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
