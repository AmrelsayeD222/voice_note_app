import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/audio_player/audio_player_cubit.dart';
import 'package:voice_note_app/feature/data/model/datamodel.dart';
import 'package:voice_note_app/feature/ui/widgets/indicator_widget.dart';

class VoicePlayerBottom extends StatelessWidget {
  const VoicePlayerBottom({
    super.key,
    required this.task,
  });

  final Datamodel task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        final isPlaying = state is AudioPlaying && state.path == task.audioPath;
        final isPaused = state is AudioPaused && state.path == task.audioPath;

        final position = isPlaying
            ? (state).position
            : (isPaused ? (state).position : Duration.zero);

        final duration = isPlaying
            ? (state).duration
            : (isPaused ? (state).duration : Duration.zero);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 30,
              icon: isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              color: isPlaying ? Colors.orange : Colors.indigo,
              onPressed: () {
                if (task.audioPath != null) {
                  context.read<AudioPlayerCubit>().togglePlay(task.audioPath!);
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorWidget(
                  duration: duration,
                  position: position,
                  timeStyle: const TextStyle(fontSize: 11, color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
