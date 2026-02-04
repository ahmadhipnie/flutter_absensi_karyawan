import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MemberTaskSection extends StatelessWidget {
  const MemberTaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Task',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _TaskSummaryCard(title: 'Ditugaskan', count: '19')),
              SizedBox(width: 12),
              Expanded(child: _TaskSummaryCard(title: 'Tepat Waktu', count: '10')),
              SizedBox(width: 12),
              Expanded(child: _TaskSummaryCard(title: 'Approved', count: '20')),
            ],
          ),
          const SizedBox(height: 24),
          const _TaskItem(
            title: 'Site Inspection Report Submission',
            subtitle: 'Due 17 Feb 2026, 11:59 PM',
          ),
          const SizedBox(height: 32),
          const _TaskItem(
            title: 'Site Inspection Report Submission',
            subtitle: 'Due 17 Feb 2026, 11:59 PM',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({
    required this.title,
    required this.count,
  });

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEBF0FF),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Center(
            child: Icon(Icons.assignment, color: AppTheme.primaryColor, size: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_vert, size: 20, color: Color(0xFF757575)),
      ],
    );
  }
}
