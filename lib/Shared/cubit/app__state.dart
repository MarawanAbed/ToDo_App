part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppChangeBottom extends AppState{}

class AppCreateDatabaseState extends AppState{}

class AppInsertIntoDatabaseState extends AppState{}

class AppGetFromDatabaseState extends AppState{}

class AppChangeIconAndBottomSheetState extends AppState{}

class AppLoadingState extends AppState{}
