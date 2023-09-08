import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:administrador/widgets/input3.dart';
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
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${entrenamiento.nombre_ent}"),
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
                      child: ExpansionTile(
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
                          ColumnBuilder(itemBuilder: (context, index2) =>Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${entrenamiento.dias![index].series![index2].serie}",style: TextStyle(fontSize:  25,fontWeight: FontWeight.bold)),
                                ColumnBuilder(
                                    itemBuilder: (context, index3) {
                                      return Container(
                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                          child: Stack(
                                            children: [
                                              Card(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: width / 3,
                                                                padding: EdgeInsets.all(10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Nombre: ${entrenamiento.dias![index].series![index2].ejercicios![index3].nombre}"),
                                                                    Text("Musculos: ${entrenamiento.dias![index].series![index2].ejercicios![index3].musculos_trabajados}"),
                                                                    Text("Instrucciones:"),
                                                                    Text("${entrenamiento.dias![index].series![index2].ejercicios![index3].instrucciones}"),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: width / 3.5,
                                                                padding: EdgeInsets.all(10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Serie"),
                                                                    Text("${entrenamiento.dias![index].series![index2].ejercicios![index3].series}"),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: width / 3.5,
                                                                padding: EdgeInsets.all(10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Repeticion"),
                                                                    Text("${entrenamiento.dias![index].series![index2].ejercicios![index3].repeticiones}"),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),

                                                    ],
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10,left: 5),
                                                child: Container(
                                                    width: 5,
                                                    height: 80,
                                                    color:entrenamiento.dias![index].series![index2].serie == "Biserie"? Colors.red:entrenamiento.dias![index].series![index2].serie == "Triserie"?Colors.blue:Colors.green              ),
                                              )
                                            ],
                                          ));
                                    },
                                    itemCount: entrenamiento.dias![index].series![index2].ejercicios!.length),

                              ],
                            ),
                          ),
                              itemCount: entrenamiento.dias![index].series!.length)
                        ],
                      ),
                    ),
                itemCount: entrenamiento.dias!.length)
          ],
        ),
      ),
    );
  }
  Container eje(double width) {
    return Container(
      margin: EdgeInsets.all(width * .02),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * .05)),
      child: ExpansionTile(
        title: Text(
          "Circunferencias",
          style: TextStyle(fontSize: width * .05),
        ),
        children: [
          ListTile(
            title: Text(
              "Perimetro Brazo 30cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Brazo Flexionado 31cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Cintura 82cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Cader  98.5cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Pierna/Muslo 59cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Pantorrilla 35.5cm",
              style: TextStyle(fontSize: width * .04),
            ),
          ),
          ListTile(
            title: Text(
              "Pectoral 60cm",
              style: TextStyle(fontSize: width * .04),
            ),
          )
        ],
      ),
    );
  }
}
