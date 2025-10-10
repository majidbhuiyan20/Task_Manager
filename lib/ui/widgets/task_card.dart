
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel, required this.refreshParent,
  });

  final TaskModel taskModel;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _changeStatusINProgress = false;

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
                label: const Text(
                  "New",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              const Spacer(),
              Visibility(
                visible: _changeStatusINProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: IconButton(
                    onPressed: () {
                      _showChangeStatusDialog();
                    },
                    icon: const Icon(Icons.edit)),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          )
        ],
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: const Text("Change Status"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      _changeStatus("New");
                    },
                    title: const Text("New"),
                    trailing: widget.taskModel.status == "New" ? const Icon(Icons.done, color: Colors.green,) : null,
                  ),
                  ListTile(
                    onTap: () {
                      _changeStatus("Progress");
                    },
                    title: const Text("Progress"),
                    trailing: widget.taskModel.status == "Progress" ? const Icon(Icons.done, color: Colors.green,) : null,
                  ),
                  ListTile(
                    onTap: () {
                      _changeStatus("Cancelled");
                    },
                    title: const Text("Cancelled"),
                    trailing: widget.taskModel.status == "Cancelled" ? const Icon(Icons.done, color: Colors.green,) : null,
                  ),
                  ListTile(
                    onTap: () {
                      _changeStatus("Completed");
                    },
                    title: const Text("Completed"),
                    trailing: widget.taskModel.status == "Completed" ? const Icon(Icons.done, color: Colors.green,) : null,
                  ),
                ],
              ));
        });


  }
  Future<void> _changeStatus(String status)async{

    Navigator.pop(context);

    if(status == widget.taskModel.status){
      return;
    }

    _changeStatusINProgress = true;
    setState(() {

    });
    final ApiResponse response = await ApiCaller.getRequest(url: Urls.updateTaskStatusUrls(widget.taskModel.id, status));
    _changeStatusINProgress = false;
    if(response.isSuccess){
        widget.refreshParent();
    }
    else{
      showSnackBarMessage(context, response.errorMessage!, Colors.red);
    }

  }
}
