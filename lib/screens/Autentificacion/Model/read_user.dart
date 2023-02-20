import 'dart:convert';

//List<ReadUser> readUserFromJson(String str) =>
//  List<ReadUser>.from(json.decode(str).map((x) => ReadUser.fromJson(x)));

String readUserToJson(List<ReadUser> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class ReadUser {
  String nombre;
  String email;
  int celular;
  String sexo;
  String nacimiento;
  String imagenPerfil;
  int peso;
  int altura;

  ReadUser({
    required this.nombre,
    required this.email,
    required this.celular,
    required this.sexo,
    required this.nacimiento,
    required this.imagenPerfil,
    required this.peso,
    required this.altura,
  });

  ReadUser copyWith({
    String? nombre,
    String? email,
    int? celular,
    String? sexo,
    String? nacimiento,
    String? imagenPerfil,
    int? peso,
    int? altura,
  }) =>
      ReadUser(
        nombre: nombre ?? this.nombre,
        email: email ?? this.email,
        celular: celular ?? this.celular,
        sexo: sexo ?? this.sexo,
        nacimiento: nacimiento ?? this.nacimiento,
        imagenPerfil: imagenPerfil ?? this.imagenPerfil,
        peso: peso ?? this.peso,
        altura: altura ?? this.altura,
      );

  factory ReadUser.fromJson(Map<String, dynamic> json) => ReadUser(
        nombre: json["nombre"].toString(),
        email: json["email"].toString(),
        celular: int.parse(json["celular"].toString()),
        sexo: json["sexo"].toString(),
        nacimiento: json["nacimiento"].toString(),
        imagenPerfil: json["imagenPerfil"].toString(),
        peso: int.parse(json["peso"].toString()),
        altura: int.parse(json["altura"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "celular": celular,
        "sexo": sexo,
        "nacimiento": nacimiento,
        "imagenPerfil": imagenPerfil,
        "peso": peso,
        "altura": altura,
      };
}
