import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/ejercicio_rutina.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Rutina extends StatefulWidget {
  const Rutina({Key? key}) : super(key: key);

  @override
  State<Rutina> createState() => _RutinaState();
}

class _RutinaState extends State<Rutina> {
  @override
  void initState() {
    // TODO: implement initState
    getRutina();
    super.initState();
  }

  getRutina() {
    // TODO: implement initState
    final rutina = Provider.of<provider_rutina>(context, listen: false);
    rutina.getRutina();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final rutina = Provider.of<provider_rutina>(context);

    return Container(
      width: width,
      height: height,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Rutinas"),
            backgroundColor: Colors.black,
            centerTitle: true),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
            rutina.agregarRutina(context);
            },
            backgroundColor: Colors.black,
            child: Icon(Icons.add)),
        //child: cat_eje_provider.isAgregar == false ? Icon(Icons.add) : Icon(Icons.cancel)),
        body: rutina.rutinas.isNotEmpty
            ? ListView.builder(
                itemCount: rutina.rutinas.length,
                itemBuilder: (context, index) => Container(
                  child: cardInfo(rutina, index),
                ),
              )
            : const Center(
                child: Text(
                "No hay Rutina",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )),
      ),
    );
  }

  Padding cardInfo(provider_rutina rutina, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/aptitud-fisica.png",
                  scale: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nombre de la rutina"),
                      Text(rutina.rutinas[index].nombre!),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Acciones"),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {Get.to(Ejercicio_Rutina(id_rutina: rutina.rutinas[index].id_rutina!,));
                            },
                            icon: const Icon(
                              Icons.list,
                              color: Colors.orange,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider<provider_cat_eje>(create: (_) => provider_cat_eje()),
                                        ChangeNotifierProvider<provider_ejercicios>(create: (_) => provider_ejercicios()),
                                      ],
                                      builder: (context, child) => Categoria_ejercicio(proviene: "rutina",id_rutina: rutina.rutinas[index].id_rutina),
                                    ),)
                              );
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.green,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              rutina.advertencia(context,  rutina.rutinas[index].id_rutina!);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 25,
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01,bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(Usuarios(provine: "rutina",id_rutina: rutina.rutinas[index].id_rutina!,));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    BottomGradiant(
                      colorFinal: const Color.fromRGBO(238, 70, 61, 1),
                      colorInicial: const Color.fromRGBO(255, 138, 95, 1),
                      width: MediaQuery.of(context).size.width * .75,
                      heigth: MediaQuery.of(context).size.height * .04,
                    ),
                    Text(
                      "Asignar usuario",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
