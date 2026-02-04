import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/widgets/comment_input_widget.dart';
import '../../controllers/employee_detail_controller.dart';
import 'widgets/employee_header_info.dart';
import 'widgets/employee_output_section.dart';
import 'widgets/employee_comments_section.dart';

class EmployeeDetailView extends GetView<EmployeeDetailController> {
  const EmployeeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray100,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  EmployeeHeaderInfo(),
                  SizedBox(height: 24),
                  EmployeeOutputSection(),
                  SizedBox(height: 24),
                  EmployeeCommentsSection(),
                ],
              ),
            ),
          ),
          _buildPrivateCommentInput(),
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

  Widget _buildPrivateCommentInput() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        child: CommentInputWidget(
          controller: controller.commentController,
          onSend: controller.sendPrivateComment,
          hintText: 'This task needs more precision',
          sendIconColor: const Color(0xFF0046BE),
        ),
      ),
    );
  }
}
