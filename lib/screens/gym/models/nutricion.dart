import 'package:administrador/screens/gym/models/comida.dart';

class NutricionModel {
  late int? id_nutricion;
  late int? asignado_a;
  late double? proteinas;
  late double? lipidos;
  late double? carbohidratos;
  late String? pre_ent;
  late String? entrenamiento;
  late String? despues;
  late String? suplementacion;
  late String? tips;
  late String? observaciones;
  late List<ComidaModel>? comidas;
  late String? created_at;

  NutricionModel(
      {this.asignado_a,
      this.proteinas,
      this.lipidos,
      this.carbohidratos,
      this.pre_ent,
      this.entrenamiento,
      this.despues,
      this.suplementacion,
      this.tips,
      this.observaciones,
      this.created_at,
      this.id_nutricion,
      this.comidas});

  NutricionModel.fromJson(Map<String, dynamic> json)
      : asignado_a = int.parse(json["asignado_a"]),
        id_nutricion = int.parse(json["id_nutricion"]),
        proteinas = double.parse(json["proteinas"]),
        lipidos = double.parse(json["lipidos"]),
        carbohidratos = double.parse(json["carbohidratos"]),
        pre_ent = json["pre_ent"],
        entrenamiento = json["entrenamiento"],
        despues = json["despues"],
        suplementacion = json["suplementacion"],
        tips = json["tips"],
        created_at = json["created_at"],
        observaciones = json["observaciones"];

  NutricionModel.historial(Map<String, dynamic> json)
      : asignado_a = int.parse(json["asignado_a"]),
        id_nutricion = int.parse(json["id_nutricion"]),
        proteinas = double.parse(json["proteinas"]),
        lipidos = double.parse(json["lipidos"]),
        carbohidratos = double.parse(json["carbohidratos"]),
        pre_ent = json["pre_ent"],
        entrenamiento = json["entrenamiento"],
        despues = json["despues"],
        suplementacion = json["suplementacion"],
        tips = json["tips"],
        created_at = json["created_at"],
        observaciones = json["observaciones"],
        comidas = (json["comidas"] as List)
            .map((i) => ComidaModel.fromJson(i))
            .toList();


  Map toJson() => {
        "asignado_a": asignado_a,
        "proteinas": proteinas,
        "lipidos": lipidos,
        "carbohidratos": carbohidratos,
        "pre_ent": pre_ent,
        "entrenamiento": entrenamiento,
        "despues": despues,
        "suplementacion": suplementacion,
        "tips": tips,
        "observaciones": observaciones,
        "created_at":
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      };
}
