import 'package:flutter/material.dart';

import 'package:voice_note_app/feature/data/model/datamodel.dart';
import 'package:voice_note_app/feature/ui/widgets/delete_task_dialog.dart';
import 'package:voice_note_app/feature/ui/widgets/voice_player_bottom.dart';
import 'package:voice_note_app/feature/ui/widgets/voice_title_edit_dialog.dart';

class VoiceNoteCard extends StatelessWidget {
  final Datamodel task;
  const VoiceNoteCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title.isEmpty ? 'Untitled Voice Note' : task.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded,
                    color: Colors.indigo, size: 20),
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => VoiceTitleEditDialog(task: task)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded,
                    size: 20, color: Colors.redAccent),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteTaskDialog(datamodel: task),
                  );
                },
              ),
            ],
          ),
          Text(
            task.description, // recording time
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 16),
          VoicePlayerBottom(task: task),
        ],
      ),
    );
  }
}
