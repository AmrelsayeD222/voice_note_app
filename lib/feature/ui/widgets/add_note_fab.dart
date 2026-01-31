import 'package:flutter/material.dart';
import 'package:voice_note_app/feature/ui/widgets/add_task_dialog.dart';

class AddNoteFAB extends StatelessWidget {
  const AddNoteFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'add_note_fab',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AddTaskDialog(),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Task'),
    );
  }
}
