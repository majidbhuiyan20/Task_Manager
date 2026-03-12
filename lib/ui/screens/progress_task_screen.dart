import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

import '../../data/model/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTasks();
  }

  Future<void> _getAllProgressTasks() async {
    setState(() {
      _getProgressTaskInProgress = true;
    });

    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.progressTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Something went wrong!", AppColors.statusCancelled);
      }
    }

    setState(() {
      _getProgressTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _getAllProgressTasks,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.statusProgress,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'In Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_progressTaskList.length} tasks',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _getProgressTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                child: _progressTaskList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timelapse_rounded,
                                size: 64,
                                color: AppColors.textHint.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              'No tasks in progress',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: _progressTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: _progressTaskList[index],
                            refreshParent: () => _getAllProgressTasks(),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
