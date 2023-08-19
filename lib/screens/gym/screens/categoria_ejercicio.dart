import 'dart:io';

import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/ejercicio.dart';
import 'package:administrador/screens/gym/screens/serie_ejercicios.dart';
import 'package:flutter/material.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';


class Categoria_ejercicio extends StatefulWidget {
  String proviene;
  int? id_rutina;
  Categoria_ejercicio({Key? key, required this.proviene,this.id_rutina}) : super(key: key);

  @override
  State<Categoria_ejercicio> createState() => _Categoria_ejercicioState();
}

class _Categoria_ejercicioState extends State<Categoria_ejercicio> {

  @override
  void initState() {
    getcat();
    super.initState();
  }
  getcat(){
    // TODO: implement initState
    final postModel = Provider.of<provider_cat_eje>(context, listen: false);
    postModel.getCategorias();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final cat_eje_provider = Provider.of<provider_cat_eje>(context);
    final rutina = Provider.of<provider_rutina>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Categoria Ejercicio",
        ),
        centerTitle: true,
      ),
      floatingActionButton:widget.proviene == "home"? FloatingActionButton(
          onPressed: () {
            if (cat_eje_provider.isAgregar == true) {
              cat_eje_provider.image = null;
              cat_eje_provider.isAgregar = false;
            } else {
              cat_eje_provider.nombre.clear();
              cat_eje_provider.isAgregar = true;
              cat_eje_provider.iseditar =false;

            }
            setState(() {});
          },
          backgroundColor: Colors.black,
          child: cat_eje_provider.isAgregar == false ? Icon(Icons.add) : Icon(Icons.cancel)):SizedBox(),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            cat_eje_provider.categorias.isNotEmpty && cat_eje_provider.isAgregar == false  && cat_eje_provider.iseditar == false
                ? ListView.builder(
              itemCount: cat_eje_provider.categorias.length,
              itemBuilder: (context, index) =>
                  cardCategoria(height, width, cat_eje_provider.categorias[index],cat_eje_provider),
            )
                : cat_eje_provider.categorias.isEmpty && cat_eje_provider.isAgregar == false && cat_eje_provider.iseditar == false
                ? Container(
              child: const Center(
                  child: Text(
                    "No hay registros",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
            )
                : form(height, width, context,cat_eje_provider),
            if(widget.proviene == "rutina")
              Positioned(
                bottom: 10,
                left: 50,
                right: 50,
                child: InkWell(
                  onTap: (){
                    Get.to(Serie_Ejercicios(id_rutina: widget.id_rutina!,));
                  },
                  child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: BottomGradiant(
                        colorFinal:  Colors.black,
                        colorInicial: Colors.black,
                        width: width * .8,
                        heigth: height * .065,
                      ),
                    ),
                    Text(
                      "Ejercicios ${rutina.ejercicios.length}",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                  ],
              ),
                ),)
          ],
        )
      ),
    );
  }

  SizedBox form(double height, double width, BuildContext context,cat_eje_provider) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView(
        children: [
          Center(child: Input(inputController: cat_eje_provider.nombre, texto: "Nombre de la categoria")),
          cat_eje_provider.image != null && cat_eje_provider.isAgregar== true && cat_eje_provider.iseditar == false
              ? Container(
            width: width,
                  height: height / 1.5,
              child: Stack(
                    children: [
                      Center(child: Image.file(File(cat_eje_provider.image!.path),)),
                      Positioned(
                          right: 20,
                          child: IconButton(onPressed: cat_eje_provider.getImage, icon: Icon(Icons.cancel,size: 40,color: Colors.red,)))
                    ],
                  ))
              : cat_eje_provider.iseditar == true ?Container(
            child: Container(
                width: width,
                height: height / 1.5,
                child: Stack(
                  children: [
                    cat_eje_provider.image == null && cat_eje_provider.isAgregar== false?
                    Center(child: Image.network(cat_eje_provider.uri_image)):
              Center(child: Image.file(File(cat_eje_provider.image!.path),)),
                    Positioned(
                        right: 20,
                        child: IconButton(onPressed: cat_eje_provider.getImage, icon: Icon(Icons.cancel,size: 40,color: Colors.red,)))
                  ],
                )),
          ): Container(),

          SizedBox(
            height: 20,
          ),

          if(cat_eje_provider.iseditar == true)
            InkWell(
              onTap: () {
                setState(() {
                  cat_eje_provider.iseditar = false;
                  cat_eje_provider.image = null;
                });
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
                    "Cancelar",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20,),
          InkWell(
            onTap: () {
              if (cat_eje_provider.image != null &&  cat_eje_provider.isAgregar == true ) {
                cat_eje_provider.registrarCatEje();
              } else  if(cat_eje_provider.image == null && cat_eje_provider.isAgregar == true){
                cat_eje_provider.getImage();
              }else{
                cat_eje_provider.actualizar(cat_eje_provider.cate!);
              }
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
                  cat_eje_provider.image != null && cat_eje_provider.iseditar ==false && cat_eje_provider.isAgregar == true ? "Registar" : cat_eje_provider.iseditar ==false?"Ver Galeria":"Actualizar",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Container cardCategoria(double height, double width, Categoria_eje cat,cat_eje_provider) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Card(
            child: Container(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: height * .13,
                  width: width * .17,
                  child: Image.network(cat.imagen),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.nombre),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Acciones"),
                Row(
                  children: [
                    if(widget.proviene == "home")
                    IconButton(
                        onPressed: (){
                          cat_eje_provider.iseditar = true;
                          cat_eje_provider.nombre.text = cat.nombre;
                          cat_eje_provider.uri_image = cat.imagen;
                          cat_eje_provider.cate = cat;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.orange,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<provider_cat_eje>(create: (_) => provider_cat_eje()),
                                    ChangeNotifierProvider<provider_ejercicios>(create: (_) => provider_ejercicios()),
                                  ],
                                  builder: (context, child) => Ejercicio(categoria_eje: cat,proviene: widget.proviene,id_rutina: widget.id_rutina),
                                ),)
                          );
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.orange,
                          size: 25,
                        )),
                    if(widget.proviene == "home")
                      IconButton(
                        onPressed: () => cat_eje_provider.advertencia(context,cat.id_cat_eje,cat.fileid),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 25,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ))));
  }
}
