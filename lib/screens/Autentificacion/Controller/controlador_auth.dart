import 'dart:convert';
import 'dart:io';
import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/screens/home.dart';
import 'package:administrador/screens/gym/screens/perfil/Profile.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      if(response.data == "Las credenciales no coinciden"){
        error(context);
      }else{
        user = UserModel.fromJson(json.decode(response.data)[0]);
        print('user ${user.enable}');
        if (user.tipo_user != 1 && user.enable == 1) {
          sp.setString("usuario",json.encode(user.toJson()));
          succes(context, user);
        }else{
          noFacultado(context);
          sp.clear();
        }
      }
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
            if (user.tipo_user != 1) {
              gets.Get.offAll(Profile());
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  error(context)async {
    await getUser();
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Adevertencia",
      desc: "Las credenciales no coinciden con nuestros registros.",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
  noFacultado(context)async {
    await getUser();
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "Este usuario no esta facultado para usar esta aplicacion",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
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
  Future insetDispositivo(int id_usuario, String token) async {

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}reto.php?op=insertDispositivo');
      response = await dio.post('${uriP}reto.php?op=insertDispositivo',
          data: {"id_usuario":id_usuario, "token":token}, options: options2);
      print('el response');
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }

  Future subirImagenUser(XFile? file, UserModel user, String accion)async{
    Response response;
    if(accion =="registrar" || accion == "actualizar" && file !=null){
      eliminarImagen(user.fileid);
      try{
        var datos = FormData.fromMap({
          "path" : '/Gym/perfil',
          "folderid" : 'd18523673530',
          'filename': await MultipartFile.fromFile(file!.path, filename:'${DateTime.now()}.jpg'),
        });
        response = await dio.post('${uri}uploadfile', options: options,data: datos );
        print('el response  ${response.data['metadata'][0]['fileid']}');
        int id = response.data['metadata'][0]['fileid'];
        user.fileid = id;
        return optenrInfoImagen(id,user,accion);
        //print('el response  ${json.decode(response.data['metadata'])}');
      }on DioError catch(e){
        print('sdsadsa ${e.error}');
      }
    }else{
      // return actualizar_cat_eje(cat,"");
    }
  }
  Future eliminarImagen(fileid, )async{
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
  Future optenrInfoImagen(int id,UserModel user,String accion)async{
    Response response;
    var datos = FormData.fromMap({
      "path" : '/Gym/perfil',
      "fileid" : id,
    });

    try{
      response = await dio.post('${uri}getfilepublink', options: options,data: datos );
      String url = response.data['code'];
      print('url $url');
      if(accion == "registrar" ){
        return registrarUsuario(user);
      }else if(accion == "actualizar"){
        return actualizarPerfil(user, url,id);
      }
    }on DioError catch(e){
      print('sdsadsa ${e.error}');
    }
  }
  actualizarPerfil(UserModel user, String img, int newid)async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    print("${uriP}usuario.php?op=UpdePerfilFoto");
    user.imagen = "https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto";
    sp.setString("usuario",json.encode(user.toJson()));

    try{
      response = await dio.post('${uriP}usuario.php?op=UpdePerfilFoto', options: options2,data: {
        "id_usuario": user.idU,
        "fileid": newid,
        "imagen":'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto'
      });
      print('url $img');
      print('${response.data}');
    }on DioError catch(e){
      print('sdsadsa ${e.error}');
    }
  }
}
