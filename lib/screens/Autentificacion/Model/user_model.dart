import 'package:administrador/screens/gym/models/dispositivo.dart';

class UserModel{
  late String nombre;
  late String email;
  late String apellidos;
  late String password;
  late String celular;
  late int genero;
  late String fehca_nac;
  late int idU;
  late String imagenPerfil;
  late int peso;
  late int altura;
  late int tipo_user;
  late int enable;
  bool disponible;
  late List<DispositivoModel>? dispositivos =[];

  UserModel({

    required this.nombre,
    required this.email,
    required this.celular,
    required this.genero,
    required this.fehca_nac,
    required this.apellidos,
    required this.password,
    required this.tipo_user,
    this.idU = 0,
    this.imagenPerfil = "",
    this.peso = 0,
    this.altura = 0,
    this.enable = 0,
    this.disponible = true,
    this.dispositivos
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idU:int.parse(json['id_usuario']),
      tipo_user:int.parse(json['tipo_user']),
      nombre:json['nombre'],
      email:json['email'],
      apellidos:json['apellidos'],
      celular:json['celular'],
      genero:int.parse(json['genero']),
      fehca_nac:json['fehca_nac'],
      enable:int.parse(json['disponible']),
      password: "",
    );
  }

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
      idU:json['id_usuario'],
      tipo_user:json['tipo_user'],
      nombre:json['nombre'],
      email:json['email'],
      apellidos:json['apellidos'],
      celular:json['celular'],
      genero:json['genero'],
      fehca_nac:json['fehca_nac'],
      enable:json['disponible'],
      password: "",
    );
  }
  UserModel.fromJsonDispositivo(Map<String,dynamic> json):
        nombre = json["nombre"],
        email = json["email"],
        apellidos = json["apellidos"],
        password = json["password"],
        celular = json["celular"],
        genero = int.parse(json["genero"]),
        fehca_nac = json["fehca_nac"],
        idU = int.parse(json["id_usuario"]),
        imagenPerfil = json["imagenPerfil"],
        peso = json["peso"],
        altura = json["altura"],
        tipo_user = int.parse(json["tipo_user"]),
        enable = json["enable"],
        disponible = true,
        dispositivos =  (json["dispositivos"] as List)
            .map((i) => DispositivoModel.fromJson(i))
            .toList();


  Map toJson() => {
        'id_usuario': idU,
        'tipo_user': tipo_user,
        'nombre': nombre,
        'email': email,
        "apellidos": apellidos,
        "contrasena": password,
        "celular": celular,
        "genero": genero,
        "fehca_nac": fehca_nac,
      };

  Map update() => {
    'id_usuario': idU,
    'nombre': nombre,
    "apellidos": apellidos,
    "celular": celular,
    "fehca_nac": fehca_nac,
  };



}
