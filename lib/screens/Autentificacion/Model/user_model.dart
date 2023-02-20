class UserModel {
  final String nombre;
  final String email;
  final String apellidos;
  final String password;
  final String celular;
  final int genero;
  final String fehca_nac;
  final int idU;
  final String imagenPerfil;
  final int peso;
  final int altura;
  final int tipo_user;
  final int enable;
  bool disponible;
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
