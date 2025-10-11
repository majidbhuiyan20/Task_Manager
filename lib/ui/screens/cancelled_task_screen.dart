import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    _getAllCancelledTasks();
  }

  Future<void> _getAllCancelledTasks() async {
    setState(() {
      _getCancelledTaskInProgress = true;

    });

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.cancelledTaskListUrl);

    if (response.isSuccess && response.responseData['data'] != null) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? "Something went wrong!", Colors.red);
      }
    }

    setState(() {
      _getCancelledTaskInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Visibility(
          visible: _getCancelledTaskInProgress==false,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: _cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(taskModel: _cancelledTaskList[index], refreshParent: () { _getAllCancelledTasks(); },);
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
