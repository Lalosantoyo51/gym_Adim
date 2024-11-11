import 'dart:io';

import 'package:administrador/screens/gym/models/novedad.dart';
import 'package:administrador/screens/gym/providers/provider_novedad.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:provider/provider.dart';

class NovedadesForm extends StatefulWidget {
  NovedadModel? novedadModel;
  String proviene;
  NovedadesForm({Key? key, this.novedadModel, required this.proviene})
      : super(key: key);

  @override
  State<NovedadesForm> createState() => _NovedadesFormState();
}

class _NovedadesFormState extends State<NovedadesForm> {

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  init(){
    final novedad = Provider.of<provider_novedad>(context,listen: false);
    if(widget.proviene != "add"){
      novedad.nombre.text = "${widget.novedadModel?.titulo}";
      novedad.novedad = widget.novedadModel!;
    }else{
      novedad.nombre.text = "";

    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final novedad = Provider.of<provider_novedad>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Novedad"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Input(
                        inputController: novedad.nombre,
                        texto: "Nombre de la Novedad")),
                widget.proviene == "add"?
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      novedad.inicio.year == 1995
                          ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(6, 19, 249, 1)),
                          ),
                          onPressed: () {
                            novedad.mostrarFechaInicio(
                                context);
                          },
                          child: const Text(
                              "Fecha Inicio"))
                          : Text(novedad.formatter
                          .format(DateTime.parse(
                          novedad.inicio
                              .toString()))
                          .toUpperCase()),
                      novedad.fin.year == 1995
                          ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(6, 19, 249, 1)),
                          ),
                          onPressed: () {

                            novedad.mostrarFechaFin(
                                context);
                          },
                          child: const Text(
                              "Fecha Fin"))
                          : Text(novedad.formatter
                          .format(DateTime.parse(
                          novedad.fin.toString()))
                          .toUpperCase()),
                    ],
                  ),
                ): Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Inicio"),
                          Text("Fin"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: ()=>novedad.mostrarFechaFin(context),
                            child: Text(novedad.formatter
                                .format(DateTime.parse(
                                widget.novedadModel!.fecha_inicio.toString()))
                                .toUpperCase()),
                          ),

                          Text(novedad.formatter
                              .format(DateTime.parse(
                              widget.novedadModel!.fecha_fin.toString()))
                              .toUpperCase()),
                        ],
                      ),
                    ],
                  ),
                ),
                if(widget.proviene == "add" && novedad.image  == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 25 ),
                    child: boton(context, width, height, (){
                      print('hola');
                      novedad.getImage();
                    }, "Ver Galeria"),
                  ),
                if(widget.proviene == "add")
                  SizedBox(height: 30),
                //crear nueva novedad
                if(widget.proviene == "add" && novedad.image  != null)
                  Container(
                width: width,
                height: height / 2.5,
                child: Stack(
                  children: [
                    Center(
                        child: Image.file(
                          File(novedad.image!.path),
                        )),
                    Positioned(
                        right: 20,
                        child: IconButton(
                            onPressed: novedad.getImage,
                            icon: const Icon(
                              Icons.cancel,
                              size: 40,
                              color: Colors.red,
                            )))
                  ],
                )),
                //editar---
                if (widget.proviene == "actualiar")
                  Container(
                      width: width,
                      height: height / 2.5,
                      child: Stack(
                        children: [
                          Center(
                              child: Image.network("${widget.novedadModel!.imagen}")),
                          Positioned(
                              right: 20,
                              child: IconButton(
                                  onPressed: novedad.getImage,
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 40,
                                    color: Colors.red,
                                  )))
                        ],
                      )),
                const SizedBox(
                  height: 40,
                ),
                boton(context, width, height,(){
                  {
                    if (widget.proviene == "add") {
                      novedad.registrar(context);
                    } else {
                      novedad.actualizar(context);
                    }
                  }
                },widget.proviene == "actualiar"?"Actualizar":"Agregar"),
              ],
            ),
            if (novedad.isCargando == true) LoadingAlert("Cargando...")
          ],
        ),
      ),
    );
  }

  InkWell boton( BuildContext context, double width,
      double height, Callback funtion,String txt) {
    return InkWell(
      onTap: (){
        funtion();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: BottomGradiant(
              colorFinal: const Color.fromRGBO(0, 0, 0, 1),
              colorInicial: const Color.fromRGBO(0, 0, 0, 1),
              width: width * .65,
              heigth: height * .050,
            ),
          ),
          Text(
            txt,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
