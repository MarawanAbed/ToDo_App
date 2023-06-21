import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Shared/Components/components.dart';
import 'package:todo_app/Shared/cubit/app_cubit.dart';


class NewTasks extends StatelessWidget {
  const NewTasks({super.key,});

  @override
  Widget build(BuildContext context) {
    var cubit=AppCubit.get(context);
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return buildTaskItem(cubit.tasks[index]);
            },
            separatorBuilder: (context, index) =>
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
            itemCount: cubit.tasks.length
        );
      },
    );
  }
}
