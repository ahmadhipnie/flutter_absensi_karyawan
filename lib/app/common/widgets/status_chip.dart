import 'package:flutter/material.dart';

enum WorkStatus {
  pending('Pending', Color(0xFFFFA726)),
  inProgress('In Progress', Color(0xFF42A5F5)),
  completed('Completed', Color(0xFF66BB6A)),
  rejected('Rejected', Color(0xFFEF5350));

  final String label;
  final Color color;

  const WorkStatus(this.label, this.color);
}

class StatusChip extends StatelessWidget {
  final WorkStatus status;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status.label,
          style: TextStyle(
            color: status.color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class StatusDropdown extends StatelessWidget {
  final WorkStatus selectedStatus;
  final ValueChanged<WorkStatus> onChanged;

  const StatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showStatusDialog(context),
      child: StatusChip(status: selectedStatus),
    );
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WorkStatus.values.map((status) {
            return ListTile(
              leading: Radio<WorkStatus>(
                value: status,
                groupValue: selectedStatus,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: status.color,
              ),
              title: Text(
                status.label,
                style: TextStyle(color: status.color, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                onChanged(status);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
