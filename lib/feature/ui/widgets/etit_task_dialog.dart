import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';
import 'package:voice_note_app/feature/data/manager/edit_task/edit_task_cubit.dart';

class EditTaskDialog extends StatelessWidget {
  final Datamodel datamodel;
  const EditTaskDialog({super.key, required this.datamodel});

  @override
  Widget build(BuildContext context) {
    EditTaskCubit editTaskCubit = context.read<EditTaskCubit>();
    return AlertDialog(
      title: const Column(
        children: [
          Icon(Icons.edit_note_rounded, color: Colors.indigo, size: 32),
          SizedBox(height: 12),
          Text('Edit Task Info'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: editTaskCubit.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: editTaskCubit.titleController,
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                  prefixIcon: Icon(Icons.title, size: 20, color: Colors.indigo),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: editTaskCubit.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Task description',
                  prefixIcon:
                      Icon(Icons.description, size: 20, color: Colors.indigo),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
            if (editTaskCubit.formKey.currentState!.validate()) {
              editTaskCubit.editTask(
                Datamodel(
                  id: datamodel.id,
                  title: editTaskCubit.titleController.text,
                  description: editTaskCubit.descriptionController.text,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
