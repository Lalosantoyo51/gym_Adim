import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/reproductor.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Ejercicio_Rutina extends StatefulWidget {
  int id_rutina;
  Ejercicio_Rutina({Key? key, required this.id_rutina}) : super(key: key);

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
                title: Text("Ejercicios"),
                centerTitle: true),
            body: rutina.listSeries.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: rutina.listSeries.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Text(rutina.listSeries[index].serie!),
                        ColumnBuilder(
                              itemCount:
                                  rutina.listSeries[index].ejercicios!.length,
                              itemBuilder: (context, index2) => Card(
                                  child: buildPadding(width, index, index2, context,
                                      height, rutina,rutina.listSeries[index].serie!)),
                            ),
                      ],
                    ))
                : const Center(
                    child: Text("No hay registros",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  )));
  }

  Padding buildPadding(double width, int index, int index2,
      BuildContext context, double height, provider_rutina rutina,serie) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rutina.listSeries[index].ejercicios![index2].nombre!,
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Series ${rutina.listSeries[index].ejercicios![index2].series}",
                      ),
                      Text(
                        "Repeticiones ${rutina.listSeries[index].ejercicios![index2].repeticiones}",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Nivel",
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Nivel(
                            onChanged: (value) {},
                            isEnabled: false,
                            initialRating: rutina
                                .listSeries[index].ejercicios![index2].nivel!
                                .toDouble(),
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
                                Get.to(Reproductor(
                                    fieldid: rutina.listSeries[index]
                                        .ejercicios![index2].fileid!));
                              },
                              icon: const Icon(
                                Icons.video_library_rounded,
                                color: Colors.green,
                                size: 25,
                              )),
                          IconButton(
                              onPressed: () {
                                rutina
                                    .eliminar_ejercicio_rutina(
                                        rutina.listSeries[index].ejercicios![index2]
                                            .id_rutina,
                                        rutina
                                            .ejercicios_rutina[index].id_ejercicio)
                                    .then((value) => geteje());
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
          Container(
            width: 10,
            height: height/10,
            color:serie == "Biserie"? Colors.red:serie == "Triserie"?Colors.blue:Colors.green,)
        ],
      ),
    );
  }
}
