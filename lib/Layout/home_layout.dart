import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Modules/archiveTasks/archive_task.dart';
import 'package:todo_app/Modules/doneTasks/done_task.dart';
import 'package:todo_app/Modules/newTasks/new_task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Shared/Components/components.dart';
import 'package:path/path.dart';
import 'package:todo_app/Shared/Constant/constant.dart';


class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isBottomSheetShow = false;
  List<Widget> screens = [
    const NewTasks(

    ),
    const DoneTasks(),
    const ArchiveTasks(),
  ];
  List<String> names = [
    'NewTasks',
    'DoneTasks',
    'ArchiveTasks',
  ];
  IconData fabIcon = Icons.edit;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    openAndCreateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(names.elementAt(_selectedIndex)),
      ),
      body: ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (BuildContext context)
          {
            return screens.elementAt(_selectedIndex);
          },
          fallback: (BuildContext context)
          {
            return const Center(child: CircularProgressIndicator());
          },
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShow) {
            if(formKey.currentState!.validate())
            {
              insertIntoDatabase(
                title:titleController.text ,
                time: timeController.text,
                date: dateController.text
              ).then((value)
              {
                getFromDatabase(database!).then((value)
                {
                  Navigator.pop(context);
                  isBottomSheetShow = false;
                  setState(() {
                    tasks=value;
                    fabIcon = Icons.edit;
                  });
                },
                );
              }
              );
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
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
                              initialTime: TimeOfDay.now()
                          ).then((value)
                          {
                            timeController.text=value!.format(context);
                          }
                          );
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
                          ).then((value)
                          {
                            dateController.text=DateFormat.yMMMd().format(value!);
                          }
                          );
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
            ).closed.then((value)
            {
              //i close it automatically with my hand
              isBottomSheetShow = false;
              setState(() {
                fabIcon = Icons.edit;
              });
              //to avoid error when i closed with my hand cuz i try to validate when the bottom sheet is closed
              //so i make it in the case of close it with my hand
            }
            );
            isBottomSheetShow = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
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
                _onItemTapped(0);
              },
              color: _selectedIndex == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                _onItemTapped(1);
              },
              color: _selectedIndex == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              onPressed: () {
                _onItemTapped(2);
              },
              color: _selectedIndex == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        debugPrint('database created');
        await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)',
        ).then((value) {
          debugPrint('Table Created');
        }).catchError((er) {
          debugPrint('Error when creating table ${er.toString()}');
        });
      },
      onOpen: (db) {
        debugPrint('Database opened');
        getFromDatabase(db);
      },
    );
  }
  //to ensure the necessary initialization is done before opening the database
  Future<void> openAndCreateDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasesPath = await getDatabasesPath();
    //calling getDatabase to obtain the path where the database should be stored
    final path = join(databasesPath!, 'todo.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        debugPrint('database created');
        await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)',
        ).then((value) {
          debugPrint('Table Created');
        }).catchError((er) {
          debugPrint('Error when creating table ${er.toString()}');
        });
      },
      onOpen: (db) {
        debugPrint('Database opened');
        getFromDatabase(db).then((value)
        {
            tasks=value;
        }
        );
      },
    );
  }

  Future<List<Map>> getFromDatabase(Database db) async {
    return await db.rawQuery('SELECT * FROM tasks');
  }

  Future<dynamic> insertIntoDatabase(
  {
    required String title,
    required String time,
    required String date,
  }
  ) async {
     return await database!.transaction((txn) async {
        await txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
           .then((value) {
          debugPrint('$value Inserted successfully');
        }).catchError((er) {
          debugPrint('Error when insert into table ${er.toString()}');
        });
      });
    }


}
