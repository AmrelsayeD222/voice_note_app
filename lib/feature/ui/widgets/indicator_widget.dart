import 'package:flutter/material.dart';
import 'package:voice_note_app/feature/ui/widgets/format_duration.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.duration,
    required this.position,
    required TextStyle timeStyle,
  }) : _timeStyle = timeStyle;

  final Duration duration;
  final Duration position;
  final TextStyle _timeStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: duration.inSeconds > 0
              ? position.inSeconds / duration.inSeconds
              : 0,
          backgroundColor: Colors.grey[200],
          color: Colors.indigo,
          minHeight: 3,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDuration(position), style: _timeStyle),
            if (duration > Duration.zero)
              Text(formatDuration(duration), style: _timeStyle),
          ],
        ),
      ],
    );
  }
}
