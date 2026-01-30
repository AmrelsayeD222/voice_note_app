import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/core/helper/database.dart';
import 'package:voice_note_app/feature/data/manager/add_task/add_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/delete_task/delete_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/edit_task/edit_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/fatch_data/fetch_data_cubit.dart';
import 'package:voice_note_app/feature/data/manager/voice_record/voice_record_cubit.dart';
import 'package:voice_note_app/feature/data/manager/audio_player/audio_player_cubit.dart';

import 'feature/ui/views/home_view.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchDataCubit(
            DatabaseHelper(),
          )..fetchData(),
        ),
        BlocProvider(
          create: (context) => AddTaskCubit(DatabaseHelper()),
        ),
        BlocProvider(
          create: (context) => EditTaskCubit(DatabaseHelper()),
        ),
        BlocProvider(
          create: (context) => DeleteTaskCubit(DatabaseHelper()),
        ),
        BlocProvider(
          create: (context) => VoiceRecordCubit(),
        ),
        BlocProvider(
          create: (context) => AudioPlayerCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Voice Note App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeView(),
      ),
    );
  }
}
