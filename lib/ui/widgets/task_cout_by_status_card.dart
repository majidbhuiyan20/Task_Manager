import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskCountByStatusCard extends StatelessWidget {
  const TaskCountByStatusCard({
    super.key,
    required this.title,
    required this.count,
  });
  final String title;
  final int count;

  LinearGradient get _gradient {
    switch (title.toLowerCase()) {
      case 'new':
        return AppColors.coolGradient;
      case 'progress':
        return AppColors.warmGradient;
      case 'cancelled':
        return const LinearGradient(
          colors: [Color(0xFFE17055), Color(0xFFFF7675)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'completed':
        return AppColors.accentGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  IconData get _icon {
    switch (title.toLowerCase()) {
      case 'new':
        return Icons.fiber_new_rounded;
      case 'progress':
        return Icons.timelapse_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  _icon,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
