import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:flutter/cupertino.dart';

class Rutina_Ejercicio_Model extends Ejercicio_Model {
  late int? id;
  late int? id_rutina;
  late int? id_ejercicio;
  late int? id_serie;
  late int? nivel;
  late String? series;
  late int? repeticiones;
  late int? asignado_a;
  late int? tipo_usuario;

  Rutina_Ejercicio_Model(
      {this.id,
      this.id_rutina,
      this.id_ejercicio,
      this.id_serie,
      this.nivel,
      this.series,
      this.repeticiones,
      this.asignado_a,
      this.tipo_usuario = 1})
      : super();

  Rutina_Ejercicio_Model.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        id_rutina = int.parse(json["id_rutina"]),
        id_ejercicio = int.parse(json["id_ejercicio"]),
        id_serie = int.parse(json["id_serie"]),
        nivel = int.parse(json["nivel"]),
        series = "0",
        repeticiones = 0,
        asignado_a = int.parse(json["asignado_a"]);

  Rutina_Ejercicio_Model.fromJson2(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        id_rutina = int.parse(json["id_rutina"]),
        id_ejercicio = int.parse(json["id_ejercicio"]),
        id_serie = int.parse(json["id_serie"]),
        nivel = int.parse(json["nivel"]),   series = "0",
        repeticiones = 0,
        tipo_usuario = 1,
      asignado_a = int.parse(json["asignado_a"]),
        super.fromJson(json);

  Rutina_Ejercicio_Model.fromJson3(Map<String, dynamic> json)
      : id = int.parse(json["id_eje_ent"]),
        id_rutina = int.parse(json["id_rutina"]),
        id_ejercicio = int.parse(json["id_ejercicio"]),
        id_serie = int.parse(json["id_serie"]),
        series = json["seriess"],
        repeticiones = int.parse(json["repeticion"]),
        tipo_usuario = 1,
        asignado_a = int.parse(json["asignado_a"]),
        super.fromJson(json);

  Map toJson() => {
        "id": id,
        "id_rutina": id_rutina,
        "id_ejercicio": id_ejercicio,
        "id_serie": id_serie,
        "nivel": nivel,
        "series": series,
        "repeticiones": repeticiones,
        "asignado_a": asignado_a,
        "tipo_usuario": tipo_usuario,
      };
}
