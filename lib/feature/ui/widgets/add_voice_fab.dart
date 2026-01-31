import 'package:flutter/material.dart';
import 'package:voice_note_app/feature/ui/widgets/voice_record_bottom_sheet.dart';

class AddVoiceFAB extends StatelessWidget {
  const AddVoiceFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'add_voice_fab',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const VoiceRecordBottomSheet(),
        );
      },
      icon: const Icon(Icons.mic),
      label: const Text('Voice Note'),
    );
  }
}
