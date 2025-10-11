
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
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
        return Colors.blue;
      case 'Progress':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: Colors.white,
      title: Text(widget.taskModel.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.taskModel.description),
          Text(
            widget.taskModel.createDate,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text(
                  widget.taskModel.status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              const Spacer(),
              Visibility(
                visible: _changeStatusINProgress == false && _deleteTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: _showChangeStatusDialog,
                        icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Visibility(
            visible: _deleteTaskInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog first
                _deleteTask();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text("Change Status"),),
              ListTile(
                onTap: () {
                  _changeStatus("New");
                },
                title: const Text("New"),
                trailing: widget.taskModel.status == "New"
                    ? const Icon(Icons.done, color: Colors.green)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus("Progress");
                },
                title: const Text("Progress"),
                trailing: widget.taskModel.status == "Progress"
                    ? const Icon(Icons.done, color: Colors.green)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus("Cancelled");
                },
                title: const Text("Cancelled"),
                trailing: widget.taskModel.status == "Cancelled"
                    ? const Icon(Icons.done, color: Colors.green)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus("Completed");
                },
                title: const Text("Completed"),
                trailing: widget.taskModel.status == "Completed"
                    ? const Icon(Icons.done, color: Colors.green)
                    : null,
              ),
            ],
          ));
        });
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    if (mounted) setState(() {});
    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.deleteTaskStatusUrls(widget.taskModel.id));
    _deleteTaskInProgress = false;
    if (mounted) setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task deleted successfully.', Colors.green);
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, response.errorMessage ?? 'Delete failed!', Colors.red);
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
    setState(() {}); // To hide the main card's progress indicator
    if (response.isSuccess) {
      widget.refreshParent();
      showSnackBarMessage(context, 'Status updated to $status', Colors.green);
    } else {
      showSnackBarMessage(context, response.errorMessage!, Colors.red);
    }
  }
}
