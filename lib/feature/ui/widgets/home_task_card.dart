import 'package:flutter/material.dart';

import 'package:voice_note_app/feature/data/model/datamodel.dart';
import 'package:voice_note_app/feature/ui/widgets/voice_note_card.dart';
import 'package:voice_note_app/feature/ui/widgets/writen_note_card.dart';

class HomeTaskCard extends StatelessWidget {
  final Datamodel task;
  const HomeTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final hasAudio = task.audioPath != null && task.audioPath!.isNotEmpty;

    return hasAudio ? VoiceNoteCard(task: task) : WritenNoteCard(task: task);
  }
}
