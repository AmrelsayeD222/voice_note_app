part of 'voice_record_cubit.dart';

sealed class VoiceRecordState extends Equatable {
  const VoiceRecordState();

  @override
  List<Object> get props => [];
}

final class VoiceRecordInitial extends VoiceRecordState {}

final class VoiceRecordLoading extends VoiceRecordState {}

final class VoiceRecordPaused extends VoiceRecordState {}

final class VoiceRecordSuccess extends VoiceRecordState {
  final String path;
  final Duration duration;
  final DateTime createdAt;

  const VoiceRecordSuccess({
    required this.path,
    required this.duration,
    required this.createdAt,
  });
}

final class VoiceRecordFailure extends VoiceRecordState {
  final String message;

  const VoiceRecordFailure({required this.message});
}
