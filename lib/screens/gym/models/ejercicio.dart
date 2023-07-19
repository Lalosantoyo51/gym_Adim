import 'package:flutter/material.dart';

class Ejercicio_Model {
  late int? id_ejercicio;
  late int? id_ent;
  late int? id_cat_eje;
  late int? fileid;
  late int? disponible;
  late int? calificacion;
  late double? calorias;
  late String? nombre;
  late String? musculos_trabajados;
  late String? instrucciones;
  bool isActivo;


  Ejercicio_Model(
      {this.isActivo = true,
      this.id_ejercicio,
      this.id_ent,
      this.id_cat_eje,
      this.nombre,
      this.calificacion,
      this.calorias,
      this.musculos_trabajados,
      this.instrucciones,
      this.fileid,
      this.disponible});

  Ejercicio_Model.fromJson(Map<String, dynamic> json)
      : id_ejercicio = int.parse(json["id_ejercicio"]),
        id_cat_eje = int.parse(json["id_cat_eje"]),
        fileid = int.parse(json["fileid"]),
        disponible = int.parse(json["disponible"]),
        calificacion = json["calificacion"] != null
            ? int.parse(json["calificacion"])
            : null,
        calorias = double.parse(json["calorias"]),
        nombre = json["nombre"],
        musculos_trabajados = json["musculos_trabajados"],
        instrucciones = json["instrucciones"],
        isActivo = int.parse(json["disponible"]) == 1 ? true : false;

  Map toJson() => {
        "id_ent": id_ent,
        "id_ejercicio": id_ejercicio,
        "id_cat_eje": id_cat_eje,
        "fileid": fileid,
        "calorias": calorias,
        "nombre": nombre,
        "musculos_trabajados": musculos_trabajados,
        "instrucciones": instrucciones
      };
}
