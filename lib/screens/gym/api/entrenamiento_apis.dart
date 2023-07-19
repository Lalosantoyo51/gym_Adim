import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/gym/models/dias.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
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
      // ejercicios = (json.decode(response.data) as List)
      //     .map((data) => Ejercicio_Model.fromJson(data))
      //     .toList();
      // return ejercicios;
     // return DiasModel.fromJson(json.decode(response.data)[0]);

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


}