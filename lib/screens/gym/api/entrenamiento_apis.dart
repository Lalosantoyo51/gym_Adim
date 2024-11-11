import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/asistencia.dart';
import 'package:administrador/screens/gym/models/dias.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/models/serie.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class Entrenamiento_Apis {
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

  Future<Entrenamoento_Model> insetEnt(Entrenamoento_Model ent)async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await dio.post('${uriP}entrenamiento.php?op=insert_ent',data: ent.toJson(),options: options2);
      print('el response ${response.data}');
      // ejercicios = (json.decode(response.data) as List)
      //     .map((data) => Ejercicio_Model.fromJson(data))
      //     .toList();
      // return ejercicios;
      return Entrenamoento_Model.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return Entrenamoento_Model();
  }
  Future<DiasModel> insetDia(DiasModel dia)async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await dio.post('${uriP}entrenamiento.php?op=insertar_dias',data: dia.toJson(),options: options2);
      // ejercicios = (json.decode(response.data) as List)
      //     .map((data) => Ejercicio_Model.fromJson(data))
      //     .toList();
      // return ejercicios;
      return DiasModel.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return DiasModel(dia: "");
  }
  Future insertar_ejercicios_entrenamiento(Entrenamiento_Eje eje)async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await dio.post('${uriP}entrenamiento.php?op=insertar_ejercicios_entrenamiento',data: eje.toJson(),options: options2);
      print('insertar eje ${response.data}');
      return DiasModel.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return;
  }
  Future<List<Entrenamoento_Model>> obtenerEntrenamiento()async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    List<Entrenamoento_Model> entrenamientos = [];
    Response response;
    try {
      response = await dio.post('${uriP}entrenamiento.php?op=obtenerEntrenamiento',data: {},options: options2);
      entrenamientos = (json.decode(response.data) as List)
          .map((data) => Entrenamoento_Model.fromJson2(data))
          .toList();
      return entrenamientos;

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return entrenamientos;
  }

  Future<String?> eliminarEnt(int id_ent)async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await dio.post('${uriP}entrenamiento.php?op=eliminarEnt',data: {
        "id_ent":id_ent
      },options: options2);
      return "se elimino";

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return "";
  }

  Future tieneEntUse(int id_user)async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=tieneEntUse');
      response = await dio.post('${uriP}entrenamiento.php?op=tieneEntUse',data: {"id_user":id_user},options: options2);
      List entrenamientos = [];
      entrenamientos = (json.decode(response.data) as List).toList();
      print('el response de tiene ${entrenamientos.length}');
      return entrenamientos.length;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }


  Future<String?> asignatRutina(Entrenamiento_Eje entrenamiento_eje)async{

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=asignarEnt');
      response = await dio.post('${uriP}entrenamiento.php?op=asignarEnt',data: entrenamiento_eje.toJson(),options: options2);
      print('el response ${response.data}');
      if(response.data == "El usuario ya se encuentra registrado en esta rutina"){
        return "fallo";
      }else{
        return "succes";
      }
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
  Future pushNotification(int id_usuario, token, Entrenamoento_Model entre) async {
    print('manda la push ');
    print('el token $id_usuario');
    var datos = {
      "to": token,
      "notification": {
        "body": entre.nombre_ent,
        "title": "Te han agregado una rutina",
        "image": "https://api.pcloud.com/getpubthumb?code=XZ4xYcVZlqyhqu0qXEujbhHJ0tA1pfslrps7&linkpassword=undefined&size=1024x1024&crop=0&type=auto"
      },
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('https://fcm.googleapis.com/fcm/send');
      response = await dio.post('https://fcm.googleapis.com/fcm/send',
          data: json.encode(datos), options: options3);
      String err = response.data["results"][0]["error"];
      if(err == "InvalidRegistration" || err == "NotRegistered"){
        eliminarDispositivo(token);
      }
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future eliminarDispositivo(token) async {
    var datos = {"token": token};
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=eliminarDispositivo');
      response = await dio.post('${uriP}reto.php?op=eliminarDispositivo',
          data: datos, options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
  Future<List<UserModel>> get_usurios(id_ent) async {
    var datos = {
      "id_ent": id_ent
    };
    List<UserModel> users = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=obtner_usuarios');
      response = await dio.post('${uriP}entrenamiento.php?op=obtner_usuarios',data: datos, options: options2);
      print('el response ${response.data}');
      users = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJsonDispositivo(data))
          .toList();
      return users;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return users;
  }

  Future<List<UserModel>> get_usurios_entrenamiento(id_ent) async {
    var datos = {
      "id_ent": id_ent
    };
    List<UserModel> users = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=obtner_usuarios_entrenamiento');
      response = await dio.post('${uriP}entrenamiento.php?op=obtner_usuarios_entrenamiento',data: datos,options: options2);
      print('el response ${response.data}');
      users = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJson(data))
          .toList();
      print('el response ${response.data}');
      return users;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return users;
  }
  Future existe_el_ususrio(int asignado_a, int id_ent)async{
    var datos = {
      "asignado_a": asignado_a,
      "id_ent":id_ent
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=existe_el_ususrio');
      response = await dio.post('${uriP}entrenamiento.php?op=existe_el_ususrio',data: datos,options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future<List<SerieModel>> get_ejercicio_rutina(id_rutina,id_ent)async{
    var datos = {
      "id_rutina": id_rutina,
      "id_ent": id_ent
    };
    List<SerieModel> series = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=get_ejercicio_ent');
      response = await dio.post('${uriP}entrenamiento.php?op=get_ejercicio_ent',data: datos,options: options2);
      series = (json.decode(response.data) as List)
          .map((data) => SerieModel.fromJson(data))
          .toList();
      return series;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return series;
  }
  Future eliminar_rutina_usuario(asignado_a, id_rutina,id_ent) async {
    var datos = {
      "asignado_a": asignado_a,
      "id_rutina":id_rutina,
      "id_ent":id_ent
    };
    List<UserModel> users = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}entrenamiento.php?op=eliminar_ent_usu');
      response = await dio.post('${uriP}entrenamiento.php?op=eliminar_ent_usu',data: datos,options: options2);
      print('el response ${response.data}');

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future<List<AsistenciaModel>> getAsistencia()async{
    List<AsistenciaModel> asistencia = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}recepcion.php?op=historial');
      response = await dio.get('${uriP}recepcion.php?op=historial',options: options2);
      asistencia = (json.decode(response.data) as List)
          .map((data) => AsistenciaModel.fromJson(data))
          .toList();
      return asistencia;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return asistencia;
  }


}