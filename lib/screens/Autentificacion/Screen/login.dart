import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Screen/registro.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  ControladorAuth auth = ControladorAuth();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: height * 0.01),
              child: Text(
                "Iniciar Sesión",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            Input(inputController: email, texto: "Email", isBlack: false),
            Input(
              inputController: contrasena,
              texto: "Contraseña",
              isBlack: false,
              obscureText: true,
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: height * .005, bottom: height * 0.01),
              child: GestureDetector(
                onTap: () {
                  auth.login(email.text, contrasena.text,context);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: BottomGradiant(
                        colorFinal: const Color.fromRGBO(0, 0, 0, 1),
                        colorInicial: const Color.fromRGBO(0, 0, 0, 1),
                        width: width * .8,
                        heigth: height * .065,
                      ),
                    ),
                    Text(
                      "Iniciar Sesión",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Recuperar Contraseña",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
