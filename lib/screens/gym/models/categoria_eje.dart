class Categoria_eje {
  late int id_cat_eje;
  late String nombre;
  late String imagen;
  late int fileid;
  late int disponible;

  Categoria_eje({
    this.id_cat_eje = 0,
    required this.nombre,
    this.imagen="",
    this.disponible = 0,
    this.fileid = 0,
  });
  factory Categoria_eje.fromJson(Map<String, dynamic> json) {
    return Categoria_eje(
        id_cat_eje: int.parse(json["id_cat_eje"]),
        nombre: json["nombre"],
        imagen: json["imagen"],
        disponible: int.parse(json["disponible"]),
        fileid: int.parse(json["fileid"]),
    );
  }

  Map toJson() => {
    "id_cat_eje":id_cat_eje,
    "nombre":nombre,
    "imagen":imagen,
    "fileid":fileid
  };
}
