
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: Colors.white,
      title: Text(taskModel.title),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(taskModel.description),
          Text(taskModel.createDate, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
          Row(
            children: [
              Chip(label: Text("New", style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              Spacer(),
              IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
              IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.red,)),
            ],
          )
        ],
      ),
    );
  }
}
