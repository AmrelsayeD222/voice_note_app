import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/edit_task/edit_task_cubit.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';
import 'package:voice_note_app/feature/ui/widgets/action_icon_bottom.dart';
import 'package:voice_note_app/feature/ui/widgets/delete_task_dialog.dart';
import 'package:voice_note_app/feature/ui/widgets/etit_task_dialog.dart';

class WritenNoteCard extends StatelessWidget {
  const WritenNoteCard({
    super.key,
    required this.task,
  });

  final Datamodel task;

  @override
  Widget build(BuildContext context) {
    bool discrption = task.description.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (discrption)
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionIconButton(
                  icon: Icons.edit_rounded,
                  color: Colors.indigo,
                  onPressed: () {
                    context.read<EditTaskCubit>().setInitialValues(task);
                    showDialog(
                      context: context,
                      builder: (context) => EditTaskDialog(datamodel: task),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ActionIconButton(
                  icon: Icons.delete_rounded,
                  color: Colors.redAccent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteTaskDialog(datamodel: task),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
