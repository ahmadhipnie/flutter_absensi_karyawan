import 'package:flutter/material.dart';

class TaskDateRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const TaskDateRow({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.calendar_today,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF757575)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
