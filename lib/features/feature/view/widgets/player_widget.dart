import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_test/features/feature/models/media.dart';
import 'package:mvvm_test/features/feature/view_models/media_view_model.dart';

class PlayerWidget extends StatefulWidget {
  final Function function;

  const PlayerWidget({super.key, required this.function});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String? _prevSongName;
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });
  }

  void _playCurrentMedia(Media? media) {
    if (media != null && _prevSongName != media.trackName) {
      _prevSongName = media.trackName;
      _position = Duration.zero;
      _audioPlayer.stop();
      _play(media);
    }
  }

  Future<void> _play(Media media) async {
    await _audioPlayer.play(UrlSource(media.previewUrl));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    Media? media = Provider.of<MediaViewModel>(context).media;
    _playCurrentMedia(media);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.fast_rewind,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFF787878),
              ),
            ),
            ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withAlpha(30),
                width: 50.0,
                height: 50.0,
                child: IconButton(
                  onPressed: () {
                    if (_playerState == PlayerState.playing) {
                      widget.function();
                      _pause();
                    } else {
                      if (media != null) {
                        widget.function();
                        _play(media);
                      }
                    }
                  },
                  icon: Icon(
                    _playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 30.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.fast_forward,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFF787878),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              min: 0,
              max: _duration.inMilliseconds.toDouble(),
              value: _position.inMilliseconds.toDouble(),
              onChanged: (value) {
                final position = Duration(milliseconds: value.round());
                _audioPlayer.seek(position);
              },
            ),
          ),
        ),
      ],
    );
  }
}
