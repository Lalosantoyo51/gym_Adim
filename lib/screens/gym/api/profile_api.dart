import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/perfil.dart';
import 'package:administrador/screens/gym/models/profile.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ProfileApi {
  Dio dio = Dio();
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

  Future subirImagen(
      XFile? file, ProfileModel perfil, id_usuario, {int? pos}) async {
    Response response;
    switch(pos){
      case 1:
        print('el pos api ${pos}');
        eliminarImagen(perfil.fileid1);
        break;
      case 2:
        print('el pos api ${pos}');
        eliminarImagen(perfil.fileid12);
        break;
      case 3:
        print('el pos api ${pos}');
        eliminarImagen(perfil.fileid21);
        break;
      case 4:
        print('el pos api ${pos}');
        eliminarImagen(perfil.fileid22);
        break;
      case 5:
        print('el pos api ${pos}');
        eliminarImagen(perfil.fileid31);
        break;
      case 6:
        print('el pos ${pos}');
        eliminarImagen(perfil.fileid32);
        break;
    }
    try {
      var datos = FormData.fromMap({
        "path": '/Gym/categoria_ejercicio',
        "folderid": 'd16259436692',
        'filename': await MultipartFile.fromFile(file!.path,
            filename: '${DateTime.now()}.jpg'),
      });
      response =
          await dio.post('${uri}uploadfile', options: options, data: datos);
      print('el response  ${response.data['metadata'][0]['fileid']}');
      int id = response.data['metadata'][0]['fileid'];
      switch(pos){
        case 1:
          perfil.fileid1 = id;
          break;
        case 2:
          perfil.fileid12 = id;
          break;
        case 3:
          perfil.fileid21 = id;
          break;
        case 4:
          perfil.fileid22 = id;
          break;
        case 5:
          perfil.fileid31 = id;
          break;
        case 6:
          perfil.fileid32 = id;
          break;
      }
      return optenrInfoImagen(id, perfil, id_usuario,pos: pos!);
      //print('el response  ${json.decode(response.data['metadata'])}');
    } on DioError catch (e) {
      print('sdsadsa ${e.error}');
    }
  }

  Future eliminarImagen(fileid) async {
    Response response;
    var datos = FormData.fromMap({
      "path": '/Gym/categoria_ejercicio',
      "fileid": fileid,
    });

    try {
      response =
          await dio.post('${uri}deletefile', options: options, data: datos);
      print('el response  el id img $fileid ${response.data}');
    } on DioError catch (e) {
      print('sdsadsa ${e.error}');
    }
  }

  Future optenrInfoImagen(
      int id, ProfileModel cat, id_usuario, {int? pos}) async {
    Response response;
    var datos = FormData.fromMap({
      "path": '/Gym/categoria_ejercicio',
      "fileid": id,
    });

    try {
      response =
          await dio.post('${uri}getfilepublink', options: options, data: datos);
      String url = response.data['code'];
      print('url $url');
      updateProfile(cat, img: url, id_usuario,pos: pos);
    } on DioError catch (e) {
      print('sdsadsa ${e.error}');
    }
  }

  Future<ProfileModel?> getProfile(id_usuario) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await dio.post('${uriP}usuario.php?op=getProfileEtn',
          data: {'id_usuario': id_usuario}, options: options2);
      return ProfileModel.fromJson(json.decode(response.data)[0]);
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return ProfileModel();
  }



  Future<String?> updateProfile(
      ProfileModel perfil, id_usuario, {int? pos, String? img}) async {
    if (img != "") {
     String url =
          'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
     switch(pos){
       case 1:
         perfil.img11 = url;
         break;
       case 2:
         perfil.img12 = url;
         break;
       case 3:
         perfil.img21 = url;
         break;
       case 4:
         perfil.img22 = url;
         break;
       case 5:
         perfil.img31 = url;
         break;
       case 6:
         perfil.img32 = url;
         break;
     }
    }
    ProfileModel? cate;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}usuario.php?op=updateProfileEtn');
      response = await dio.post('${uriP}usuario.php?op=updateProfileEtn',
          data: perfil.toJson(id_usuario), options: options2);
      print('el response ${response.data}');
      return "Se actualizo";
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return "Se actualizo";
  }
}

///nota importante
///Modificar la base de datos con los campos fieldId de las imagenes (completo)
///modificar las apis agregando los fieldid  (completo)
///añadir funcionalidad de seleccion de imagen en de agregar logro (pantalla )
///añadir funcionalidad de actualizar las apis