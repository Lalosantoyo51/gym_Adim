class NovedadModel {
  late int? id_novedad;
  late int? fileid;
  late String? titulo;
  late String? imagen;
  late String? fecha_inicio;
  late String? fecha_fin;
  late String? create_at;
  late int? disponible;

  NovedadModel(
      {this.id_novedad,
      this.fileid,
      this.titulo,
      this.imagen,
      this.fecha_inicio,
      this.fecha_fin,
      this.create_at,
      this.disponible});

  NovedadModel.fromJson(Map<String, dynamic> json)
      : id_novedad = int.parse(json["id_novedad"]),
        fileid = int.parse(json["fileid"]),
        titulo = json["titulo"],
        imagen = json["imagen"],
        fecha_inicio = json["fecha_inicio"],
        fecha_fin = json["fecha_fin"],
        create_at = json["create_at"],
        disponible = int.parse(json["disponible"]);

  Map toJson() => {
    "fileid": fileid,
    "titulo": titulo,
    "imagen": imagen,
    "disponible": disponible,
    "fecha_inicio": fecha_inicio,
    "fecha_fin": fecha_fin,
    "create_at": create_at,
  };

  Map actualizar() => {
    "id_novedad": id_novedad,
    "fileid": fileid,
    "titulo": titulo,
    "imagen": imagen,
    "disponible": disponible,
    "fecha_inicio": fecha_inicio,
    "fecha_fin": fecha_fin,
    "create_at": create_at,
  };
}
