import 'package:administrador/presentation/blocs/notifications/bloc.dart';
import 'package:administrador/presentation/screens/home_screen.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/login.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/entrenamientos.dart';
import 'package:administrador/screens/gym/screens/novedades/form_novedades.dart';
import 'package:administrador/screens/gym/screens/novedades/historial.dart';
import 'package:administrador/screens/gym/screens/nutricion/usuarios.dart';
import 'package:administrador/screens/gym/screens/recepcion/generar_qr.dart';
import 'package:administrador/screens/gym/screens/retos/retosP.dart';
import 'package:administrador/screens/gym/screens/rutina.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends StatelessWidget {
  UserModel user;
  HomeAdmin({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final blocNoti = context.watch<NotificationsBloc>().state.notifications;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Inicio",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black),
      body: Container(
        width: width,
        height: height,
        child: Row(
          children: [
            menu(context, width, height),
            Container(
              width: width / 2,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Bienvenido", style: TextStyle(fontSize: 30)),
                        Text("${user.nombre} ${user.apellidos} ",
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: Stack(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.to(HomeScreen());
                            },
                            icon: const Icon(
                              size: 50,
                              Icons.notifications,
                              color: Colors.black,
                            )),
                        if(blocNoti.isNotEmpty)
                          CircleAvatar(
                            minRadius: 10,
                            child: Text("${blocNoti.length}"), backgroundColor: Colors.red,)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container menu(context, double width, double height) {
    return Container(
      width: width / 2,
      height: height,
      color: Colors.black,
      child: ListView(
        children: [
          CircleAvatar(
            radius: width * .10,
            child: ClipOval(
                child: Image.asset(
              'assets/HombreCaraPerfil.png',
              fit: BoxFit.cover,
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 5,
          ),
          options(
              width,
              "Usuarios",
              () => Get.to(Usuarios(
                    provine: "home",
                    entrenamientos: [],
                  ))),
          options(width, "Grupos Musculares", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_cat_eje>(
                      create: (_) => provider_cat_eje()),
                  ChangeNotifierProvider<provider_ejercicios>(
                      create: (_) => provider_ejercicios()),
                ],
                builder: (context, child) =>
                    Categoria_ejercicio(proviene: "home"),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Rutina", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Rutina(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Entrenamiento", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Entrenamiento(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Retos", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => RetosP(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Recepcion", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Genererar_QR(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Nutricion", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_nutricion>(
                      create: (_) => provider_nutricion()),
                ],
                builder: (context, child) => UsuarioNu(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),    options(width, "Novedades", () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_nutricion>(
                      create: (_) => provider_nutricion()),
                ],
                builder: (context, child) => HistorialNovedades(),
              ),
            ));
          }),
          const SizedBox(
            height: 5,
          ),
          options(width, "Salir", () async {
            SharedPreferences sp = await SharedPreferences.getInstance();
            sp.clear();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Login(),
              ),
            ));
          }),
        ],
      ),
    );
  }

  InkWell options(double width, String txt, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          width: width / 2,
          color: Colors.grey,
          child: Center(
              child: Text(
            txt,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ))),
    );
  }
}
