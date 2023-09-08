class DispositivoModel {
  late int? id_dispositivo;
  late int? id_usuario;
  late String? token;

  DispositivoModel({
    this.id_dispositivo,
    this.id_usuario,
    this.token,
  });

  DispositivoModel.fromJson(Map<String, dynamic> json):
  id_dispositivo =int.parse(json["id_dispositivo"]),
  id_usuario =int.parse(json["id_usuario"]),
  token =json["token"];

}
