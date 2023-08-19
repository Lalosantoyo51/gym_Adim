import 'dart:io';

import 'package:administrador/screens/gym/models/reto.dart';
import 'package:administrador/screens/gym/providers/provider_reto.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RetoEditar extends StatefulWidget {
  RetoModel retoModel;
  RetoEditar({Key? key, required this.retoModel}) : super(key: key);

  @override
  State<RetoEditar> createState() => _RetoEditarState();
}

class _RetoEditarState extends State<RetoEditar> {

  @override
  void initState() {
    insertarDatos();
    // TODO: implement initState
    super.initState();
  }
  insertarDatos(){
    final ret = Provider.of<provider_reto>(context, listen: false);
    ret.nivel = widget.retoModel.nivel!.toDouble();
    ret.nombre.text = widget.retoModel.nombre!;
    ret.objetivo.text = widget.retoModel.objetivos!;
    ret.descripcion.text = widget.retoModel.descripcion!;
    ret.fin = DateTime.parse(widget.retoModel.fecha_fin.toString());
    ret.inicio = DateTime.parse(widget.retoModel.fecha_inicio.toString());
    ret.premio.text = widget.retoModel.premio!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final reto = Provider.of<provider_reto>(context);
    return  Container(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
            reto.limpiarDatos();
          }, icon: const Icon(Icons.arrow_back)),
            title: const Text("Reto"),
            backgroundColor: Colors.black,
            centerTitle: true),
        body: Stack(
          children: [
            ListView(
              children:  [
                const SizedBox(
                  height: 10,
                ),
                const Center(child: Text("Editar reto",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),)),
                const SizedBox(height: 20,),
                Center(child: Input(inputController: reto.nombre, texto: "Nombre")),
                const SizedBox(height: 20,),
                Center(child: Input(inputController: reto.objetivo, texto: "Objetivos")),
                const SizedBox(height: 20,),
                Center(child: Input(inputController: reto.descripcion, texto: "Descripción")),
                const SizedBox(
                  height: 10,
                ),
                const Center(child: Text("Nivel",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),)),

                Center(
                  child: Nivel(
                    onChanged: (value) {
                      reto.nivel = value;
                    },
                    isEnabled: false,
                    initialRating: reto.nivel,
                    size: width * .15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    reto.inicio.year == 1995
                        ? ElevatedButton(
                        onPressed: () => reto.mostrarFechaInicio(context),
                        child: const Text("Fecha Inicio"))
                        : Text(reto.formatter
                        .format(DateTime.parse(reto.inicio.toString()))
                        .toUpperCase()),
                    reto.fin.year == 1995
                        ? ElevatedButton(
                        onPressed: () => reto.mostrarFechaFin(context),
                        child: const Text("Fecha Fin"))
                        : Text(reto.formatter
                        .format(DateTime.parse(reto.fin.toString()))
                        .toUpperCase()),
                  ],
                ),
                const SizedBox(height: 20,),
                Center(child: Input(inputController: reto.premio, texto: "Premio")),
                reto.image != null?
                Container(
                    height: height/2,
                    child: InkWell(
                        onTap: ()=> reto.getImage(),
                        child: Image.file(File(reto.image!.path),))):  Container(
                    height: height/2,
                    child: InkWell(
                        onTap: ()=> reto.getImage(),
                        child: Image.network(widget.retoModel.imagen!))),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    reto.actualizar(context,widget.retoModel);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: BottomGradiant(
                          colorFinal: const Color.fromRGBO(238, 70, 61, 1),
                          colorInicial: const Color.fromRGBO(255, 138, 95, 1),
                          width: width * .65,
                          heigth: height * .050,
                        ),
                      ),
                      Text(

                        "Actualizar",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
            if(reto.isCargando == true)
              LoadingAlert("cargando..")
          ],
        ),
      ),
    );
  }
}
