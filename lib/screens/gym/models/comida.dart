class ComidaModel {
  late int id_comida;
  late int asignado_a;
  late int id_nutricion;
  late String titulo;
  late String descripcion;
  late String? hora;


  ComidaModel(this.titulo, this.descripcion, this.hora);

  ComidaModel.fromJson(Map<String, dynamic> json)
      : id_comida = int.parse(json["id_comida"]),
        asignado_a = int.parse(json["asignado_a"]),
        id_nutricion = int.parse(json["id_nutricion"]),
        titulo = json["titulo"],
        descripcion = json["descripcion"],
        hora = json["hora"];

  Map toJson() => {
    "asignado_a":asignado_a,
    "id_nutricion":id_nutricion,
    "titulo":titulo,
    "descripcion":descripcion,
    "hora":hora,
  };
}