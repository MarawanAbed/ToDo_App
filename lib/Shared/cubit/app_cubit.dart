import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/Modules/archiveTasks/archive_task.dart';
import 'package:todo_app/Modules/doneTasks/done_task.dart';
import 'package:todo_app/Modules/newTasks/new_task.dart';

part 'app__state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context)=>BlocProvider.of(context);
  //cuz i will listen on them
  int selectedIndex = 0;


  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchiveTasks(),
  ];
  List<String> names = [
    'NewTasks',
    'DoneTasks',
    'ArchiveTasks',
  ];
  void onItemTapped(int index) {
    selectedIndex = index;
    emit(AppChangeBottom());
  }
}
