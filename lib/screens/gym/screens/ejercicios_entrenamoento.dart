import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Ejercicios_Entrenamoento extends StatelessWidget {
  Entrenamoento_Model entrenamiento;
  Ejercicios_Entrenamoento({Key? key, required this.entrenamiento})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ent = Provider.of<provider_entrenamiento>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${entrenamiento.nombre_ent}"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: [
            ColumnBuilder(
                itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(width * .02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * .05)),
                      child:
                      entrenamiento.dias![index].series!.isNotEmpty?
                      ExpansionTile(
                        title: Text(
                          entrenamiento.dias![index].num_dia == 0
                              ? "LUNES"
                              : entrenamiento.dias![index].num_dia == 1
                                  ? "MARTES"
                                  : entrenamiento.dias![index].num_dia == 2
                                      ? "MIERCOLES"
                                      : entrenamiento.dias![index].num_dia == 3
                                          ? "JUEVES"
                                          : entrenamiento
                                                      .dias![index].num_dia ==
                                                  4
                                              ? "VIERNES"
                                              : entrenamiento.dias![index]
                                                          .num_dia ==
                                                      5
                                                  ? "SABADO"
                                                  : "DOMINGO",
                          style: TextStyle(fontSize: width * .05),
                        ),
                        children: [
                          ColumnBuilder(
                              itemBuilder: (context, index2) => Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              "${entrenamiento.dias![index].series![index2].serie}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),

                                      const Text(
                                          "Serie"),
                                      const Text(
                                          "Repeticion"),
                                      //Text(
                                      //    "nombre de la rutina",
                                      //    style: const TextStyle(
                                      //        fontSize: 25,
                                      //        fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Card(
                                    child: ColumnBuilder(
                                        itemBuilder: (context, index3) {
                                          return Container(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 5),
                                              child: Stack(
                                                children: [
                                                  Card(
                                                      child: Column(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            width:
                                                                width / 3.5,
                                                            padding:
                                                               const EdgeInsets
                                                                    .all(
                                                                        10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    " ${entrenamiento.dias![index].series![index2].ejercicios![index3].nombre}",style: TextStyle(fontWeight: FontWeight.bold),),
                                                               ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                width / 3.5,

                                                            padding:
                                                               const EdgeInsets
                                                                    .all(
                                                                        10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "${entrenamiento.dias![index].series![index2].ejercicios![index3].series}"),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                width / 3.5,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                        10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "${entrenamiento.dias![index].series![index2].ejercicios![index3].repeticiones}"),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ],
                                                  )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            top: 10,
                                                            left: 5),
                                                    child: Container(
                                                        width: 5,
                                                        height: 40,
                                                        color: entrenamiento
                                                                    .dias![
                                                                        index]
                                                                    .series![
                                                                        index2]
                                                                    .serie ==
                                                                "Biserie"
                                                            ? Colors.red
                                                            : entrenamiento
                                                                        .dias![
                                                                            index]
                                                                        .series![
                                                                            index2]
                                                                        .serie ==
                                                                    "Triserie"
                                                                ? Colors
                                                                    .blue
                                                                : entrenamiento.dias![index].series![index2].serie ==
                                                                        "Serie recta"
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .black87),

                                                    // serie == "Biserie"
                                                    //   ? Colors.red
                                                    //  : serie == "Triserie"
                                                    //  ? Colors.blue
                                                    //  : serie == "Circuito"
                                                    //  ? Colors.yellow
                                                    //  : serie == "Serie recta"
                                                    //  ? Colors.green
                                                    //  : Colors.black87,
                                                  )
                                                ],
                                              ));
                                        },
                                        itemCount: entrenamiento
                                            .dias![index]
                                            .series![index2]
                                            .ejercicios!
                                            .length),
                                  ),
                                ],
                              ),
                              itemCount:
                                  entrenamiento.dias![index].series!.length)
                        ],
                      ):Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.all(10.0),
                        width: width,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            entrenamiento.dias![index].num_dia == 0
                                ? "LUNES"
                                : entrenamiento.dias![index].num_dia == 1
                                ? "MARTES"
                                : entrenamiento.dias![index].num_dia == 2
                                ? "MIERCOLES"
                                : entrenamiento.dias![index].num_dia == 3
                                ? "JUEVES"
                                : entrenamiento
                                .dias![index].num_dia ==
                                4
                                ? "VIERNES"
                                : entrenamiento.dias![index]
                                .num_dia ==
                                5
                                ? "SABADO"
                                : "DOMINGO",
                            style: TextStyle(fontSize: width * .05),
                          ),
                        ),
                      ),
                    ),
                itemCount: entrenamiento.dias!.length)
          ],
        ),
      ),
    );
  }

}
