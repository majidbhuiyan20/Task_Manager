import 'package:flutter/material.dart';

import '../../data/model/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import '../widgets/task_cout_by_status_card.dart';

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
    // TODO: implement initState
    super.initState();
    _getAllProgressTasks();
  }

  Future<void> _getAllProgressTasks() async {
    setState(() {
      _getProgressTaskInProgress = true;

    });

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.progressTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? "Something went wrong!", Colors.red);
      }
    }

    setState(() {
      _getProgressTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Visibility(
          visible: _getProgressTaskInProgress==false,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: _progressTaskList.length,
            itemBuilder: (context, index) {
               return TaskCard(taskModel: _progressTaskList[index], refreshParent: () { _getAllProgressTasks(); },);
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
