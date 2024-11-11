import 'package:administrador/screens/Autentificacion/Model/perfil.dart';
import 'package:administrador/screens/gym/models/dispositivo.dart';

class UserModel extends PerfilModel {
  late String nombre;
  late String email;
  late String apellidos;
  late String password;
  late String celular;
  late int genero;
  late String fehca_nac;
  late int idU;
  late int peso;
  late int altura;
  late int tipo_user;
  late int enable;
  bool disponible;
  bool? seleccionado = false;
  late List<DispositivoModel>? dispositivos = [];


  UserModel({
    String? imagen,
    int? fileid = 0,
    required this.nombre,
    required this.email,
    required this.celular,
    required this.genero,
    required this.fehca_nac,
    required this.apellidos,
    required this.password,
    required this.tipo_user,
    this.idU = 0,
    this.peso = 0,
    this.altura = 0,
    this.enable = 0,
    this.disponible = true,
    this.seleccionado = false,
    this.dispositivos,
  }) : super(fileid: fileid, imagen: imagen);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idU: int.parse(json['id_usuario']),
      tipo_user: int.parse(json['tipo_user']),
      nombre: json['nombre'],
      email: json['email'],
      apellidos: json['apellidos'],
      celular: json['celular'],
      genero: int.parse(json['genero']),
      fehca_nac: json['fehca_nac'],
      enable: int.parse(json['disponible']),
      fileid: json['fileid']!= null ?int.parse(json['fileid']): 0,
      imagen:json['imagen'] != null ?json["imagen"]: null,
      password: "",
    );
  }


  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
        idU: json['id_usuario'],
        tipo_user: json['tipo_user'],
        nombre: json['nombre'],
        email: json['email'],
        apellidos: json['apellidos'],
        celular: json['celular'],
        genero: json['genero'],
        fehca_nac: json['fehca_nac'],
        // enable:json['disponible'],
        password: "",
        fileid: json["fileid"],
        imagen: json["imagen"]
    );
  }
  UserModel.fromJsonDispositivo(Map<String, dynamic> json)
      : nombre = json["nombre"],
        email = json["email"],
        apellidos = json["apellidos"],
        password = json["password"],
        celular = json["celular"],
        genero = int.parse(json["genero"]),
        fehca_nac = json["fehca_nac"],
        idU = int.parse(json["id_usuario"]),
        peso = json["peso"],
        altura = json["altura"],
        tipo_user = int.parse(json["tipo_user"]),
        enable = json["enable"],
        disponible = true,
        dispositivos = (json["dispositivos"] as List)
            .map((i) => DispositivoModel.fromJson(i))
            .toList();

  UserModel.fromJson3(Map<String, dynamic> json)
      : idU = int.parse(json['id_usuario']),
        tipo_user = int.parse(json['tipo_user']),
        disponible = true,
        nombre = json['nombre'],
        email = json['email'],
        apellidos = json['apellidos'],
        celular = json['celular'],
        genero = int.parse(json['genero']),
        fehca_nac = json['fehca_nac'],
        enable = int.parse(json['disponible']),
        password = "",
        super.fromJson(json);


  factory UserModel.fromJson4(Map<String, dynamic> json) {
    return UserModel(
        idU: int.parse(json['id_usuario']),
        tipo_user:  int.parse(json['tipo_user']),
        nombre: json['nombre'],
        email: json['email'],
        apellidos: json['apellidos'],
        celular: json['celular'],
        genero: int.parse(json['genero']),
        fehca_nac: json['fehca_nac'],
        // enable:json['disponible'],
        password: "",
        fileid: int.parse(json['fileid']),
        imagen: json["imagen"]
    );
  }

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
        "imagen": imagen,
        "fileid": fileid
      };

  Map update() => {
        'id_usuario': idU,
        'nombre': nombre,
        "apellidos": apellidos,
        "celular": celular,
        "fehca_nac": fehca_nac,
      };
}
