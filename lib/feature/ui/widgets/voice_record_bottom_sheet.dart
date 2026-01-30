import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/voice_record/voice_record_cubit.dart';
import 'package:voice_note_app/feature/ui/widgets/dialog_action_btn.dart';

class VoiceRecordBottomSheet extends StatelessWidget {
  const VoiceRecordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
      builder: (context, state) {
        final cubit = context.read<VoiceRecordCubit>();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const Text(
                  'Voice Recorder',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                // status text
                _buildStatus(state),

                const SizedBox(height: 24),

                // buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Start / Stop
                    if (state is VoiceRecordInitial ||
                        state is VoiceRecordFailure)
                      DialogActionBtn(
                        icon: Icons.fiber_manual_record,
                        color: Colors.red,
                        label: 'Start',
                        onTap: () => cubit.startRecord(),
                      )
                    else
                      DialogActionBtn(
                        icon: Icons.stop,
                        color: Colors.blue,
                        label: 'Stop',
                        onTap: () {
                          cubit.stopRecord();
                          cubit.reset();

                          Navigator.pop(context);
                        },
                      ),

                    // Pause / Resume
                    if (state is VoiceRecordPaused)
                      DialogActionBtn(
                        icon: Icons.play_arrow,
                        color: Colors.green,
                        label: 'Resume',
                        onTap: () => cubit.resumeRecord(),
                      )
                    else
                      DialogActionBtn(
                        icon: Icons.pause,
                        color: Colors.orange,
                        label: 'Pause',
                        onTap: () => cubit.pauseRecord(),
                      ),

                    // Cancel
                    DialogActionBtn(
                      icon: Icons.close,
                      color: Colors.grey,
                      label: 'Cancel',
                      onTap: () {
                        cubit.cancelRecord();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatus(VoiceRecordState state) {
    if (state is VoiceRecordLoading) {
      return const Text('Recording...');
    } else if (state is VoiceRecordSuccess) {
      return const Text('Recorded successfully ✅');
    } else if (state is VoiceRecordPaused) {
      return const Text('Recording paused');
    } else if (state is VoiceRecordFailure) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return const Text('Ready to record');
    }
  }
}
