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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppTheme.gray100,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Main content yang bisa scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const EmployeeHeaderInfo(),
                  const SizedBox(height: 8),
                  const EmployeeOutputSection(),
                  const SizedBox(height: 8),
                  // Comments dengan min height agar terlihat memanjang
                  EmployeeCommentsSection(
                    minHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  // Space untuk scroll saat keyboard muncul
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ),
          // Private Comment Input fixed di bottom
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
    return CommentInputWidget(
      controller: controller.commentController,
      onSend: controller.sendPrivateComment,
      hintText: 'This task needs more precision',
      sendIconColor: const Color(0xFF0046BE),
    );
  }
}
