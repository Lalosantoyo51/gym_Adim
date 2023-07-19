import 'package:administrador/screens/gym/models/serie.dart';

class DiasModel {
 late int? id_ent;
 late int? id_rutina;
 late int? num_dia;
 late String dia;
 late bool enable;
 late List<SerieModel>? series = [];

  DiasModel(
      {required this.dia,
      this.enable = false,
      this.id_rutina,
      this.id_ent,
      this.num_dia,this.series});

  DiasModel.fromJson(Map<String, dynamic> json)
      : id_ent = int.parse(json["id_ent"]),
        id_rutina = int.parse(json["id_rutina"]),
        num_dia = int.parse(json["num_dia"]);

 DiasModel.fromJson2(Map<String, dynamic> json)
     :num_dia = int.parse(json["num_dia"]),
       series= (json["series"] as List)
     .map((i) =>  SerieModel.fromJson3(i))
     .toList();

 Map toJson() => {
   "id_ent": id_ent,
   "id_rutina": id_rutina,
   "num_dia": num_dia,
   };
}
