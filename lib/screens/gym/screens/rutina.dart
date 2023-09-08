import 'package:administrador/screens/gym/models/rutina_model.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/ejercicio_rutina.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'home.dart';

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
    print('aaaa');
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Get.offAll(HomeAdmin(
                    user: rutina.user!,
                  ));
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text("Rutinas"),
            backgroundColor: Colors.black,
            centerTitle: true),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              rutina.agregarRutina(context);
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add)),
        //child: cat_eje_provider.isAgregar == false ? Icon(Icons.add) : Icon(Icons.cancel)),
        body: rutina.loading == true
            ? LoadingAlert("Cargando...")
            : rutina.rutinas.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                          child: Input2(
                        texto: "Buscar",
                        onChanged: (value) => rutina.buscarP(value),
                      )),
                      SizedBox(
                        height: height / 1.4,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:  rutina.rutinasBuscar.isEmpty
                              ? rutina.rutinas.length: rutina.rutinasBuscar.length,
                          itemBuilder: (context, index) => Container(
                            child: cardInfo(
                                rutina,
                                rutina.rutinasBuscar.isEmpty
                                    ? rutina.rutinas[index]
                                    : rutina.rutinasBuscar[index]),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                    "No hay Rutina",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
      ),
    );
  }

  Padding cardInfo(provider_rutina rutinap, Rutina_Model rutina) {
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
                      Text(rutina.nombre!),
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
                            onPressed: () {
                              Get.to(Ejercicio_Rutina(
                                id_rutina: rutina.id_rutina!,
                              ));
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.orange,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              rutinap.agregarSerie(context, rutina.id_rutina);
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              rutinap.advertencia(context, rutina.id_rutina!);
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
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  // Get.to(Usuarios(provine: "rutina",id_rutina: rutina.rutinas[index].id_rutina!,));
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
