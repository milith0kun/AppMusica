import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import '../models/song_model.dart';
import 'music_service.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;

  late final AudioPlayer _audioPlayer;
  final MusicService _musicService = MusicService();

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  SongModel? _currentSong;

  AudioPlayer get player => _audioPlayer;
  SongModel? get currentSong => _currentSong;
  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  // Streams
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;
  Stream<ProcessingState> get processingStateStream =>
      _audioPlayer.processingStateStream;

  AudioPlayerService._internal() {
    _audioPlayer = AudioPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    // Configure audio session
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio session interruptions
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _audioPlayer.setVolume(0.5);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            _audioPlayer.pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _audioPlayer.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            _audioPlayer.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });

    // Handle playback events
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  Future<void> playSong(SongModel song, {List<SongModel>? queue}) async {
    try {
      _currentSong = song;

      if (queue != null) {
        _playlist = queue;
        _currentIndex = queue.indexWhere((s) => s.id == song.id);
      } else {
        _playlist = [song];
        _currentIndex = 0;
      }

      // Get streaming URL from backend
      final streamResponse = await _musicService.getStreamUrl(song.id);

      // Create audio source with metadata
      final audioSource = AudioSource.uri(
        Uri.parse(streamResponse.streamUrl),
        tag: MediaItem(
          id: song.id,
          title: song.title,
          artist: song.artist,
          album: song.album,
          duration: Duration(seconds: song.duration),
          artUri: song.coverUrl != null ? Uri.parse(song.coverUrl!) : null,
        ),
      );

      await _audioPlayer.setAudioSource(audioSource);
      await _audioPlayer.play();
    } catch (e) {
      throw 'Error al reproducir: $e';
    }
  }

  Future<void> playPlaylist(
    List<SongModel> songs, {
    int startIndex = 0,
  }) async {
    if (songs.isEmpty) return;

    _playlist = songs;
    _currentIndex = startIndex;

    await playSong(songs[startIndex], queue: songs);
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> skipToNext() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await playSong(_playlist[_currentIndex], queue: _playlist);
    }
  }

  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playSong(_playlist[_currentIndex], queue: _playlist);
    } else {
      // Restart current song
      await seek(Duration.zero);
    }
  }

  Future<void> skipToIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await playSong(_playlist[index], queue: _playlist);
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed.clamp(0.5, 2.0));
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    await _audioPlayer.setLoopMode(loopMode);
  }

  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  void addToQueue(SongModel song) {
    _playlist.add(song);
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _playlist.length && index != _currentIndex) {
      _playlist.removeAt(index);
      if (index < _currentIndex) {
        _currentIndex--;
      }
    }
  }

  void clearQueue() {
    _playlist.clear();
    _currentIndex = 0;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
