import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    getvideo();
    // TODO: implement initState
    super.initState();
  }

  getvideo()async{
    final ejercicio = Provider.of<provider_ejercicios>(context, listen: false);
    ejercicio.getUriVideo2(widget.fieldid).then((value) {

     _controller = VideoPlayerController.network(ejercicio.videoUrl)
       ..initialize().then((_) {
         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
         setState(() {});
       });
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : Container(),
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
