import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_app/feature/data/model/datamodel.dart';
import 'package:sqflite_app/feature/data/manager/delete_task/delete_task_cubit.dart';

class DeleteTaskDialog extends StatelessWidget {
  final Datamodel datamodel;
  const DeleteTaskDialog({super.key, required this.datamodel});

  @override
  Widget build(BuildContext context) {
    DeleteTaskCubit deleteTaskCubit = context.read<DeleteTaskCubit>();
    return AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () async {
            deleteTaskCubit.deleteTask(datamodel);
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
