import 'dart:convert';
import 'dart:io';

import 'package:administrador/enviroments.dart';
import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class Api_cat{
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

  Future<List<Categoria_eje>> get_eje_cat()async{
    List<Categoria_eje> categorias = [];

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}categoria.php?op=get_categorias_eje');
      response = await dio.get('${uriP}categoria.php?op=get_categorias_eje', options: options2);
      print('el response ${response.data}');
      categorias = (json.decode(response.data) as List)
          .map((data) => Categoria_eje.fromJson(data))
          .toList();
      return categorias;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return categorias;
  }

  Future  subirImagenCatEje(XFile? file, Categoria_eje cat, String accion)async{
    Response response;

    if(accion =="registrar" || accion == "actualizar" && file !=null){
      eliminarImagen(cat.fileid);
      try{
        var datos = FormData.fromMap({
          "path" : '/Gym/categoria_ejercicio',
          "folderid" : 'd16259436692',
          'filename': await MultipartFile.fromFile(file!.path, filename:'${DateTime.now()}.jpg'),
        });
        response = await dio.post('${uri}uploadfile', options: options,data: datos );
        print('el response  ${response.data['metadata'][0]['fileid']}');
        int id = response.data['metadata'][0]['fileid'];
        cat.fileid = id;
        return optenrInfoImagen(id,cat,accion);
        //print('el response  ${json.decode(response.data['metadata'])}');
      }on DioError catch(e){
        print('sdsadsa ${e.error}');
      }
    }else{
      return actualizar_cat_eje(cat,"");
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

  Future  optenrInfoImagen(int id,Categoria_eje cat,String accion)async{
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
        return insertarCat_eje(cat, url);
      }else if(accion == "actualizar"){
        return actualizar_cat_eje(cat, url);
      }
    }on DioError catch(e){
      print('sdsadsa ${e.error}');
    }
  }

  Future <Categoria_eje?> insertarCat_eje(Categoria_eje cat, img) async{
    cat.imagen = 'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    Categoria_eje? cate;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}categoria.php?op=insert_cat_eje');
      response = await dio.post('${uriP}categoria.php?op=insert_cat_eje',
          data: cat.toJson(), options: options2);
      print('el response ${response.data}');
      return Categoria_eje.fromJson(json.decode(response.data)[0]);

    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return cate;
  }
  Future  actualizar_cat_eje(Categoria_eje cat , img ) async{
    if(img != ""){
      cat.imagen = 'https://api.pcloud.com/getpubthumb?code=$img&linkpassword=undefined&size=1920x1440&crop=0&type=auto';
    }
    Categoria_eje? cate;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      print('${uriP}categoria.php?op=actualizar_cat_eje');
      response = await dio.post('${uriP}categoria.php?op=actualizar_cat_eje',
          data: cat.toJson(), options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
    return cate;
  }

  Future eliminar_cat_eje(id_cat_eje,fileid)async{
    var datos = {
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
      eliminarImagen(fileid);
      print('${uriP}categoria.php?op=eliminar_cat_eje');
      response = await dio.post('${uriP}categoria.php?op=eliminar_cat_eje',
          data: datos, options: options2);
      print('el response ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print('el error ${e.error}');
    }
  }
}