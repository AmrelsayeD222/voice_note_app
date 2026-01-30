import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/edit_task/edit_task_cubit.dart';
import 'package:voice_note_app/feature/data/manager/fatch_data/fetch_data_cubit.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';

class VoiceTitleEditDialog extends StatelessWidget {
  const VoiceTitleEditDialog({super.key, required this.task});
  final Datamodel task;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: task.title);
    return AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.edit_note_rounded, color: Colors.indigo, size: 32),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Edit Note Info'),
            ),
          ],
        ),
        content: TextFormField(
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Title cannot be empty';
            }
            return null;
          },
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.title, size: 20, color: Colors.indigo),
            hintText: 'Enter new title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty && newTitle != task.title) {
                final updatedTask = task.copyWith(title: newTitle);
                await context.read<EditTaskCubit>().editTask(updatedTask);
                if (context.mounted) {
                  context.read<FetchDataCubit>().fetchData();
                }
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ]);
  }
}
