import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/reto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class RetoApis {
  Dio dio = Dio();
  var options = Options(headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'X-Requested-With': 'XMLHttpRequest',
    'authorization':
        'Bearer JtCj7ZrO7sAKRKs9bZ6Yx3c7ZvO3I6MxTufuvB3nvOt0dW4WASbg7'
  });
  var options2 =
      Options(headers: {'Content-type': 'application/json; charset=UTF-8'});
  Future subirImagenCatEje(
      XFile? file, RetoModel retoModel, String accion) async {
    Response response;

    if (accion == "registrar" || accion == "actualizar" && file != null) {
      eliminarImagen(retoModel.fileid);
      try {
        var datos = FormData.fromMap({
          "path": '/Gym/retos',
          "folderid": 'd18404123291',
          'filename': await MultipartFile.fromFile(file!.path,
              filename: '${DateTime.now()}.jpg'),
        });
        response =
            await dio.post('${uri}uploadfile', options: options, data: datos);
        print('el response  ${response.data['metadata'][0]['fileid']}');
        int id = response.data['metadata'][0]['fileid'];
        retoModel.fileid = id;
        return optenrInfoImagen(id, retoModel, accion);
        //print('el response  ${json.decode(response.data['metadata'])}');
      } on DioError catch (e) {
        print('sdsadsa ${e.error}');
      }
    } else {
      return actualizar_reto(retoModel, "");
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

  Future optenrInfoImagen(int id, RetoModel retoModel, String accion) async {
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
      if (accion == "registrar") {
        return insertReto(retoModel, url);
      } else if (accion == "actualizar") {
        return actualizar_reto(retoModel, url);
      }
    } on DioError catch (e) {
      print('sdsadsa ${e.error}');
    }
  }

  Future<RetoModel?> insertReto(RetoModel reto, img) async {
    reto.imagen =
        'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    RetoModel? retoModel;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('lo que se manda ${reto.toJson()}');

      print('${uriP}reto.php?op=insert_reto');
      response = await dio.post('${uriP}reto.php?op=insert_reto',
          data: reto.toJson(), options: options2);
      print('el response ${response.data}');
      return RetoModel.fromJson(json.decode(response.data)[0]);
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return retoModel;
  }

  Future<List<RetoModel>> get_retos() async {
    List<RetoModel> listReto = [];
    DateTime date = DateTime.now();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=getAll');
      response = await dio.post('${uriP}reto.php?op=getAll',
          data: {"fecha_inicio": "${date.year}-${date.month}-${date.day}"},
          options: options2);
      print('el response ${response.data}');
      listReto = (json.decode(response.data) as List)
          .map((data) => RetoModel.fromJson(data))
          .toList();
      return listReto;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listReto;
  }

  Future<List<RetoModel>> get_retoHistorial() async {
    List<RetoModel> listReto = [];

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      DateTime date = DateTime.now();
      print('${uriP}reto.php?op=historial');
      response = await dio.post('${uriP}reto.php?op=historial',
          data: {"fecha_fin": "${date.year}-${date.month}-${date.day}"},
          options: options2);
      print('el response ${response.data}');
      listReto = (json.decode(response.data) as List)
          .map((data) => RetoModel.fromJson(data))
          .toList();
      return listReto;
    } on DioError catch (e) {
      print('el error----- ${e.error}');
    }
    return listReto;
  }

  Future actualizar_reto(RetoModel reto, img) async {
    if (img != "") {
      reto.imagen =
          'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    }
    RetoModel? ret;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=update_reto');
      response = await dio.post('${uriP}reto.php?op=update_reto',
          data: reto.toJson(), options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return ret;
  }

  Future eliminar_reto(id_reto, fileid) async {
    var datos = {"id_reto": id_reto};
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      eliminarImagen(fileid);
      print('${uriP}reto.php?op=eliminar_reto');
      response = await dio.post('${uriP}reto.php?op=eliminar_reto',
          data: datos, options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future<List<UserModel>> getusuarioxreto(id_reto) async {
    List<UserModel> listUser = [];
    var datos = {"id_usuario": id_reto};
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=getUsuarios');
      response = await dio.post('${uriP}reto.php?op=getUsuarios',
          data: datos, options: options2);
      listUser = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJson(data))
          .toList();
      return listUser;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listUser;
  }

  Future<List<UserModel>> getUsuariosDisponibles() async {
    List<UserModel> listUser = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=getUsu');
      response = await dio.get('${uriP}reto.php?op=getUsu', options: options2);
      print('el response de diponibles ${response.data}');

      listUser = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJson(data))
          .toList();
      return listUser;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listUser;
  }

  Future asignarUsu(id_reto, id_usuario, asignadox) async {
    var datos = {
      "id_reto":id_reto,
      "id_usuario":id_usuario,
      "asignadox":asignadox
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=asignarUsu');
      response = await dio.post('${uriP}reto.php?op=asignarUsu',
          data: datos, options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
  Future eliminarRetoUsuario(id_reto, id_usuario) async {
    var datos = {
      "id_reto":id_reto,
      "id_usuario":id_usuario
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=eliminarRetoUsuario');
      response = await dio.post('${uriP}reto.php?op=eliminarRetoUsuario',
          data: datos, options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
}
