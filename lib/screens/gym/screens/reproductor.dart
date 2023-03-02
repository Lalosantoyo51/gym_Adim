import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Reproductor extends StatefulWidget {
  int fieldid;
  Reproductor({Key? key, required this.fieldid}) : super(key: key);

  @override
  State<Reproductor> createState() => _ReproductorState();
}

class _ReproductorState extends State<Reproductor> {
  VideoPlayerController? _controller = VideoPlayerController.network("");
  int _playBackTime = 0;

  @override 
  void initState() {
    getvideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      //DeviceOrientation.portraitDown,
      //DeviceOrientation.portraitUp
    ]);
    // TODO: implement initState

    super.initState();
  }

  getvideo() async {
    final ejercicio = Provider.of<provider_ejercicios>(context, listen: false);
    ejercicio.getUriVideo2(widget.fieldid).then((value) {
      _controller = VideoPlayerController.network(ejercicio.videoUrl)
     // _controller = VideoPlayerController.network("https://p-def5.pcloud.com/cfZvpoqhxZj9IRpNZJtCj7Z7ZMaFJo7ZQ5ZZGGRZZqMMOZ7zZHZFRZhRZDLZekZrHZ1zZ4LZTLZOpZPHZzHZUFZvn1UEuhXUQSzKGdG2C63H8GDjAfX/Maquina%201.4.mp4")
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
             _controller!.play();
              _controller!.addListener(() {
                setState(() {

                  _playBackTime = _controller!.value.position.inSeconds;
                });
            });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()async{
          SystemChrome.setPreferredOrientations([
            //DeviceOrientation.landscapeLeft,
            //DeviceOrientation.landscapeRight,
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp

          ]);
          return true;
        },
        child: Stack(
          children: [
            _controller!.value.isInitialized
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : Container(),
            Positioned(
              bottom: 10,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${_playBackTime}"),
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    child: Slider(
                        min: 0,
                        max: _controller!.value.duration.inSeconds.toDouble(),
                        value: _playBackTime.toDouble(),
                        onChanged: (v) {
                          setState(() {
                            _controller!.seekTo(Duration(seconds: v.toInt()));
                          });
                        }),
                  ),
                  Text("${_controller!.value.duration.inSeconds}"),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
