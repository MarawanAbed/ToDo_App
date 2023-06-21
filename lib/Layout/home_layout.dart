import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Shared/Components/components.dart';
import 'package:todo_app/Shared/cubit/app_cubit.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state)
      {
        if(state is AppInsertIntoDatabaseState)
        {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.names.elementAt(cubit.selectedIndex)),
          ),
          body: ConditionalBuilder(
            condition: state is! AppLoadingState,
            builder: (BuildContext context) {
              return cubit.screens.elementAt(cubit.selectedIndex);
            },
            fallback: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
                if (formKey.currentState!.validate()) {
                  cubit.insertIntoDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text
                  );
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[100],
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Title must be written';
                                  }
                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'time must be written';
                                  }
                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2025-05-06'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'date must be written';
                                  }
                                  return null;
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  //i close it automatically with my hand
                  cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  //to avoid error when i closed with my hand cuz i try to validate when the bottom sheet is closed
                  //so i make it in the case of close it with my hand
                });
                cubit.changeBottomSheet(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.only(right: 40),
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.task),
                  onPressed: () {
                    cubit.onItemTapped(0);
                  },
                  color: cubit.selectedIndex == 0
                      ? Theme
                      .of(context)
                      .primaryColor
                      : Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () {
                    cubit.onItemTapped(1);
                  },
                  color: cubit.selectedIndex == 1
                      ? Theme
                      .of(context)
                      .primaryColor
                      : Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.archive_outlined),
                  onPressed: () {
                    cubit.onItemTapped(2);
                  },
                  color: cubit.selectedIndex == 2
                      ? Theme
                      .of(context)
                      .primaryColor
                      : Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
