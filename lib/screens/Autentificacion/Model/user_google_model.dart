class UserGoogleModel {
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;

  UserGoogleModel(
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
  );

  Map<String, dynamic> toJson() => {
        'nombre': displayName,
        'email': email,
        "celular": phoneNumber,
        "foto": photoURL,
      };
}
