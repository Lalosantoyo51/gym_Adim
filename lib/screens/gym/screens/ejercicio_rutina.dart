import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/reproductor.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Ejercicio_Rutina extends StatefulWidget {
  int id_rutina;
  Ejercicio_Rutina({Key? key,required this.id_rutina})
      : super(key: key);

  @override
  State<Ejercicio_Rutina> createState() => _Ejercicio_RutinaState();
}

class _Ejercicio_RutinaState extends State<Ejercicio_Rutina> {

  @override
  void initState() {
    // TODO: implement initState
    geteje();
    super.initState();
  }


  geteje() {
    // TODO: implement initState
    final ejercicio = Provider.of<provider_rutina>(context, listen: false);
    ejercicio.getEjerciciosRutina(widget.id_rutina);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final rutina = Provider.of<provider_rutina>(context);
    return Container(
      height: height,
      width: width,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Ejercicios ${rutina
                  .ejercicios_rutina.length}"),
              centerTitle: true),
          body: rutina
              .ejercicios_rutina.isNotEmpty ?ListView.builder(
            itemCount:rutina
                .ejercicios_rutina.length ,
            itemBuilder: (context, index) => Card(child: buildPadding(width, index, context, height,rutina))):const Center(child: Text("No hay registros",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),)));
  }
 
  Padding buildPadding(double width,  int index, BuildContext context, double height,provider_rutina rutina) {
    return Padding(
          padding:
          const EdgeInsets.only(top: 5,bottom: 5 ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        rutina.
                        ejercicios_rutina[
                        index]
                            .nombre!,
                        style: Theme.of(context)
                            .textTheme
                            .headline5,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                      ),
                      Text(
                        "Series ${rutina
                            .ejercicios_rutina[
                        index].series}",
                      ),
                      Text(
                        "Repeticiones ${rutina
                            .ejercicios_rutina[
                        index].repeticiones}",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Nivel",
                          ),
                          SizedBox(width: 25,),
                          Nivel(
                            initialRating:
                            double.parse(rutina
                                .ejercicios_rutina[
                            index].nivel.toString()),
                            size: width * .05,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Acciones"),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(Reproductor(fieldid: rutina
                                    .ejercicios_rutina[
                                index].fileid!));
                              },
                              icon: const Icon(
                                Icons.video_library_rounded,
                                color: Colors.green,
                                size: 25,
                              )),
                          IconButton(
                              onPressed: () {
                                rutina.eliminar_ejercicio_rutina(rutina
                                    .ejercicios_rutina[
                                index].id_rutina, rutina
                                    .ejercicios_rutina[
                                index].id_ejercicio).then((value) => geteje());
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
              )
            ],
          ),
        );
  }
}
