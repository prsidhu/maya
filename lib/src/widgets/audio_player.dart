import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final bool isPlaying;

  const AudioPlayerWidget({super.key, required this.filePath, required this.isPlaying});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _audioPlayer.play(DeviceFileSource(widget.filePath));
      } else {
        _audioPlayer.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // No UI
  }
}
