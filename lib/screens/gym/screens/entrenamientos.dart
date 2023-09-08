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
              await Get.offAll(HomeAdmin(
                user: ent.user!,
              ));
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
          : Container(
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
                    height: height/1.4,
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
    );
   }

  Container card(
      provider_entrenamiento ent, Entrenamoento_Model entrenamiento) {
    return Container(
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
                      Text(entrenamiento.nombre_ent!),
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
                              Get.to(Ejercicios_Entrenamoento(
                                  entrenamiento: entrenamiento));
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.orange,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              ent.advertencia(context, entrenamiento.id_ent!);
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
                  Get.to(Usuarios(
                    provine: "entrenamiento",
                    id_ent: entrenamiento.id_ent,
                    entrenamientos: ent.entrenamientos,
                  ));
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
