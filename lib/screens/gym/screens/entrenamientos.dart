import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/create_entrenamiento.dart';
import 'package:administrador/screens/gym/screens/ejercicios_entrenamoento.dart';
import 'package:administrador/screens/gym/screens/home.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Entrenamiento extends StatefulWidget {
  const Entrenamiento({Key? key}) : super(key: key);

  @override
  State<Entrenamiento> createState() => _EntrenamientoState();
}

class _EntrenamientoState extends State<Entrenamiento> {
  @override
  void initState() {
    // TODO: implement initState
    getEntrenamiento();
    super.initState();
  }

  getEntrenamiento() async {
    // TODO: implement initState
    final entrenamiento_p =
        Provider.of<provider_entrenamiento>(context, listen: false);
    entrenamiento_p.getEntrenamientos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ent = Provider.of<provider_entrenamiento>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await ent.getUser();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("ENTRENAMIENTO"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(
                      create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Create_Entrenamiento(),
              ),
            ));
          }),
      body: ent.loading == true
          ? LoadingAlert("Cargando...")
          : Stack(
              children: [
                Container(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Input2(
                        texto: "Buscar",
                        onChanged: (value) => ent.buscarP(value),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: height / 1.4,
                        child: ListView.builder(
                          itemBuilder: (context, index) => card(
                              ent,
                              ent.entrenamientosBuscar.isEmpty
                                  ? ent.entrenamientos[index]
                                  : ent.entrenamientosBuscar[index]),
                          itemCount: ent.entrenamientosBuscar.isEmpty
                              ? ent.entrenamientos.length
                              : ent.entrenamientosBuscar.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Container card(
      provider_entrenamiento ent, Entrenamoento_Model entrenamiento) {

    return Container(
      child: GestureDetector(
        onTap: () {
          Get.to(Ejercicios_Entrenamoento(entrenamiento: entrenamiento));
        },
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entrenamiento.nombre_ent!.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
                                Get.to(Usuarios(
                                  provine: "entrenamiento",
                                  id_ent: entrenamiento.id_ent,
                                  entrenamientos:
                                  ent.entrenamientos,
                                  ent: entrenamiento,
                                ));
                              },
                              icon: const Icon(
                                Icons.person,
                                color: Color.fromRGBO(6, 19, 249, 1),
                                size: 25,
                              )),
                          IconButton(
                              onPressed: () {
                                ent.advertencia(context, entrenamiento.id_ent!);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.black,
                                size: 25,
                              )),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
