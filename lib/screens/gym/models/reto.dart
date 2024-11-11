import 'package:administrador/screens/Autentificacion/Model/user_model.dart';

class RetoModel {
  late String? nombre;
  late String? objetivos;
  late String? descripcion;
  late String? imagen;
  late String? premio;

  late int? fileid;
  late int? nivel;
  late int? id_reto = 0;
  late String? fecha_inicio;
  late String? fecha_fin;
  late List<UserModel>? users = [];
  late List<UserModel>? ganadores = [];
  RetoModel(
      {this.id_reto,
      this.nombre,
      this.objetivos,
      this.descripcion,
      this.imagen,
      this.premio,
      this.nivel,
      this.fileid,
      this.fecha_fin,
        this.ganadores,this.users,
      this.fecha_inicio});

  factory RetoModel.fromJson2(Map<String, dynamic> json) {
    return RetoModel(
      id_reto: int.parse(json["id_reto"]),
      fileid: int.parse(json["fileid"]),
      nivel: int.parse(json["nivel"]),
      nombre: json["nombre"],
      objetivos: json["objetivos"],
      descripcion: json["descripcion"],
      imagen: json["imagen"],
      premio: json["premio"],
      fecha_inicio: json["fecha_inicio"],
      fecha_fin: json["fecha_fin"],
    );
  }
  factory RetoModel.fromJson(Map<String, dynamic> json) {
    return RetoModel(
      id_reto: int.parse(json["reto"]["id_reto"]),
      fileid: int.parse(json["reto"]["fileid"]),
      nivel: int.parse(json["reto"]["nivel"]),
      nombre: json["reto"]["nombre"],
      objetivos: json["reto"]["objetivos"],
      descripcion: json["reto"]["descripcion"],
      imagen: json["reto"]["imagen"],
      premio: json["reto"]["premio"],
      fecha_inicio: json["reto"]["fecha_inicio"],
      fecha_fin: json["reto"]["fecha_fin"],
      users: (json["datos"]["usuarios"] as List).map((i) => UserModel.fromJson3(i)).toList(),
      ganadores: (json["datos"]["ganadores"] as List).map((i) => UserModel.fromJson3(i)).toList(),
    );
  }

  Map toJson() => {
        "id_reto": id_reto,
        "nombre": nombre,
        "objetivos": objetivos,
        "descripcion": descripcion,
        "imagen": imagen,
        "premio": premio,
        "fileid": fileid,
        "fecha_inicio": fecha_inicio,
        "fecha_fin": fecha_fin,
        "nivel": nivel
      };
}
