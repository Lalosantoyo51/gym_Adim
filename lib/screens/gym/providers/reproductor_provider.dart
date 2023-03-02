import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class provider_reproductor with ChangeNotifier {
  VideoPlayerController? controller = VideoPlayerController.network("");
  int playBackTime = 0;

  obtenerUrlVideo(url) {
    // _controller = VideoPlayerController.network(ejercicio.videoUrl)
    controller = VideoPlayerController.network(
        "https://p-def5.pcloud.com/cfZvpoqhxZj9IRpNZJtCj7Z7ZMaFJo7ZQ5ZZGGRZZqMMOZ7zZHZFRZhRZDLZekZrHZ1zZ4LZTLZOpZPHZzHZUFZvn1UEuhXUQSzKGdG2C63H8GDjAfX/Maquina%201.4.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        controller!.addListener(() {
          playBackTime = controller!.value.position.inSeconds;
        });
      });
    notifyListeners();
  }
}
