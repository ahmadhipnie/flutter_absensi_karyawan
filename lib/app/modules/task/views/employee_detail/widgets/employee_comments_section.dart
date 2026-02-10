import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../../../common/widgets/user_avatar.dart';
import '../../../controllers/employee_detail_controller.dart';

class EmployeeCommentsSection extends GetView<EmployeeDetailController> {
  final double minHeight;

  const EmployeeCommentsSection({
    super.key,
    this.minHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Comments
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // List comments
            Obx(
              () {
                if (controller.isLoadingComments.value) {
                  return SizedBox(
                    height: minHeight * 0.6,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE53935),
                      ),
                    ),
                  );
                }
                
                final comments = controller.comments;
                if (comments.isEmpty) {
                  // Show placeholder when there are no comments
                  return SizedBox(
                    height: minHeight * 0.6,
                    child: const Center(
                      child: Text(
                        'No comments yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _buildCommentItem(comments[index]),
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemCount: comments.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(name: comment.userName, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      comment.time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
