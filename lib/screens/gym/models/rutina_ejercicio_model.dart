import 'package:administrador/screens/gym/models/ejercicio.dart';

class Rutina_Ejercicio_Model extends Ejercicio_Model{
  late int? id;
  late int? id_rutina;
  late int? id_ejercicio;
  late int? nivel;
  late int? series;
  late int? repeticiones;
  late int? asignado_a;
  late int? tipo_usuario;

  Rutina_Ejercicio_Model(
      {this.id,
      this.id_rutina,
      this.id_ejercicio,
      this.nivel,
      this.series,
      this.repeticiones,
      this.asignado_a,this.tipo_usuario}): super();

     Rutina_Ejercicio_Model.fromJson(Map<String, dynamic> json):
      id= int.parse(json["id"]),
      id_rutina= int.parse(json["id_rutina"]),
      id_ejercicio= int.parse(json["id_ejercicio"]),
      nivel= int.parse(json["nivel"]),
      series= int.parse(json["series"]),
      repeticiones= int.parse(json["repeticiones"]),
      asignado_a= int.parse(json["asignado_a"]);

     Rutina_Ejercicio_Model.fromJson2(Map<String, dynamic> json):
      id= int.parse(json["id"]),
      id_rutina= int.parse(json["id_rutina"]),
      id_ejercicio= int.parse(json["id_ejercicio"]),
      nivel= int.parse(json["nivel"]),
      series= int.parse(json["series"]),
      repeticiones= int.parse(json["repeticiones"]),
      asignado_a= int.parse(json["asignado_a"]),super.fromJson(json);

  Map toJson() => {
        "id": id,
        "id_rutina": id_rutina,
        "id_ejercicio": id_ejercicio,
        "nivel": nivel,
        "series": series,
        "repeticiones": repeticiones,
        "asignado_a": asignado_a,
        "tipo_usuario": tipo_usuario,
      };
}
