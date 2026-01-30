import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/add_task/add_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/delete_task/delete_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/edit_task/edit_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/fatch_data/fetch_data_cubit.dart';

import 'package:voice_note_app/feature/data/manager/voice_record/voice_record_cubit.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;
  const HomeListeners({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VoiceRecordCubit, VoiceRecordState>(
          listener: (context, state) {
            if (state is VoiceRecordSuccess) {
              context.read<AddTaskCubit>().addTask(
                    Datamodel(
                      title: 'Voice Note',
                      description:
                          'Recorded at ${state.createdAt.hour}:${state.createdAt.minute}',
                      audioPath: state.path,
                    ),
                  );
            } else if (state is VoiceRecordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<AddTaskCubit, AddTaskState>(
          listener: (context, state) {
            if (state is AddTaskSuccess) {
              context.read<FetchDataCubit>().fetchData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added successfully')),
              );
            } else if (state is AddTaskFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<EditTaskCubit, EditTaskState>(
          listener: (context, state) {
            if (state is EditTaskSuccess) {
              context.read<FetchDataCubit>().fetchData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task edited successfully')),
              );
            } else if (state is EditTaskFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<DeleteTaskCubit, DeleteTaskState>(
          listener: (context, state) {
            if (state is DeleteTaskSuccess) {
              context.read<FetchDataCubit>().fetchData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted successfully')),
              );
            } else if (state is DeleteTaskFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
