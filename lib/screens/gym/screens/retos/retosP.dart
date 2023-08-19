import 'package:administrador/screens/gym/models/reto.dart';
import 'package:administrador/screens/gym/providers/provider_reto.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/home.dart';
import 'package:administrador/screens/gym/screens/retos/retoEditar.dart';
import 'package:administrador/screens/gym/screens/retos/usuarios.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'retosCrear.dart';

class RetosP extends StatefulWidget {
  const RetosP({Key? key}) : super(key: key);

  @override
  State<RetosP> createState() => _RetosPState();
}

class _RetosPState extends State<RetosP> {
  getReto() {
    // TODO: implement initState
    final retoP = Provider.of<provider_reto>(context, listen: false);
    retoP.getRetos();
    retoP.getRetosHistorial();
    setState(() {});
  }

  @override
  void initState() {
    getReto();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final rutina = Provider.of<provider_rutina>(context);
    final retos = Provider.of<provider_reto>(context);

    return Container(
      width: width,
      height: height,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () async {
                    await rutina.getUser();
                    await Get.offAll(HomeAdmin(
                      user: rutina.user!,
                    ));
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: const Text("Retos"),
              backgroundColor: Colors.black,
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(child: Text("Acutal")),
                  Tab(child: Text("Historial")),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Stack(
                  children: [
                    activos(retos, height, width),
                    if (retos.isCargando == true) LoadingAlert("Cargando..."),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            Get.to(RetosCrear());
                          },
                          child: const Icon(Icons.add),
                        ))
                  ],
                ),
                Stack(
                  children: [
                    historial(retos, height, width),
                    if (retos.isCargando == true) LoadingAlert("Cargando..."),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView activos(
    provider_reto retos,
    height,
    width,
  ) {
    return ListView.builder(
      itemCount: retos.listReto.length,
      itemBuilder: (BuildContext context, int index) {
        return cardCategoria(height, width, retos.listReto[index], retos,"act");
      },
    );
  }
  ListView historial(
    provider_reto retos,
    height,
    width,
  ) {
    return ListView.builder(
      itemCount: retos.listRetoHistorial.length,
      itemBuilder: (BuildContext context, int index) {
        return cardCategoria(height, width, retos.listRetoHistorial[index], retos,"his");
      },
    );
  }

  Container cardCategoria(
      double height, double width, RetoModel reto, provider_reto retos,String proviene) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Card(
            child: Container(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: height * .13,
                  width: width * .17,
                  child: Image.network(reto.imagen!),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reto.nombre!),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Acciones"),
                proviene == "act"?
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.to(RetoEditar(retoModel: reto));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.orange,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {
                          Get.to( usuariosReto(retoModel: reto,));
                          retos.userDisponibles.clear();
                          retos.userRetos.clear();
                          retos.addPerson = false;
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.green,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {
                          retos.advertencia(
                              context, reto.id_reto!, reto.fileid!,"reto");
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 25,
                        )),
                  ],
                ):  IconButton(
                    onPressed: () {
                     // Get.to( usuariosReto());
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.green,
                      size: 25,
                    )),
              ],
            ),
          ],
        ))));
  }
}
