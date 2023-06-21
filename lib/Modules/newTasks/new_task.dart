import 'package:flutter/material.dart';
import 'package:todo_app/Shared/Components/components.dart';
import 'package:todo_app/Shared/Constant/constant.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key,  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index)
        {
          return buildTaskItem(tasks[index]);
        },
        separatorBuilder: (context,index)=>Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length
    );
  }
}
