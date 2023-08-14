import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Serie_Ejercicios extends StatefulWidget {
  int id_rutina;
  Serie_Ejercicios({Key? key, required this.id_rutina}) : super(key: key);

  @override
  State<Serie_Ejercicios> createState() => _Serie_EjerciciosState();
}

class _Serie_EjerciciosState extends State<Serie_Ejercicios> {
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
          body: Stack(
            children: [
              rutina.ejercicios.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          rutina.selectedValue,
                          style: TextStyle(fontSize: 25),
                        ),
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: rutina.ejercicios.length,
                                itemBuilder: (context, index) => cardCategoria(
                                    height,
                                    width,
                                    rutina.ejercicios[index],
                                    rutina,
                                    index)))
                      ],
                    )
                  : Container(
                      child: const Center(
                          child: Text(
                        "No hay Ejercicios",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                    ),
              Positioned(
                bottom: 10,
                left: 50,
                right: 50,
                child: InkWell(
                  onTap: () {
                    rutina.insertRutina(widget.id_rutina,context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: BottomGradiant(
                          colorFinal: Colors.black,
                          colorInicial: Colors.black,
                          width: width * .8,
                          heigth: height * .065,
                        ),
                      ),
                      Text(
                        "Registrar",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Container cardCategoria(double height, double width, Ejercicio_Model eje,
      provider_rutina cat_eje_provider, index) {
    final rutina = Provider.of<provider_rutina>(context);
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Card(
            child: Column(
          children: [
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width / 1.1,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nombre: ${eje.nombre}"),
                      Text("Musculos: ${eje.musculos_trabajados}"),
                      Text("Instrucciones:"),
                      Text("${eje.instrucciones}"),
                    ],
                  ),
                ),
              ],
            )),
          ],
        )));
  }
}
