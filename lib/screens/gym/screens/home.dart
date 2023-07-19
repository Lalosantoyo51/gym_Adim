import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/create_entrenamiento.dart';
import 'package:administrador/screens/gym/screens/entrenamientos.dart';
import 'package:administrador/screens/gym/screens/rutina.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatelessWidget {
  UserModel user;
   HomeAdmin({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
            menu(context,width, height),
            Container(width: width/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bienvenido",style: TextStyle(fontSize: 30)),
                   Text("${user.nombre} ${user.apellidos} ",style: TextStyle(fontSize: 30)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container menu(context,double width, double height) {
    return Container(
            width: width / 2,
            height: height,
            color: Colors.black,
            child: Column(
              children: [
                CircleAvatar(
                  radius: width * .15,
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
                options(width,"Usuarios",() => Get.to(Usuarios(provine: "home",))),
                options(width,"Categoria Ejercicio",(){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                    builder: (BuildContext context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<provider_cat_eje>(create: (_) => provider_cat_eje()),
                        ChangeNotifierProvider<provider_ejercicios>(create: (_) => provider_ejercicios()),
                      ],
                      builder: (context, child) => Categoria_ejercicio(proviene: "home"),
                    ),)
                  );

                }),
                const SizedBox(
                  height: 5,
                ),
                options(width,"Rutina",() {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<provider_rutina>(create: (_) => provider_rutina()),
                          ],
                          builder: (context, child) => Rutina(),
                        ),)
                  );

                }),
                const SizedBox(
                  height: 5,
                ),
                options(width,"Entrenamiento",() {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<provider_rutina>(create: (_) => provider_rutina()),
                          ],
                          builder: (context, child) => Entrenamiento(),
                        ),)
                  );

                }),
              ],
            ),
          );
  }

  InkWell options(double width,String txt,VoidCallback action) {
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
            style:const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ))),
    );
  }
}
