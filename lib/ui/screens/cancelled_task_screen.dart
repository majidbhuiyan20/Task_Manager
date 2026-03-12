import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../data/model/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCancelledTasks();
  }

  Future<void> _getAllCancelledTasks() async {
    setState(() {
      _getCancelledTaskInProgress = true;
    });

    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.cancelledTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Something went wrong!", AppColors.statusCancelled);
      }
    }

    setState(() {
      _getCancelledTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _getAllCancelledTasks,
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
                      color: AppColors.statusCancelled,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Cancelled Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_cancelledTaskList.length} tasks',
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
                visible: _getCancelledTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                child: _cancelledTaskList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel_outlined,
                                size: 64,
                                color: AppColors.textHint.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              'No cancelled tasks',
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
                        itemCount: _cancelledTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: _cancelledTaskList[index],
                            refreshParent: () => _getAllCancelledTasks(),
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
