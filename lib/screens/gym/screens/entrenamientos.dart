import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/create_entrenamiento.dart';
import 'package:administrador/screens/gym/screens/ejercicios_entrenamoento.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
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
      appBar: AppBar(
        title: Text("ENTRENAMIENTO"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.white),
          backgroundColor: Colors.black,
          onPressed: (){
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<provider_rutina>(create: (_) => provider_rutina()),
                ],
                builder: (context, child) => Create_Entrenamiento(),
              ),)
        );
      }),
      body: Container(
        width: width,
        height: height,
        child: ListView.builder(itemBuilder: (context, index) =>       Card(
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
                        Text(ent.entrenamientos[index].nombre_ent!),
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
                                Get.to(Ejercicios_Entrenamoento(entrenamiento: ent.entrenamientos[index]));
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.orange,
                                size: 25,
                              )),
                          IconButton(
                              onPressed: () {
                                //Navigator.of(context).push(
                                //    MaterialPageRoute(
                                //      builder: (BuildContext context) => MultiProvider(
                                //        providers: [
                                //          ChangeNotifierProvider<provider_cat_eje>(create: (_) => provider_cat_eje()),
                                //          ChangeNotifierProvider<provider_ejercicios>(create: (_) => provider_ejercicios()),
                                //        ],
                                //        builder: (context, child) => Categoria_ejercicio(proviene: "rutina",id_rutina: rutina.rutinas[index].id_rutina),
                                //      )));
                                //rutina.agregarSerie(context,rutina.rutinas[index].id_rutina);
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
        itemCount: ent.entrenamientos.length,),
      ),
    );
  }
}
