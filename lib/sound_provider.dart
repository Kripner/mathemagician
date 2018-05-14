import 'package:audioplayer/audioplayer.dart';

class SoundProvider {
  AudioPlayer audioPlayer = new AudioPlayer();

  play(String url) async {
    await audioPlayer.play(url);
  }
}