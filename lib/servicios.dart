import 'dart:io';

import 'package:dio/dio.dart';



class ImageService{
  var dio = Dio();
  String uri= "https://api.pcloud.com/";

  // or new Dio with a BaseOptions instance.
  var options = Options(
    headers:{
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'authorization' : 'Bearer JtCj7ZrO7sAKRKs9bZ6Yx3c7ZvO3I6MxTufuvB3nvOt0dW4WASbg7'
    }
  );

  subirImagen(File file)async{
    Response response;
    var datos = FormData.fromMap({
      "path" : '/My Pictures',
      "folderid" : '14905871934',
      'filename': await MultipartFile.fromFile(file.path, filename:'hola.jpg'),
    });

    try{
      response = await dio.post('${uri}uploadfile', options: options,data: datos );
      print('el response  ${response.data}');
    }on DioError catch(e){
      print('sdsadsa ${e.error}');
    }
  }

}