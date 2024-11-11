import 'dart:io';
import 'package:administrador/screens/gym/providers/provider_reto.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RetosCrear extends StatefulWidget {
  const RetosCrear({Key? key}) : super(key: key);

  @override
  State<RetosCrear> createState() => _RetosCrearState();
}

class _RetosCrearState extends State<RetosCrear> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final reto = Provider.of<provider_reto>(context);

    return  Container(
      child: Scaffold(
          appBar: AppBar(
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
                const Center(child: Text("Crear reto",style: TextStyle(
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
                        ? ElevatedButton(style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                        onPressed: () => reto.mostrarFechaInicio(context),
                        child: const Text("Fecha Inicio"))
                        : Text(reto.formatter
                        .format(DateTime.parse(reto.inicio.toString()))
                        .toUpperCase()),
                    reto.fin.year == 1995
                        ? ElevatedButton(style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
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
                        child: Image.file(File(reto.image!.path),))):Container(),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    print('aaas');
                    if(reto.image.isNull){
                      reto.getImage();
                    }else{
                      reto.insertarReto(context,"registrar");
                    }
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
                        reto.image.isNull?
                        "Ver Galeria":"Registrar",
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
              LoadingAlert("Cargando...")
          ],
        ),
      ),
    );
  }
}
