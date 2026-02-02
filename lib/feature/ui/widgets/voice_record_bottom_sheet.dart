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
    // 1. Initial values for the 'Ready' state
    String text = 'Ready to record';
    Color color = Colors.grey;
    IconData icon = Icons.mic;
    bool isRecording = false;

    // 2. Change values based on current state (Easy to read if-else)
    if (state is VoiceRecordLoading) {
      text = 'Recording...';
      color = Colors.red;
      isRecording = true;
    } else if (state is VoiceRecordSuccess) {
      text = 'Recorded successfully!';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (state is VoiceRecordPaused) {
      text = 'Recording paused';
      color = Colors.orange;
      icon = Icons.pause_circle_filled;
    } else if (state is VoiceRecordFailure) {
      text = state.message;
      color = Colors.red;
      icon = Icons.error;
    }

    // 3. Simple UI using Container and Row
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording)
            const _SimplePulseDot()
          else
            Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Simple stateful widget for the pulsing red dot
class _SimplePulseDot extends StatefulWidget {
  const _SimplePulseDot();
  @override
  State<_SimplePulseDot> createState() => _SimplePulseDotState();
}

class _SimplePulseDotState extends State<_SimplePulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // repeat the animation forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
