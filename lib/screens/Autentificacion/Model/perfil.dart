class PerfilModel {
  int? fileid;
  String? imagen = "";

  PerfilModel({this.fileid,this.imagen = ""});
  PerfilModel.fromJson(Map<String, dynamic> json)
      : fileid = json['fileid'] == null ?0: int.parse(json['fileid']),
        imagen = json['imagen'];


  Map toJson() => {
    'fileid': fileid,
    'imagen': imagen
  };


}
