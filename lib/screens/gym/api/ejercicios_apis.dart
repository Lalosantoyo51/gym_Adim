import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';


class Api_ejercicio {
 Dio dio = Dio();
 // or new Dio with a BaseOptions instance.
 var options = Options(headers: {
  'Content-Type': 'application/x-www-form-urlencoded',
  'X-Requested-With': 'XMLHttpRequest',
  'authorization':
  'Bearer JtCj7ZrO7sAKRKs9bZ6Yx3c7ZvO3I6MxTufuvB3nvOt0dW4WASbg7'
 });
 var options2 =
 Options(headers: {'Content-type': 'application/json; charset=UTF-8'});


 Future  subirVideo(XFile? file, Ejercicio_Model eje, String accion)async{
  Response response;

  if(accion =="registrar" || accion == "actualizar" && file !=null){
   eliminarImagen(eje.fileid);
   try{
    var datos = FormData.fromMap({
     "path" : '/Gym/videos',
     "folderid" : 'd16294226496',
     'filename': await MultipartFile.fromFile(file!.path, filename:'${DateTime.now()}.mp4'),
    });
    response = await dio.post('${uri}uploadfile', options: options,data: datos );
    print('el response  ${response.data['metadata'][0]['fileid']}');
    int id = response.data['metadata'][0]['fileid'];
    eje.fileid = id;
    print('nuevo id el nuevo id: $id');
        return optenrInfoImagen(id,eje,accion);
    //print('el response  ${json.decode(response.data['metadata'])}');
   }on DioError catch(e){
    print('sdsadsa ${e.error}');
   }
  }else{
   return actualizarEjercicio(eje);
  }
 }

 Future  optenrInfoImagen(int id,Ejercicio_Model eje,String accion)async{
  Response response;
  var datos = FormData.fromMap({
   "path" : '/Gym/videos',
   "fileid" : id,
  });

  try{
   response = await dio.post('${uri}getfilepublink', options: options,data: datos );
   String url = response.data['code'];
   print('url $url');
   if(accion == "registrar" ){
    return insertEjercicio(eje);
   }
   else if(accion == "actualizar"){
    print('aaaaaaaaaaaaaaaaaaa-----------------------------------');
        return actualizarEjercicio(eje);
   }
  }on DioError catch(e){
   print('sdsadsa ${e.error}');
  }
 }



 Future<List<Ejercicio_Model>> get_eje_cat(id_cat_eje)async{
  List<Ejercicio_Model> ejercicios = [];
  var datos= {
   "id_cat_eje":id_cat_eje
  };
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
   client.badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;
   return client;
  };
  Response response;
  try {
   print('${uriP}ejercicio.php?op=get_ejercicios');
   response = await dio.post('${uriP}ejercicio.php?op=get_ejercicios',data: datos,options: options2);
   print('el response ${response.data}');
   ejercicios = (json.decode(response.data) as List)
       .map((data) => Ejercicio_Model.fromJson(data))
       .toList();
   return ejercicios;
  } on DioError catch (e) {
   print('el error ${e.error}');
  }
  return ejercicios;
 }
 Future eliminarImagen(fileid)async{
  Response response;
  var datos = FormData.fromMap({
   "path" : '/Gym/categoria_ejercicio',
   "fileid" : fileid,
  });

  try{
   response = await dio.post('${uri}deletefile', options: options,data: datos );
   print('el response  el id img $fileid ${response.data}');
  }on DioError catch(e){
   print('sdsadsa ${e.error}');
  }
 }

 Future<Ejercicio_Model> insertEjercicio(Ejercicio_Model ejercicio)async{

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
   client.badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;
   return client;
  };
  Response response;
  try {
   print('${uriP}ejercicio.php?op=insert');
   response = await dio.post('${uriP}ejercicio.php?op=insert',data: ejercicio.toJson(),options: options2);
   print('el response ${response.data}');
  // ejercicios = (json.decode(response.data) as List)
  //     .map((data) => Ejercicio_Model.fromJson(data))
  //     .toList();
  // return ejercicios;
   return Ejercicio_Model.fromJson(json.decode(response.data)[0]);

  } on DioError catch (e) {
   print('el error ${e.error}');
  }
  return Ejercicio_Model();
 }


 Future <String> obtenerUriVideo(int id)async{
  String url = "";
  Response response;
  var datos = FormData.fromMap({
   "path" : '/Gym/videos',
   "fileid" : id,
  });

  try{
   response = await dio.post('${uri}getfilelink', options: options,data: datos );
   //String url = response.data['code'];

   url= "https://"+ response.data["hosts"][0] + response.data["path"];
   print('la url ${url}');
   return url;
    }on DioError catch(e){
   print('sdsadsa ${e.error}');
  }
  return url;
 }

 isdisponible(disponible, id_ejercicio) async {
  var datos = {"id_ejercicio": id_ejercicio, "disponible": disponible};
  print('los datos ${datos}');
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
   client.badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;
   return client;
  };
  Response response;
  try {
   print('${uriP}ejercicio.php?op=isdisponible');
   response = await dio.post('${uriP}ejercicio.php?op=isdisponible',
       data: datos, options: options2);
   print('el response ${response.data}');
  } on DioError catch (e) {
   print('el error ${e.error}');
  }
 }

 Future eliminar_eje(id_ejercicio,fileid) async {
  var datos = {"id_ejercicio": id_ejercicio};
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
   client.badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;
   return client;
  };
  Response response;
  try {
   eliminarImagen(fileid);
   print('${uriP}ejercicio.php?op=eliminar_eje');
   response = await dio.post('${uriP}ejercicio.php?op=eliminar_eje',
       data: datos, options: options2);
   print('el response  ${response.data.toString()}....');
  } on DioError catch (e) {
   print('el error ${e.error}');
  }
 }

 Future actualizarEjercicio(Ejercicio_Model ejercicio,)async{
  print('los que resive ${ejercicio.toJson()}');
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
   client.badCertificateCallback =
       (X509Certificate cert, String host, int port) => true;
   return client;
  };
  Response response;
  try {
   print('${uriP}ejercicio.php?op=actualizar_eje');
   response = await dio.post('${uriP}ejercicio.php?op=actualizar_eje',data: ejercicio.toJson(),options: options2);
   print('el response ${response.data}');
   return response.data;

  } on DioError catch (e) {
   print('el error ${e.error}');
  }
  return Ejercicio_Model();
 }


}