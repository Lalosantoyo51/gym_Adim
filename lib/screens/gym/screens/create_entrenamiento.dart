import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/rutina_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:administrador/widgets/input3.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Create_Entrenamiento extends StatefulWidget {
  const Create_Entrenamiento({Key? key}) : super(key: key);

  @override
  State<Create_Entrenamiento> createState() => _EntrenamientoState();
}

class _EntrenamientoState extends State<Create_Entrenamiento> {
  String selectedValue = "0";
  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(child: Text("Selecciona una rutina"), value: "0")
  ];

  @override
  void initState() {
    // TODO: implement initState
    getRutina();
    super.initState();
  }

  getRutina() async {
    // TODO: implement initState
    final rutina = Provider.of<provider_rutina>(context, listen: false);
    rutina.getRutina().then((List<Rutina_Model> rutinas) {
      rutinas.forEach((element) {
        print('${element.nombre}');
        setState(() {
          dropdownItems.add(DropdownMenuItem(
              child: Text("${element.nombre}"), value: "${element.id_rutina}"));
        });
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ent = Provider.of<provider_entrenamiento>(context);
    final rutina = Provider.of<provider_rutina>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrenamiento ${rutina.rutinas.length}"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              child: Column(
                children: [
                  steps(ent.step),
                  Expanded(
                    child: ListView(
                      children: [
                        ent.step == 0
                            ? Step1(ent, context, width)
                            : ent.step == 1
                                ? step2(ent)
                                :ent.step == 2? step3(ent, width, height):
                        Column(
                          children: [
                            const Text("Datos Generales",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                            const SizedBox(height: 20),
                            const Text("Descanzo entre series",style: TextStyle(fontSize: 25),),
                            Input(inputController: ent.descanso, texto: "Descanso"),

                            const SizedBox(height: 20),
                            const Text("Intensidad",style: TextStyle(fontSize: 25)),
                            Nivel(
                                initialRating: rutina.rating.toDouble(),
                                size: 50,
                                isEnabled: false,
                                onChanged: (rating) {
                                  rutina.rating =
                                      int.parse(rating.toString().substring(0, 1));
                                  ent.asignarInt(rating.toString().substring(0, 1));
                                  //rutina.onChangedRating(rating, index);
                                }),
                            const SizedBox(height: 20),
                            const Text("Ejercicio Cardio Vascular",style: TextStyle(fontSize: 25),),
                            const SizedBox(height: 10),
                            Input(inputController: ent.ejercicio_cardio_vascular, texto: "Ejercicio cardio vascular"),
                            const SizedBox(height: 20),
                            const Text("Repeticiones en reserva",style: TextStyle(fontSize: 25),),
                            Input(inputController: ent.repeticiones_en_reserva, texto: "Repeticiones en reserva"),
                            const SizedBox(height: 20),
                            const Text("Observaciones Importantes",style: TextStyle(fontSize: 25),),
                            Input(inputController: ent.observaciones, texto: "Observaciones")
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (ent.step > 0)
                          boton(height, width, context, "Regresar", () {
                            ent.back();
                          }),
                        ent.step <3?
                        boton(height, width, context, "Siguiente", () {
                          ent.next();
                        }):boton(height, width, context, "Finalizar", () {
                            ent.insertarEntrenamiento();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView step3(
      provider_entrenamiento ent, width, height) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
          Column(
                  children: [
                    ColumnBuilder(itemBuilder: (context, i) =>
                        ent.dias[i].enable == true?
                        Column(
                          children: [
                            Text(ent.dias[i].dia),
                            ColumnBuilder(
                                itemCount: ent.dias[i].series!.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${ent.dias[i].series![index].serie!}",style: TextStyle(fontSize:  25,fontWeight: FontWeight.bold)),
                                      ColumnBuilder(
                                          itemBuilder: (context, index2) {
                                            return cardCategoria(
                                                height,
                                                width,
                                                ent.dias[i].series![index].ejercicios![index2],
                                                index,
                                                index2,
                                                ent.dias[i].series![index].serie!,ent,i);
                                          },
                                          itemCount: ent.dias[i].series![index].ejercicios!.length),

                                    ],
                                  ),
                                )),
                          ],
                        ):Container()
                        , itemCount: ent.dias.length)
                   // boton(height, width, context, "Confirmar", () { })
                  ],
                )/*
                : Container(
                    child: const Center(
                        child: Text(
                      "No hay Ejercicios",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )),
                  )*/
          ],
        ));
  }

  Padding boton(double height, double width, BuildContext context, text,
      VoidCallback funcion) {
    return Padding(
      padding: EdgeInsets.only(top: height * .01),
      child: GestureDetector(
        onTap: () {
          funcion();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            BottomGradiant(
              colorFinal: Colors.black,
              colorInicial: Colors.black,
              width: width / 2.5,
              heigth: height * .07,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView step2(provider_entrenamiento ent) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              for (int i = 0; i < ent.dias.length; i++)
                if (ent.dias[i].enable == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: Text(
                        ent.dias[i].dia.substring(0, 3),
                        style: TextStyle(fontSize: 20),
                      )),
                      DropdownButton(
                        value: i == 0
                            ? ent.selectLunes
                            : i == 1
                                ? ent.selectMartes
                                : i == 2
                                    ? ent.selectMiercoles
                                    : i == 3
                                        ? ent.selectJueves
                                        : i == 4
                                            ? ent.selectViernes
                                            : i == 5
                                                ? ent.selectSabado
                                                : ent.selectDomingo,
                        items: dropdownItems,
                        onChanged: (Object? value) {
                          ent.onchange(i, value);
                          switch(i){
                            case 0:
                              ent.getEjerciciosRutina(int.parse(ent.selectLunes),i);
                              break;
                            case 1:
                              ent.getEjerciciosRutina(int.parse(ent.selectMartes),i);
                              break;
                            case 2:
                              ent.getEjerciciosRutina(int.parse(ent.selectMiercoles),i);
                              break;
                            case 3:
                              ent.getEjerciciosRutina(int.parse(ent.selectJueves),i);
                              break;
                            case 4:
                              ent.getEjerciciosRutina(int.parse(ent.selectViernes),i);
                              break;
                            case 5:
                              ent.getEjerciciosRutina(int.parse(ent.selectSabado),i);
                              break;
                            case 6:
                              ent.getEjerciciosRutina(int.parse(ent.selectDomingo),i);
                              break;
                          }
                        },
                      )
                    ],
                  ),
            ]));
  }

  Column Step1(provider_entrenamiento ent, BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Nombre del plan de entrenamiento",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        Input(
            inputController: ent.nombre_entrenamiento,
            texto: "Nombre del entrenamiento"),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Duracion",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ent.inicio.year == 1995
                ? ElevatedButton(
                    onPressed: () => ent.mostrarFechaInicio(context),
                    child: const Text("Fecha Inicio"))
                : Text(ent.formatter
                    .format(DateTime.parse(ent.inicio.toString()))
                    .toUpperCase()),
            ent.fin.year == 1995
                ? ElevatedButton(
                    onPressed: () => ent.mostrarFechaFin(context),
                    child: const Text("Fecha Fin"))
                : Text(ent.formatter
                    .format(DateTime.parse(ent.fin.toString()))
                    .toUpperCase()),
          ],
        ),
        const Divider(),
        const Text(
          "Dias",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ent.dias.length,
          itemBuilder: (context, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: width / 2.5,
                  child: Text(
                    ent.dias[index].dia,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              Checkbox(
                  value: ent.dias[index].enable,
                  onChanged: (value) {
                    setState(() {
                      ent.dias[index].enable = value!;
                    });
                  })
            ],
          ),
        )
      ],
    );
  }

  Padding steps(int step) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              "1",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: 20,
            height: 5,
            color: step >= 1 ? Colors.black : Colors.grey.shade300,
          ),
          CircleAvatar(
            backgroundColor: step >= 1 ? Colors.black : Colors.grey.shade300,
            child: Text(
              "2",
              style: TextStyle(color: step >= 1 ? Colors.white : Colors.black),
            ),
          ),
          Container(
            width: 20,
            height: 5,
            color: step >= 2 ? Colors.black : Colors.grey.shade300,
          ),
          CircleAvatar(
            backgroundColor: step >= 2 ? Colors.black : Colors.grey.shade300,
            child: Text(
              "3",
              style: TextStyle(color: step >= 2 ? Colors.white : Colors.black),
            ),
          ),
          Container(
            width: 20,
            height: 5,
            color: step >= 3 ? Colors.black : Colors.grey.shade300,
          ),
          CircleAvatar(
            backgroundColor: step >= 3 ? Colors.black : Colors.grey.shade300,
            child: Text(
              "4",
              style: TextStyle(color: step >= 3 ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Container cardCategoria(double height, double width, Ejercicio_Model eje,
       index,index2,serie,provider_entrenamiento ent,dia) {
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
                          Text("Nombre: ${eje.nombre}"),
                          Text("Musculos: ${eje.musculos_trabajados}"),
                          Text("Instrucciones:"),
                          Text("${eje.instrucciones}"),
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
                          Input3(
                            texto: "",
                            proviene: 1,
                            dia: dia,
                            index: index,
                            index2: index2,
                            onChanged: (value) {
                              ent.onchangeS(value, index,index2,dia);
                            },
                          )
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
                          Input3(
                            texto: "",
                            proviene: 2,
                            dia: dia,
                            index: index,
                            index2: index2,
                            onChanged: (value) {
                              ent.onchangeR(value, index: index,index2: index2,dia);
                            },
                          )
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
                  color:serie == "Biserie"? Colors.red:serie == "Triserie"?Colors.blue:Colors.green              ),
            )
          ],
        ));
  }
}
