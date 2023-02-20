class Rutina_Model{
  late int? id_rutina;
  late int? id_usuario;
  late String? nombre;
  late int? tipo_user;

  Rutina_Model({
    this.id_rutina,
    this.id_usuario,
    this.nombre,
    this.tipo_user});


  factory Rutina_Model.fromJson(Map<String, dynamic> json) {
    return Rutina_Model(
      id_rutina:int.parse(json["id_rutina"]),
      id_usuario:int.parse(json["id_usuario"]),
      nombre:json["nombre"],
      tipo_user:int.parse(json["tipo_user"]),

    );
  }

  Map toJson() => {
    "id_rutina": id_rutina,
    "id_usuario": id_usuario,
    "nombre": nombre,
    "tipo_user": tipo_user
  };

}