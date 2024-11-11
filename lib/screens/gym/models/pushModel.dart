class PushModel {
  late int? id_push;
  late int? id_usuario;
  late String? asunto;
  late String? imagen;
  late String? create_at;

  PushModel(
      {this.id_push,
      this.id_usuario,
      this.asunto,
      this.imagen,
      this.create_at});

  PushModel.fromJson(Map<String, dynamic> json)
      : id_push = int.parse(json["id_push"]),
        id_usuario = int.parse(json["id_usuario"]),
        asunto = json["asunto"],
        imagen = json["imagen"],
        create_at = json["create_at"];


}
