class Entrenamiento_Eje{
  late int id_ent;
  late int id_rutina;
  late int id_serie;
  late int id_ejercicio;
  late int asignado_a;
  late int num_dia;
  late String serie;
  late String repeticion;
  late String? nombre;
  late String? id_eje_ent;
  late String? cant_serie;
  late String? id_cat_eje;
  late String? calificacion;
  late String? calorias;
  late String? musculos_trabajados;
  late String? instrucciones;
  late String? fileid;


  Entrenamiento_Eje({
    required this.id_ent,
    required this.id_rutina,
    required this.id_serie,
    required this.id_ejercicio,
    required this.serie,
    required this.repeticion,
    required this.num_dia,
    required this.asignado_a,
    this.id_eje_ent,
    this.cant_serie,
    this.id_cat_eje,
    this.calificacion,
    this.calorias,
    this.musculos_trabajados,
    this.instrucciones,
    this.fileid,
    this.nombre
  });


  Entrenamiento_Eje.fromJson(Map<String, dynamic> json)
      : id_ent = int.parse(json["id_ent"]),
        asignado_a = int.parse(json["asignado_a"]),
        id_rutina = int.parse(json["id_rutina"]),
        id_serie = int.parse(json["id_serie"]),
        id_ejercicio = int.parse(json["id_ejercicio"]),
        num_dia = int.parse(json["num_dia"]),
        serie = json["repeticiones_en_reserva"],
        repeticion = json["observaciones"];

  Entrenamiento_Eje.fromJson2(Map<String, dynamic> json)
      : id_ent = int.parse(json["id_ent"]),
        asignado_a = int.parse(json["asignado_a"]),
        id_rutina = int.parse(json["id_rutina"]),
        id_serie = int.parse(json["id_serie"]),
        id_ejercicio = int.parse(json["id_ejercicio"]),
        num_dia = int.parse(json["num_dia"]),
        serie = json["serie"],
        repeticion = json["observaciones"],
        id_eje_ent = json["id_eje_ent"],
        cant_serie = json["cant_serie"],
        id_cat_eje = json["id_cat_eje"],
        calificacion = json["calificacion"],
        calorias = json["calorias"],
        musculos_trabajados = json["musculos_trabajados"],
        instrucciones = json["instrucciones"],
        nombre = json["nombre"],
        fileid = json["fileid"];

  Map toJson() => {
    "id_ent": id_ent,
    "id_rutina": id_rutina,
    "id_serie": id_serie,
    "id_ejercicio": id_ejercicio,
    "serie": serie,
    "repeticion": repeticion,
    "asignado_a": asignado_a,
    "num_dia": num_dia
  };
}