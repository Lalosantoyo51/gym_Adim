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
    print('aaaa');
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
                    itemBuilder: (context, index) => Card(
                      child: Center(
                        child: Column(
                              children: [
                                Text(rutina.listSeries[index].serie!),
                                ColumnBuilder(
                                  itemCount:
                                      rutina.listSeries[index].ejercicios!.length,
                                  itemBuilder: (context, index2) => GestureDetector(
                                    onTap: (){
                                      Get.to(Reproductor(
                                          fieldid: rutina.listSeries[index]
                                              .ejercicios![index2].fileid!));
                                    },
                                    child: Card(
                                        child: buildPadding(
                                            width,
                                            index,
                                            index2,
                                            context,
                                            height,
                                            rutina,
                                            rutina.listSeries[index].serie!)),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ))
                : const Center(
                    child: Text("No hay registros",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  )));
  }

  Padding buildPadding(double width, int index, int index2,
      BuildContext context, double height, provider_rutina rutina, serie) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          rutina.listSeries[index].ejercicios![index2].nombre!,
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Container(
            width: 10,
            height: height / 10,
            color: serie == "Biserie"
                ? Colors.red
                : serie == "Triserie"
                    ? Colors.blue
                    : serie == "Circuito"
                        ? Colors.yellow
                        : serie == "Serie recta"
                            ? Colors.green
                            : Colors.black87,
          )
        ],
      ),
    );
  }
}
