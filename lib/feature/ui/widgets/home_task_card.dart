import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_app/feature/data/model/datamodel.dart';
import 'package:sqflite_app/feature/data/manager/edit_task/edit_task_cubit.dart';
import 'package:sqflite_app/feature/ui/widgets/delete_task_dialog.dart';
import 'package:sqflite_app/feature/ui/widgets/etit_task_dialog.dart';

class HomeTaskCard extends StatelessWidget {
  final Datamodel task;
  const HomeTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Future feature: View full task details
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.indigo),
                  onPressed: () {
                    context.read<EditTaskCubit>().setInitialValues(task);
                    showDialog(
                      context: context,
                      builder: (context) => EditTaskDialog(datamodel: task),
                    );
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteTaskDialog(datamodel: task),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
