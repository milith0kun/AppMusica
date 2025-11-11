import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/services/audio_service.dart';
import '../../data/models/song_model.dart';

// Audio Player State
class AudioPlayerState {
  final SongModel? currentSong;
  final List<SongModel> playlist;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final LoopMode loopMode;
  final bool shuffleMode;

  const AudioPlayerState({
    this.currentSong,
    this.playlist = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.loopMode = LoopMode.off,
    this.shuffleMode = false,
  });

  AudioPlayerState copyWith({
    SongModel? currentSong,
    List<SongModel>? playlist,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    LoopMode? loopMode,
    bool? shuffleMode,
  }) {
    return AudioPlayerState(
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      loopMode: loopMode ?? this.loopMode,
      shuffleMode: shuffleMode ?? this.shuffleMode,
    );
  }
}

// Audio Player Notifier
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayerService _audioService;

  AudioPlayerNotifier(this._audioService) : super(const AudioPlayerState()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    // Listen to playing state
    _audioService.playingStream.listen((playing) {
      state = state.copyWith(isPlaying: playing);
    });

    // Listen to position
    _audioService.positionStream.listen((position) {
      if (position != null) {
        state = state.copyWith(position: position);
      }
    });

    // Listen to duration
    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });
  }

  Future<void> playSong(SongModel song, {List<SongModel>? queue}) async {
    await _audioService.playSong(song, queue: queue);
    state = state.copyWith(
      currentSong: song,
      playlist: queue ?? [song],
      currentIndex: queue?.indexWhere((s) => s.id == song.id) ?? 0,
    );
  }

  Future<void> playPlaylist(List<SongModel> songs, {int startIndex = 0}) async {
    await _audioService.playPlaylist(songs, startIndex: startIndex);
    state = state.copyWith(
      playlist: songs,
      currentIndex: startIndex,
      currentSong: songs[startIndex],
    );
  }

  Future<void> play() async {
    await _audioService.play();
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  Future<void> skipToNext() async {
    await _audioService.skipToNext();
    state = state.copyWith(
      currentIndex: _audioService.currentIndex,
      currentSong: _audioService.currentSong,
    );
  }

  Future<void> skipToPrevious() async {
    await _audioService.skipToPrevious();
    state = state.copyWith(
      currentIndex: _audioService.currentIndex,
      currentSong: _audioService.currentSong,
    );
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _audioService.setLoopMode(mode);
    state = state.copyWith(loopMode: mode);
  }

  Future<void> setShuffleMode(bool enabled) async {
    await _audioService.setShuffleModeEnabled(enabled);
    state = state.copyWith(shuffleMode: enabled);
  }

  void addToQueue(SongModel song) {
    _audioService.addToQueue(song);
    state = state.copyWith(playlist: _audioService.playlist);
  }

  void removeFromQueue(int index) {
    _audioService.removeFromQueue(index);
    state = state.copyWith(
      playlist: _audioService.playlist,
      currentIndex: _audioService.currentIndex,
    );
  }
}

// Audio Player Provider
final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(AudioPlayerService());
});
