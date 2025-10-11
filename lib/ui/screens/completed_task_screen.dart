import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../data/model/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCompletedTasks();
  }

  Future<void> _getAllCompletedTasks() async {
    setState(() {
      _getCompletedTaskInProgress = true;

    });

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.completedTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? "Something went wrong!", Colors.red);
      }
    }

    setState(() {
      _getCompletedTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Visibility(
          visible: _getCompletedTaskInProgress==false,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: _completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(taskModel: _completedTaskList[index], refreshParent: () { _getAllCompletedTasks(); },);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
          ),
        ),
      ),

    );
  }
}
