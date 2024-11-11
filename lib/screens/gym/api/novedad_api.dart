import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/gym/models/novedad.dart';
import 'package:administrador/screens/gym/models/pushModel.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class Novedad_api {
  var dio = Dio();

  // or new Dio with a BaseOptions instance.
  var options = Options(headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'X-Requested-With': 'XMLHttpRequest',
    'authorization':
    'Bearer JtCj7ZrO7sAKRKs9bZ6Yx3c7ZvO3I6MxTufuvB3nvOt0dW4WASbg7'
  });
  var options2 =
  Options(headers: {'Content-type': 'application/json; charset=UTF-8'});
  var options3 = Options(headers: {
    'Authorization':
    'key=AAAAhOndpUw:APA91bHO6C6yeNLoa0hOVt9cskZ_6I0MsesP3jsB7g7o-vWxmUr7yMRN4-QQEfNou2fEmxVUTkmNqvU9CXf20MthAF-y2cOmTbGYn2OBqGN4K0xngdax-fGhT-zjk9ifaA3G49UqvTij'
  });
  Future  subirImagenCatEje(XFile? file, NovedadModel novedad, String accion)async{
    Response response;

    if(accion =="registrar" || accion == "actualizar" && file !=null){
      eliminarImagen(novedad.fileid);
      try{
        var datos = FormData.fromMap({
          "path" : '/Gym/novedad',
          "folderid" : '19380916108',
          'filename': await MultipartFile.fromFile(file!.path, filename:'${DateTime.now()}.jpg'),
        });
        response = await dio.post('${uri}uploadfile', options: options,data: datos );
        print('el response  ${response.data['metadata'][0]['fileid']}');
        int id = response.data['metadata'][0]['fileid'];
        novedad.fileid = id;
        return optenrInfoImagen(id,novedad,accion);
        //print('el response  ${json.decode(response.data['metadata'])}');
      }on DioError catch(e){
        print('sdsadsa ${e.error}');
      }
    }else{
      return actualizarNovedad(novedad,"");
    }
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
  Future  optenrInfoImagen(int id,NovedadModel novedad,String accion)async{
    Response response;
    var datos = FormData.fromMap({
      "path" : '/Gym/categoria_ejercicio',
      "fileid" : id,
    });

    try{
      response = await dio.post('${uri}getfilepublink', options: options,data: datos );
      String url = response.data['code'];
      print('url $url');
      if(accion == "registrar" ){
        return insertarNovedad(novedad, url);
      }else if(accion == "actualizar"){
        return actualizarNovedad(novedad, url);
      }
    }on DioError catch(e){
      print('sdsadsa ${e.error}');
    }
  }
  Future actualizarNovedad(NovedadModel novedad , img ) async{
    if(img != ""){
      novedad.imagen = 'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    }
    NovedadModel? noved;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}novedad.php?op=actualizarNovedad');
      response = await dio.post('${uriP}novedad.php?op=actualizarNovedad',
          data: novedad.actualizar(), options: options2);
      print('el response ${response.data}');
      print('${novedad.imagen}');
      sendAll(novedad.imagen!,novedad.titulo!);
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return noved;
  }
  Future <NovedadModel?> insertarNovedad(NovedadModel novedad, img) async{
    novedad.imagen = 'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    NovedadModel? noved;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    print(' lo que se manda${novedad.toJson()}');
    try {
      print('${uriP}novedad.php?op=insert');
      response = await dio.post('${uriP}novedad.php?op=insert',
          data: novedad.toJson(), options: options2);
      print('el response ${response.data}');
      return NovedadModel.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return noved;
  }

  Future <List<NovedadModel>> getNovedades() async{
    List<NovedadModel> listNovedad = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}novedad.php?op=getNovedades');
      response = await dio.post('${uriP}novedad.php?op=getNovedades',
          options: options2);
      print('el response ${response.data}');
      if(response.data.toString() == "[]"){
        return listNovedad;
      }else{
        listNovedad = (json.decode(response.data) as List)
            .map((data) => NovedadModel.fromJson(data))
            .toList();
        return listNovedad;
      }
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listNovedad;
  }
  Future sendAll(String imagen,String titulo) async{
    String hoy = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}novedad.php?op=send');
      response = await dio.post('${uriP}novedad.php?op=send',
          data: {
            "imagen":imagen,
            "titulo":titulo,
            "fecha":hoy,
          },
          options: options2);
      print('el response ${response.data}');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
  Future <List<PushModel>> getHistorialPush(int id_usuario) async{

    List<PushModel> listPush = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}novedad.php?op=getHistorialPush');
      response = await dio.post('${uriP}novedad.php?op=getHistorialPush',data: {
        "id_usuario":id_usuario
      },
          options: options2);
      print('el response ${response.data}');
      listPush = (json.decode(response.data) as List)
          .map((data) => PushModel.fromJson(data))
          .toList();
      return listPush;


    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listPush;
  }

}

