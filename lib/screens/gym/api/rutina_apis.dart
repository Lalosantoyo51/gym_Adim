import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/rutina_model.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class Rutina_Apis{
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


  Future<List<Rutina_Model>> get_rutinas(id_usuario)async{
    var datos = {
      "id_usuario": id_usuario
    };
    List<Rutina_Model> rutinas = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=get_rutina');
      response = await dio.post('${uriP}rutina.php?op=get_rutina',data: datos,options: options2);
      print('el response ${response.data}');
      rutinas = (json.decode(response.data) as List)
          .map((data) => Rutina_Model.fromJson(data))
          .toList();
      return rutinas;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return rutinas;
  }


  Future<Rutina_Model> insetRutina(Rutina_Model rutina)async{

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=insert');
      response = await dio.post('${uriP}rutina.php?op=insert',data: rutina.toJson(),options: options2);
      print('el response ${response.data}');
      // ejercicios = (json.decode(response.data) as List)
      //     .map((data) => Ejercicio_Model.fromJson(data))
      //     .toList();
      // return ejercicios;
      return Rutina_Model.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return Rutina_Model();
  }

  Future<List<Rutina_Ejercicio_Model>> get_ejercicio_rutina(id_rutina)async{
    var datos = {
      "id_rutina": id_rutina
    };
    List<Rutina_Ejercicio_Model> ejercicio_rutinas = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=get_ejercicios_rutinas');
      response = await dio.post('${uriP}rutina.php?op=get_ejercicios_rutinas',data: datos,options: options2);
      print('el response ${response.data}');
      ejercicio_rutinas = (json.decode(response.data) as List)
          .map((data) => Rutina_Ejercicio_Model.fromJson2(data))
          .toList();
      return ejercicio_rutinas;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return ejercicio_rutinas;
  }

  Future<Rutina_Ejercicio_Model?> asignatRutina(Rutina_Ejercicio_Model rutina)async{

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=asignar_rutina');
      response = await dio.post('${uriP}rutina.php?op=asignar_rutina',data: rutina.toJson(),options: options2);
      print('el response ${response.data}');
      //return Rutina_Ejercicio_Model.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    //return Rutina_Ejercicio_Model();
  }
  Future eliminar_rutina( id_rutina)async{
    var datos = {
      "id_rutina": id_rutina
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=eliminar_rutina');
      response = await dio.post('${uriP}rutina.php?op=eliminar_rutina',data: datos,options: options2);
      print('el response ${response.data}');
      // ejercicios = (json.decode(response.data) as List)
      //     .map((data) => Ejercicio_Model.fromJson(data))
      //     .toList();
      // return ejercicios;

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
  Future<List<UserModel>> get_usurios(id_rutina) async {
    var datos = {
      "id_rutina": id_rutina
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
      print('${uriP}rutina.php?op=obtner_usuarios');
      response = await dio.post('${uriP}rutina.php?op=obtner_usuarios',data: datos, options: options2);
      print('el response ${response.data}');
      users = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJson(data))
          .toList();
      return users;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return users;
  }

  Future<List<UserModel>> get_usurios_rutina(id_rutina) async {
    var datos = {
      "id_rutina": id_rutina
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
      print('${uriP}rutina.php?op=obtner_usuarios_rutina');
      response = await dio.post('${uriP}rutina.php?op=obtner_usuarios_rutina',data: datos,options: options2);
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
  Future eliminar_rutina_usuario(asignado_a) async {
    var datos = {
      "asignado_a": asignado_a
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
      print('${uriP}rutina.php?op=eliminar_rutina_usuario');
      response = await dio.post('${uriP}rutina.php?op=eliminar_rutina_usuario',data: datos,options: options2);
      print('el response ${response.data}');

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future eliminar_ejercicio_rutina(id_rutina,id_ejercicio) async {
    var datos = {
      "id_rutina": id_rutina,
      "id_ejercicio":id_ejercicio
    };
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}rutina.php?op=eliminar_ejercicio_rutina');
      response = await dio.post('${uriP}rutina.php?op=eliminar_ejercicio_rutina',data: datos,options: options2);
      print('el response ${response.data}');

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }


}