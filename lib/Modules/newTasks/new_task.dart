
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Shared/Components/components.dart';
import 'package:todo_app/Shared/cubit/app__state.dart';
import 'package:todo_app/Shared/cubit/app_cubit.dart';

class NewTasksScreen extends StatelessWidget
{
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).newTasks;

        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}