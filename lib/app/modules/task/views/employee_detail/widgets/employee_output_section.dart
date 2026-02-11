import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/employee_detail_controller.dart';

class EmployeeOutputSection extends GetView<EmployeeDetailController> {
  const EmployeeOutputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Output',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.outputFiles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final file = controller.outputFiles[index];
                return _buildOutputFileItem(file);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputFileItem(Map<String, String> file) {
    final fileType = file['type'] ?? 'file';
    final fileName = file['name'] ?? '';
    final filePath = file['path'] ?? '';

    return InkWell(
      onTap: () => controller.openOutputFile(filePath, fileType: fileType),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            _buildFileIcon(fileType),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildFileIcon(String fileType) {
    IconData iconData;
    Color iconColor;

    switch (fileType.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf_outlined;
        iconColor = const Color(0xFFD32F2F);
        break;
      case 'doc':
        iconData = Icons.description_outlined;
        iconColor = const Color(0xFF1976D2);
        break;
      case 'xls':
        iconData = Icons.table_chart_outlined;
        iconColor = const Color(0xFF388E3C);
        break;
      case 'image':
        iconData = Icons.image_outlined;
        iconColor = const Color(0xFF9C27B0);
        break;
      case 'txt':
        iconData = Icons.text_snippet_outlined;
        iconColor = const Color(0xFF757575);
        break;
      case 'link':
        iconData = Icons.link;
        iconColor = const Color(0xFF2196F3);
        break;
      default:
        iconData = Icons.insert_drive_file_outlined;
        iconColor = AppTheme.primaryColor;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 24,
    );
  }
}
