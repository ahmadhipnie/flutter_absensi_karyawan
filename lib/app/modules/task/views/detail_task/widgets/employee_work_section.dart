import 'package:flutter/material.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../controllers/task_detail_controller.dart';
import 'employee_work_item.dart';

class EmployeeWorkSection extends StatelessWidget {
  final String title;
  final List<EmployeeWorkModel> employees;

  const EmployeeWorkSection({
    super.key,
    required this.title,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        AppCardContainer(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: employees.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEEEEEE),
            ),
            itemBuilder: (context, index) {
              return EmployeeWorkItem(
                employee: employees[index],
                isFirst: index == 0,
                isLast: index == employees.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
