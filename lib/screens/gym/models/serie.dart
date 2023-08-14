import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/rutina_model.dart';

class SerieModel {
  late int? id_serie;
  late int? id_rutina;
  late String? serie;
  List<Rutina_Ejercicio_Model>? ejercicios = [];
  List<Entrenamiento_Eje>? ejerciciosEnt = [];

  SerieModel({this.id_serie, this.serie, this.id_rutina, this.ejercicios});
  SerieModel.fromJson(Map<String, dynamic> json)
      : id_serie = int.parse(json["id_serie"]),
        serie = json["serie"],
        ejercicios = (json["ejercicios"] as List)
            .map((i) => Rutina_Ejercicio_Model.fromJson2(i))
            .toList();
  SerieModel.fromJson2(Map<String, dynamic> json)
      : id_serie = int.parse(json["id_serie"]),
        serie = json["serie"];
  SerieModel.fromJson3(Map<String, dynamic> json)
      : id_serie = int.parse(json["id_serie"]),
        serie = json["serie"],
        ejercicios = (json["ejercicios"] as List)
            .map((i) => Rutina_Ejercicio_Model.fromJson3(i))
            .toList();

  SerieModel.fromJson4(Map<String, dynamic> json)
      : id_serie = int.parse(json["id_serie"]),
        serie = json["serie"],
        ejerciciosEnt = (json["ejercicios"] as List)
            .map((i) => Entrenamiento_Eje.fromJson2(i))
            .toList();

  Map toJson() =>
      {"id_serie": id_serie, "id_rutina": id_rutina, "serie": serie};
}
