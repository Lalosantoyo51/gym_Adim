import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/comida.dart';
import 'package:administrador/screens/gym/models/nutricion.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class NutriApis {
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

  Future<NutricionModel> insertNutri(NutricionModel nutri) async {
    NutricionModel nutric = NutricionModel();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {

      print('${uriP}nutricion.php?op=insertNutri');
      response = await dio.post('${uriP}nutricion.php?op=insertNutri',
          data: nutri.toJson(), options: options2);
      print('el response Nutricion ${response.data}');
      return NutricionModel.fromJson(json.decode(response.data)[0]);
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return nutric;
  }
  Future<ComidaModel?> insertComida(ComidaModel comida) async {
    ComidaModel? comidaM;

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {

      print('${uriP}nutricion.php?op=insertComida');
      response = await dio.post('${uriP}nutricion.php?op=insertComida',
          data: comida.toJson(), options: options2);
      return ComidaModel.fromJson(json.decode(response.data)[0]);
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return comidaM;
  }

  Future<List<NutricionModel>> historialNu(int asignado_a) async {
    List<NutricionModel> nutri = [];

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}nutricion.php?op=historial');
      response = await dio.post('${uriP}nutricion.php?op=historial',
          data: {"asignado_a":asignado_a},
          options: options2);
      print('el response ${response.data}');
      nutri = (json.decode(response.data) as List)
          .map((data) => NutricionModel.historial(data))
          .toList();
      return nutri;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return nutri;
  }
  Future<List<UserModel>> getUsuarios() async {
    List<UserModel> listUser = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}nutricion.php?op=getUsuarios');
      response = await dio.get('${uriP}nutricion.php?op=getUsuarios', options: options2);
      listUser = (json.decode(response.data) as List)
          .map((data) => UserModel.fromJson(data))
          .toList();
      return listUser;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return listUser;
  }
}