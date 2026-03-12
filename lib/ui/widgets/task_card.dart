
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshParent,
  });

  final TaskModel taskModel;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _changeStatusINProgress = false;
  bool _deleteTaskInProgress = false;

  Color get _statusColor {
    switch (widget.taskModel.status) {
      case 'New':
        return AppColors.statusNew;
      case 'Progress':
        return AppColors.statusProgress;
      case 'Cancelled':
        return AppColors.statusCancelled;
      case 'Completed':
        return AppColors.statusCompleted;
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (widget.taskModel.status) {
      case 'New':
        return Icons.fiber_new_rounded;
      case 'Progress':
        return Icons.timelapse_rounded;
      case 'Cancelled':
        return Icons.cancel_rounded;
      case 'Completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.taskModel.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                widget.taskModel.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Bottom row: date, status, actions
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    widget.taskModel.createDate.length > 10
                        ? widget.taskModel.createDate.substring(0, 10)
                        : widget.taskModel.createDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon, size: 14, color: _statusColor),
                        const SizedBox(width: 4),
                        Text(
                          widget.taskModel.status,
                          style: TextStyle(
                            color: _statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: _changeStatusINProgress == false &&
                        _deleteTaskInProgress == false,
                    replacement: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    child: _ActionButton(
                      icon: Icons.edit_rounded,
                      color: AppColors.primary,
                      onTap: _showChangeStatusDialog,
                      tooltip: 'Change Status',
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.statusCancelled,
                    onTap: _showDeleteConfirmationDialog,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.statusCancelled.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_forever_rounded,
                  color: AppColors.statusCancelled, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Delete Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.statusCancelled,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              fixedSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Change Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusOption(
                label: 'New',
                icon: Icons.fiber_new_rounded,
                color: AppColors.statusNew,
                isSelected: widget.taskModel.status == 'New',
                onTap: () => _changeStatus('New'),
              ),
              _StatusOption(
                label: 'Progress',
                icon: Icons.timelapse_rounded,
                color: AppColors.statusProgress,
                isSelected: widget.taskModel.status == 'Progress',
                onTap: () => _changeStatus('Progress'),
              ),
              _StatusOption(
                label: 'Cancelled',
                icon: Icons.cancel_rounded,
                color: AppColors.statusCancelled,
                isSelected: widget.taskModel.status == 'Cancelled',
                onTap: () => _changeStatus('Cancelled'),
              ),
              _StatusOption(
                label: 'Completed',
                icon: Icons.check_circle_rounded,
                color: AppColors.statusCompleted,
                isSelected: widget.taskModel.status == 'Completed',
                onTap: () => _changeStatus('Completed'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    if (mounted) setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.deleteTaskStatusUrls(widget.taskModel.id));
    _deleteTaskInProgress = false;
    if (mounted) setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task deleted successfully.', AppColors.statusCompleted);
      widget.refreshParent();
    } else {
      showSnackBarMessage(
          context, response.errorMessage ?? 'Delete failed!', AppColors.statusCancelled);
    }
  }

  Future<void> _changeStatus(String status) async {
    Navigator.pop(context);

    if (status == widget.taskModel.status) {
      return;
    }

    _changeStatusINProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.updateTaskStatusUrls(widget.taskModel.id, status));
    _changeStatusINProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
      showSnackBarMessage(context, 'Status updated to $status', AppColors.statusCompleted);
    } else {
      showSnackBarMessage(context, response.errorMessage!, AppColors.statusCancelled);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? color : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_rounded, color: color, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
