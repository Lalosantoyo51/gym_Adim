import 'dart:convert';
import 'dart:io';
import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/screens/home.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart' as gets;
import 'package:shared_preferences/shared_preferences.dart';

class ControladorAuth {
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
  UserModel? user;

  Future<UserModel?> registrarUsuario(UserModel user) async {
    UserModel? userModel;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}usuario.php?op=registar');
      response = await dio.post('${uriP}usuario.php?op=registar_admin',
          data: user.toJson(), options: options2);
      print('el response  ${response.data.toString()}....');
      if (response.data == "El correo ya se encuentra registrado") {
        return userModel;
      } else {
        userModel = UserModel.fromJson(json.decode(response.data));
        return userModel;
      }
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return userModel;
  }

  Future login(email, pass, context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var datos = {"email": email, "contrasena": pass};

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      UserModel user;
      print('${uriP}usuario.php?op=login');
      response = await dio.post('${uriP}usuario.php?op=login',
          data: datos, options: options2);
      user = UserModel.fromJson(json.decode(response.data)[0]);
      if (user.tipo_user != 1) {
        sp.setString("usuario",json.encode(user.toJson()));
        succes(context, user);
      }
      print('el response ${response.data}');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  succes(context, UserModel user)async {

    await getUser();

    await Alert(
      context: context,
      type: AlertType.success,
      title: "Bienvenido",
      desc: "Nos alegra que allas regresado.",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (user.tipo_user == 2) {
              gets.Get.offAll(HomeAdmin(user: user,));

            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  Future<List<UserModel>> get_admins(email) async {
    var datos = {"email": email};
    List<UserModel> users = [];
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      UserModel user;
      print('${uriP}usuario.php?op=get_admins');
      response = await dio.post('${uriP}usuario.php?op=get_admins',
          data: datos, options: options2);
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

  isdisponible(disponible, id_user) async {
    var datos = {"id_usuario": id_user, "disponible": disponible};
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}usuario.php?op=isdisponible');
      response = await dio.post('${uriP}usuario.php?op=isdisponible',
          data: datos, options: options2);
      print('el response ${response.data}');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future actualizar_empleado(UserModel user) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}usuario.php?op=registar');
      response = await dio.post('${uriP}usuario.php?op=update_admin',
          data: user.update(), options: options2);
      print('el response  ${response.data.toString()}....');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future eliminar_empleado(id_usuario) async {
    var datos = {"id_usuario": id_usuario};
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}usuario.php?op=eliminar_admin');
      response = await dio.post('${uriP}usuario.php?op=eliminar_admin',
          data: datos, options: options2);
      print('el response  ${response.data.toString()}....');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future <UserModel?> getUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var usu = sp.getString("usuario");
    print('usu ${usu}');
    if(usu != null){
      user = UserModel.fromJson2(json.decode(usu));
    }
    return user;
  }
}
