import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPath;
  StreamSubscription? _streamSub;

  AudioPlayerCubit() : super(AudioInitial()) {
    // 🔗 Single subscription to handle all player events
    _streamSub = _player.playbackEventStream.listen((event) {
      _emitCurrentState();
    }, onError: (e) {
      emit(AudioInitial());
    });

    // 🕒 Specific listener for position to ensure UI progress
    _player.positionStream.listen((pos) {
      _emitCurrentState();
    });

    // ✅ Listen for completion to reset
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  void _emitCurrentState() {
    if (_currentPath == null) return;

    final pos = _player.position;
    final dur = _player.duration ?? Duration.zero;

    if (_player.playing) {
      emit(AudioPlaying(path: _currentPath!, position: pos, duration: dur));
    } else {
      // If we have a current path but not playing, it's paused or stopped
      if (_player.processingState != ProcessingState.idle) {
        emit(AudioPaused(path: _currentPath!, position: pos, duration: dur));
      }
    }
  }

  Future<void> togglePlay(String path) async {
    try {
      if (_currentPath == path) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      // New file logic
      await _player.stop();
      _currentPath = path;

      // Emit playing state immediately with zero duration to give UI feedback
      emit(AudioPlaying(
          path: path, position: Duration.zero, duration: Duration.zero));

      // Load and play
      await _player.setFilePath(path);
      await _player.play();

      // Final emission to ensure duration is correct
      _emitCurrentState();
    } catch (_) {
      emit(AudioInitial());
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      await _player.seek(Duration.zero);
      if (_currentPath != null) {
        emit(AudioStopped(path: _currentPath!));
      }
      _currentPath = null;
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _streamSub?.cancel();
    _player.dispose();
    return super.close();
  }
}
