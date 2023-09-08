class AsistenciaModel {
  int? id_usuario;
  String? nombre;
  String? apellido;
  String? email;
  List<dynamic>? asistencia = [];

  AsistenciaModel(
      {this.id_usuario,
      this.nombre,
      this.apellido,
      this.email,
      this.asistencia});

  //"id_recep":
  //"id_usuario":
  //"fecha":

  AsistenciaModel.fromJson(Map<String, dynamic> json)
      : id_usuario = int.tryParse(json["id_usuario"]),
        nombre = json["nombre"],
        apellido = json["apellido"],
        email = json["email"],
        asistencia = (json["asistencia"] as List)
            .map((data) => {
                  "id_recep": data["id_recep"],
                  "id_usuario": data["id_usuario"],
                  "fecha": data["fecha"]
                }).toList();
}
