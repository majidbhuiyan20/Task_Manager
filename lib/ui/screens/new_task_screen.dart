import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/model/task_status_count_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import '../widgets/task_cout_by_status_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskStatusCountInProgress = false;
  bool _getNewTaskInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTasks();
  }

  Future<void> _getAllTaskStatusCount() async {
    setState(() {
      _getTaskStatusCountInProgress = true;
    });

    ApiResponse response =
        await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      setState(() {
        _taskStatusCountList = list;
      });
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Something went wrong!", AppColors.statusCancelled);
      }
    }

    setState(() {
      _getTaskStatusCountInProgress = false;
    });
  }

  Future<void> _getAllNewTasks() async {
    setState(() {
      _getNewTaskInProgress = true;
    });

    ApiResponse response =
        await ApiCaller.getRequest(url: Urls.newTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      setState(() {
        _newTaskList = list;
      });
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? "Something went wrong!", AppColors.statusCancelled);
      }
    }

    setState(() {
      _getNewTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await _getAllTaskStatusCount();
          await _getAllNewTasks();
        },
        child: Column(
          children: [
            // Status count cards
            Container(
              height: 110,
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Visibility(
                visible: _getTaskStatusCountInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => TaskCountByStatusCard(
                    title: _taskStatusCountList[index].status,
                    count: _taskStatusCountList[index].count,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                ),
              ),
            ),
            // Section header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'New Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_newTaskList.length} tasks',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Task list
            Expanded(
              child: Visibility(
                visible: _getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                child: _newTaskList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_rounded,
                                size: 64,
                                color: AppColors.textHint.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              'No new tasks',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textHint,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tap + to add a new task',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: _newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: _newTaskList[index],
                            refreshParent: () {
                              _getAllNewTasks();
                              _getAllTaskStatusCount();
                            },
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: _onTapAddNewTaskButton,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }
}
