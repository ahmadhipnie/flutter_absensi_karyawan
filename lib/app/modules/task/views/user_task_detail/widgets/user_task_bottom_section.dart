import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/user_task_detail_controller.dart';

class UserTaskBottomSection extends GetView<UserTaskDetailController> {
  const UserTaskBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Obx(() {
          // Show "Turned In" state if task is submitted
          if (controller.isTaskSubmitted.value) {
            return _buildTurnedInState();
          }
          
          // Show normal upload state
          return _buildUploadState();
        }),
      ),
    );
  }

  Widget _buildUploadState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        // File list dengan scroll jika banyak
        Flexible(
          child: Obx(() {
            if (controller.uploadedFiles.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: controller.uploadedFiles.length,
                itemBuilder: (context, index) {
                  return _buildFileItem(
                    controller.uploadedFiles[index],
                    index,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ),
        const SizedBox(height: 12),
        _buildUploadButton(),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTurnedInState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Work',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9E9E),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Turned In',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Submitted file item (clickable to preview)
        InkWell(
          onTap: controller.openSubmittedFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF5350).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Color(0xFFEF5350),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.submittedFileName.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.submittedDate.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.open_in_new,
                  color: Color(0xFF9E9E9E),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Unsubmit button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: controller.unsubmitTask,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Unsubmit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your Work',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(60, 40),
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: const Text(
            'Assign',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon file
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  file['type']?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Delete button
          GestureDetector(
            onTap: () => controller.removeFile(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Color(0xFF757575),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return InkWell(
      onTap: controller.showUploadOptions,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Text(
              controller.uploadedFiles.isEmpty ? 'Upload Your Work' : 'Add More',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isSubmitting.value ? null : controller.submitWork,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0046BE),
          disabledBackgroundColor: const Color(0xFF0046BE).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: controller.isSubmitting.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    ));
  }
}
