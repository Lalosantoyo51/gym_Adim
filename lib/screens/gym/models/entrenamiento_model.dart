
import 'dart:convert';

import 'package:administrador/screens/gym/models/dias.dart';
import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/serie.dart';

class Entrenamoento_Model {
  late int? id_ent;
  late String? nombre_ent;
  late String? fecha_inicio;
  late String? fecha_fin;
  late String? descanso;
  late int? intensidad;
  late String? ejercicio_cardio_vascular;
  late String? repeticiones_en_reserva;
  late String? observaciones;
  late int? creado_por;
  late int? typo_user;
  late int? disponible;
  late List<Entrenamiento_Eje>? ejercicios=[];
  late List<DiasModel>? dias=[];






  Entrenamoento_Model({
    this.id_ent,
    this.nombre_ent,
    this.fecha_inicio,
    this.fecha_fin,
    this.descanso,
    this.intensidad,
    this.ejercicio_cardio_vascular,
    this.repeticiones_en_reserva,
    this.observaciones,
    this.creado_por,
    this.typo_user,
    this.disponible,
    this.ejercicios,
    this.dias,
  });
  Entrenamoento_Model.fromJson(Map<String, dynamic> json)
      : id_ent = int.parse(json["id_ent"]),
        nombre_ent = json["nombre_ent"],
        fecha_inicio = json["fecha_inicio"],
        fecha_fin = json["fecha_fin"],
        descanso = json["descanso"],
        intensidad = int.parse(json["intensidad"]),
        ejercicio_cardio_vascular = json["ejercicio_cardio_vascular"],
        repeticiones_en_reserva = json["repeticiones_en_reserva"],
        observaciones = json["observaciones"],
        creado_por = int.parse(json["creado_por"]),
        typo_user = int.parse(json["typo_user"]),
        disponible = int.parse(json["disponible"]);


  Entrenamoento_Model.fromJson2(Map<String, dynamic> json)
      : id_ent = int.parse(json["id_ent"]),
        nombre_ent = json["nombre_ent"],
        fecha_inicio = json["fecha_inicio"],
        fecha_fin = json["fecha_fin"],
        descanso = json["descanso"],
        intensidad = int.parse(json["intensidad"]),
        ejercicio_cardio_vascular = json["ejercicio_cardio_vascular"],
        repeticiones_en_reserva = json["repeticiones_en_reserva"],
        observaciones = json["observaciones"],
        creado_por = int.parse(json["creado_por"]),
        typo_user = int.parse(json["typo_user"]),
        disponible = int.parse(json["disponible"]),
        dias = (json["dias"] as List)
            .map((i) =>  DiasModel.fromJson2(i))
            .toList();

  Map toJson() => {
    "nombre_ent":nombre_ent,
    "fecha_inicio":fecha_inicio,
    "fecha_fin":fecha_fin,
    "descanso":descanso,
    "intensidad":intensidad,
    "ejercicio_cardio_vascular":ejercicio_cardio_vascular,
    "repeticiones_en_reserva":repeticiones_en_reserva,
    "observaciones":observaciones,
    "creado_por":creado_por,
    "typo_user":typo_user
  };

}




