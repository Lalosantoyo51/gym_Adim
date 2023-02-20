import 'dart:io';

import 'package:administrador/screens/gym/api/ejercicios_apis.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:video_player/video_player.dart';

class provider_ejercicios with ChangeNotifier {
  TextEditingController nombre = TextEditingController();
  TextEditingController musculos_trabajados = TextEditingController();
  TextEditingController instrucciones = TextEditingController();
  TextEditingController calorias = TextEditingController();
  Api_ejercicio api_ejercicio = Api_ejercicio();
  final ImagePicker _picker = ImagePicker();
  List<Ejercicio_Model> ejercicios = [];
  late Ejercicio_Model ejercicio = Ejercicio_Model();
  bool isAgregar = false;
  bool iseditar = false;
  XFile? video;
  bool loading = false;
  String videoUrl = "";

   VideoPlayerController? controller;

  getEjercicios(id_cat_eje) {
    loading= true;
    api_ejercicio.get_eje_cat(id_cat_eje).then((List<Ejercicio_Model> ejes) {
      ejercicios = ejes;
      notifyListeners();
      loading= false;
    });
  }

  getImagetvideo() async {
    if(controller?.value.isPlaying == true){
      controller!.dispose();
    }
    await _picker.pickVideo(source: ImageSource.gallery).then((value) {
      video = value;
      print('el video ${video}');

      notifyListeners();
      initVideo(value!);
    });
  }

  initVideo(XFile video) {
    print('$video');
    controller = VideoPlayerController.file(File(video.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        controller!.play();
        notifyListeners();
      });
  }

  registrarEjercicio(id) {
    loading= true;
    api_ejercicio.subirVideo(video!,Ejercicio_Model(
        nombre: nombre.text,
        calorias: double.parse(calorias.text),
        id_cat_eje: id,
        instrucciones: instrucciones.text,
        musculos_trabajados: musculos_trabajados.text),"registrar").then((value) {
      getEjercicios(id);
      loading = false;
      nombre.clear();
      calorias.clear();
      instrucciones.clear();
      musculos_trabajados.clear();
      video=null;
      isAgregar=false;
    });
    notifyListeners();
  }

  initVideoUrl(url) {
    print('$video');
    controller = VideoPlayerController.network(url)
      ..initialize().then((value) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        controller!.play();

        controller!.addListener(() {
          if(controller!.value.duration == controller!.value.position){
            print('se termino');
            controller!.dispose();
            initVideoUrl(url);
          }

        });
        notifyListeners();
      });
  }


  getUriVideo(id){
    api_ejercicio.obtenerUriVideo(id).then((value) {
      if(value !=""){
        print('el value ${value}');
        initVideoUrl(value);
        notifyListeners();
      }
    });
  }
  Future<String> getUriVideo2(id) async{
    await api_ejercicio.obtenerUriVideo(id).then((value) {
      videoUrl = value;
      notifyListeners();
      return value;
    });
    return "aaa";
  }

  isdisponible(disponible, id_ejercicio){
    api_ejercicio.isdisponible(disponible, id_ejercicio);
    notifyListeners();
  }

  eliminar_eje(id_ejercicio,id_cat_eje,fielid){
    api_ejercicio.eliminar_eje(id_ejercicio,fielid).then((value) => getEjercicios(id_cat_eje));
  }


  advertencia(context,id,id_cat_eje,fileid,) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "Estas seguro de eliminar el registro?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            eliminar_eje(id,id_cat_eje,fileid);
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }

  actualizar(id_cat_eje){
    loading = true;
    notifyListeners();
    ejercicio.nombre = nombre.text;
    ejercicio.musculos_trabajados = musculos_trabajados.text;
    ejercicio.instrucciones = instrucciones.text;
    ejercicio.calorias = double.parse(calorias.text);


    print('lo que se manda ${ejercicio.toJson()}');
    if(video != null){
      api_ejercicio.subirVideo(video, ejercicio, "actualizar").then((value){
        iseditar = false;
        getEjercicios(id_cat_eje);
      });    }else{
      api_ejercicio.subirVideo(null, ejercicio, "actualizar").then((value){
        iseditar = false;
        getEjercicios(id_cat_eje);
      });
      notifyListeners();
    }
    //print('${cate!.toJson()}');
  }
}
