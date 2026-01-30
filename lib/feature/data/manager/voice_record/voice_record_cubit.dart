import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

part 'voice_record_state.dart';

class VoiceRecordCubit extends Cubit<VoiceRecordState> {
  final AudioRecorder _record = AudioRecorder();

  DateTime? _startTime;

  VoiceRecordCubit() : super(VoiceRecordInitial());

  // ========================
  // 🎤 Start Recording
  // ========================
  Future<void> startRecord() async {
    try {
      emit(VoiceRecordLoading());

      // 🎙 Permission
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        emit(const VoiceRecordFailure(message: 'Microphone permission denied'));
        return;
      }

      // 🎛 Recorder permission
      final canRecord = await _record.hasPermission();
      if (!canRecord) {
        emit(const VoiceRecordFailure(message: 'Recorder permission error'));
        return;
      }

      // 📁 File path
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      _startTime = DateTime.now();

      // ▶ Start record
      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
    } catch (_) {
      emit(const VoiceRecordFailure(
          message: 'Unexpected error while starting recording'));
    }
  }

  // ========================
  // ⏸ Pause Recording
  // ========================
  Future<void> pauseRecord() async {
    try {
      if (await _record.isRecording()) {
        await _record.pause();
        emit(VoiceRecordPaused());
      }
    } catch (_) {
      emit(const VoiceRecordFailure(message: 'Failed to pause recording'));
    }
  }

  // ========================
  // ▶ Resume Recording
  // ========================
  Future<void> resumeRecord() async {
    try {
      if (await _record.isPaused()) {
        await _record.resume();
        emit(VoiceRecordLoading());
      }
    } catch (_) {
      emit(const VoiceRecordFailure(message: 'Failed to resume recording'));
    }
  }

  // ========================
  // ⏹ Stop Recording
  // ========================
  Future<void> stopRecord() async {
    try {
      if (!await _record.isRecording()) return;

      final path = await _record.stop();

      if (path == null || path.isEmpty || !File(path).existsSync()) {
        emit(const VoiceRecordFailure(message: 'Recording file not found'));
        return;
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(_startTime ?? endTime);

      emit(
        VoiceRecordSuccess(
          path: path,
          duration: duration,
          createdAt: endTime,
        ),
      );
    } catch (_) {
      emit(const VoiceRecordFailure(message: 'Failed to stop recording'));
    }
  }

  // ========================
  // ❌ Cancel Recording
  // ========================
  Future<void> cancelRecord() async {
    try {
      final path = await _record.stop();
      if (path != null && File(path).existsSync()) {
        File(path).deleteSync(); // delete file
      }
      emit(VoiceRecordInitial());
    } catch (_) {
      emit(const VoiceRecordFailure(message: 'Failed to cancel recording'));
    }
  }

  Future<void> reset() async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(VoiceRecordInitial());
  }

  // ========================
  // 🧹 Dispose
  // ========================
  @override
  Future<void> close() {
    _record.dispose();
    return super.close();
  }
}
