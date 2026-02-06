import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/department_controller.dart';

class CreateDepartmentView extends GetView<DepartmentController> {
  const CreateDepartmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Department',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Left align the title to match design
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF1F2937)),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: Obx(() => ElevatedButton.icon(
              onPressed: controller.isLoading.value ? null : controller.saveDepartment,
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003AE6)),
                      ),
                    )
                  : const Icon(Icons.save, size: 14),
              label: Text(controller.isLoading.value ? 'Saving...' : 'Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF), // light blue background
                foregroundColor: AppTheme.primaryColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFDDE8FF)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(68, 34),
              ),
            )),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Obx(() {
                final selectedImage = controller.selectedImage.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: selectedImage != null
                            ? Image.file(selectedImage, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.business, size: 40, color: Colors.grey),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: controller.showImagePickerOptions,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 32),
            
            _buildLabel('Nama Department'),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                hintText: 'Executive Management',
                prefixIcon: const Icon(Icons.business, size: 20, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
             _buildLabel('Description'),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Input Text disniiii',
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                 enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B7280),
      ),
    );
  }
}
