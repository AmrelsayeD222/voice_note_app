part of 'audio_player_cubit.dart';

sealed class AudioPlayerState extends Equatable {
  const AudioPlayerState();

  @override
  List<Object?> get props => [];
}

final class AudioInitial extends AudioPlayerState {}

final class AudioPlaying extends AudioPlayerState {
  final String path;
  final Duration position;
  final Duration duration;

  const AudioPlaying({
    required this.path,
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [path, position, duration];
}

final class AudioPaused extends AudioPlayerState {
  final String path;
  final Duration position;
  final Duration duration;

  const AudioPaused({
    required this.path,
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [path, position, duration];
}

final class AudioStopped extends AudioPlayerState {
  final String path;
  const AudioStopped({required this.path});

  @override
  List<Object?> get props => [path];
}
