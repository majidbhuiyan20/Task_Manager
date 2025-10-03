import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_status_count_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

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
  List<TaskStatusCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
  }

  Future<void> _getAllTaskStatusCount() async {
    setState(() {
      _getTaskStatusCountInProgress = true;
    });

    ApiResponse response = await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);

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
        showSnackBarMessage(context, response.errorMessage ?? "Something went wrong!", Colors.red);
      }
    }

    setState(() {
      _getTaskStatusCountInProgress = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Visibility(
                visible: _getTaskStatusCountInProgress == false,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.separated(
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      TaskCountByStatusCard(
                          title: _taskStatusCountList[index].status ,
                          count: _taskStatusCountList[index].count),
                  separatorBuilder: (context, index) => SizedBox(width: 8),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return TaskCard();
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _onTapAddNewTaskButton();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  void _onTapAddNewTaskButton(){
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }
}
