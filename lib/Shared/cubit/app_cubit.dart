import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Modules/archiveTasks/archive_task.dart';
import 'package:todo_app/Modules/doneTasks/done_task.dart';
import 'package:todo_app/Modules/newTasks/new_task.dart';

part 'app__state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());


  static AppCubit get(context)=>BlocProvider.of(context);
  //cuz i will listen on them
  int selectedIndex = 0;
  Database? database;
  List<Map>tasks=[];
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
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


  createDatabase()  {
    return openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        debugPrint('database created');
        await db
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)',
        )
            .then((value) {
          debugPrint('Table Created');
        }).catchError((er) {
          debugPrint('Error when creating table ${er.toString()}');
        });
      },
      onOpen: (db) {
        debugPrint('Database opened');
        getFromDatabase(db).then((value) {
         tasks=value;
         emit(AppGetFromDatabaseState());
         print(tasks);
        }
        );
      },
    ).then((value)
    {
      database=value;
      emit(AppCreateDatabaseState());
    }
    );
  }

  Future<List<Map>> getFromDatabase(Database db) async {
    emit(AppLoadingState());
    return await db.rawQuery('SELECT * FROM tasks');
  }

 insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        debugPrint('$value Inserted successfully');
        emit(AppInsertIntoDatabaseState());
        //i want to get data after i insert
        getFromDatabase(database!).then((value) {
          tasks=value;
          emit(AppGetFromDatabaseState());
        });
        }).catchError((er) {
        debugPrint('Error when insert into table ${er.toString()}');
      });
    });
  }

  void changeBottomSheet({required bool isShow,required IconData icon})
  {
    isBottomSheetShow=isShow;
    fabIcon=icon;
    emit(AppChangeIconAndBottomSheetState());
  }

}

