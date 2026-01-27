import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_app/feature/data/model/datamodel.dart';
import 'package:sqflite_app/feature/data/manager/add_task/add_task_cubit.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    AddTaskCubit addTaskCubit = context.read<AddTaskCubit>();
    return AlertDialog(
      title: const Column(
        children: [
          Icon(Icons.add_task, color: Colors.indigo, size: 32),
          SizedBox(height: 12),
          Text('Create New Task'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: addTaskCubit.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: addTaskCubit.titleController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                  prefixIcon: Icon(Icons.title, size: 20, color: Colors.indigo),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addTaskCubit.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Task Description',
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
          child: const Text('Discard', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (addTaskCubit.formKey.currentState!.validate()) {
              addTaskCubit.addTask(
                Datamodel(
                  title: addTaskCubit.titleController.text,
                  description: addTaskCubit.descriptionController.text,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create Task'),
        ),
      ],
    );
  }
}
