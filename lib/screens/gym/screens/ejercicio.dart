import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Ejercicio extends StatefulWidget {
  Categoria_eje categoria_eje;
  String proviene;
  int? id_rutina;
  Ejercicio({Key? key, required this.categoria_eje, required this.proviene,this.id_rutina})
      : super(key: key);

  @override
  State<Ejercicio> createState() => _EjercicioState();
}

class _EjercicioState extends State<Ejercicio> {
  @override
  void initState() {
    // TODO: implement initState
    geteje();
    super.initState();
  }

  geteje() {
    // TODO: implement initState
    final ejercicio = Provider.of<provider_ejercicios>(context, listen: false);
    ejercicio.getEjercicios(widget.categoria_eje.id_cat_eje);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final eje_provider = Provider.of<provider_ejercicios>(context);

    return Container(
      height: height,
      width: width,
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    if (eje_provider.controller != null) {
                      if (eje_provider.controller!.value.isPlaying == true) {
                        eje_provider.controller!.dispose();
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.arrow_back)),
              backgroundColor: Colors.black,
              title: Text("Ejercicios"),
              centerTitle: true),
          floatingActionButton: widget.proviene == "home"
              ? FloatingActionButton(
                  onPressed: () {
                    if (eje_provider.isAgregar == true) {
                      //eje_provider.image = null;
                      eje_provider.isAgregar = false;
                    } else {
                      eje_provider.nombre.clear();
                      eje_provider.isAgregar = true;
                      eje_provider.iseditar = false;
                    }
                    setState(() {});
                  },
                  backgroundColor: Colors.black,
                  child: eje_provider.isAgregar == false
                      ? Icon(Icons.add)
                      : Icon(Icons.cancel))
              : SizedBox(),
          body: Stack(
            children: [
              eje_provider.ejercicios.isNotEmpty &&
                      eje_provider.isAgregar == false &&
                      eje_provider.iseditar == false
                  ? ListView.builder(
                      itemCount: eje_provider.ejercicios.length,
                      itemBuilder: (context, index) => cardCategoria(height,
                          width, eje_provider.ejercicios[index], eje_provider))
                  : eje_provider.ejercicios.isEmpty &&
                          eje_provider.isAgregar == false &&
                          eje_provider.iseditar == false
                      ? Container(
                          child: const Center(
                              child: Text(
                            "No hay Ejercicios",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )),
                        )
                      : form(height, width, context, eje_provider),
              if (eje_provider.loading == true) LoadingAlert("Cargando...")
            ],
          )),
    );
  }

  SizedBox form(double height, double width, BuildContext context,
      provider_ejercicios cat_eje_provider) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
              child: Input(
                  inputController: cat_eje_provider.nombre,
                  texto: "Nombre del ejercicio")),
          Center(
              child: Input(
                  inputController: cat_eje_provider.musculos_trabajados,
                  texto: "Musculos trabajados")),
          Center(
              child: Input(
                  inputController: cat_eje_provider.instrucciones,
                  texto: "Instrucciones")),
          Center(
              child: Input(
                  inputController: cat_eje_provider.calorias,
                  texto: "Calorias")),
          if (cat_eje_provider.video != null &&
                  cat_eje_provider.isAgregar == true ||
              cat_eje_provider.iseditar == true &&
                  cat_eje_provider.controller != null)
            cat_eje_provider.controller!.value.isInitialized
                ? Container(
                    height: height / 2.5,
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Card(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: cat_eje_provider
                                  .controller!.value.aspectRatio,
                              child: VideoPlayer(cat_eje_provider.controller!),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 20,
                            child: IconButton(
                                onPressed: () =>
                                    cat_eje_provider.getImagetvideo(),
                                icon: Icon(
                                  Icons.cancel,
                                  size: 40,
                                  color: Colors.red,
                                )))
                      ],
                    ),
                  )
                : Container(),
          if (cat_eje_provider.iseditar == true)
            InkWell(
              onTap: () {
                setState(() {
                  cat_eje_provider.iseditar = false;
                  cat_eje_provider.controller!.dispose();
                  //cat_eje_provider.image = null;
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
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              //cat_eje_provider.getImagetvideo();
              if (cat_eje_provider.video != null &&
                  cat_eje_provider.isAgregar == true) {
                cat_eje_provider
                    .registrarEjercicio(widget.categoria_eje.id_cat_eje);
              } else if (cat_eje_provider.video == null &&
                  cat_eje_provider.isAgregar == true) {
                cat_eje_provider.getImagetvideo();
              } else {
                cat_eje_provider.actualizar(widget.categoria_eje.id_cat_eje);
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
                  cat_eje_provider.video != null &&
                          cat_eje_provider.iseditar == false &&
                          cat_eje_provider.isAgregar == true
                      ? "Registar"
                      : cat_eje_provider.iseditar == false
                          ? "Ver Galeria"
                          : "Actualizar",
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

  Container cardCategoria(double height, double width, Ejercicio_Model eje,
      provider_ejercicios cat_eje_provider) {
    final rutina = Provider.of<provider_rutina>(context);
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Card(
            child: Container(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width / 2,
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
            widget.proviene == "home"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Acciones"),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                cat_eje_provider.iseditar = true;
                                cat_eje_provider.nombre.text = "${eje.nombre}";
                                cat_eje_provider.calorias.text =
                                    "${eje.calorias}";
                                cat_eje_provider.instrucciones.text =
                                    "${eje.instrucciones}";
                                cat_eje_provider.musculos_trabajados.text =
                                    "${eje.musculos_trabajados}";
                                cat_eje_provider.ejercicio.fileid = eje.fileid;
                                cat_eje_provider.ejercicio.id_ejercicio =
                                    eje.id_ejercicio;
                                cat_eje_provider.getUriVideo(eje.fileid);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                                size: 25,
                              )),
                          Switch(
                              activeColor: Colors.black,
                              value: eje.isActivo,
                              onChanged: (value) {
                                eje.isActivo = value;
                                setState(() {
                                  if (value == true) {
                                    cat_eje_provider.isdisponible(
                                        0, eje.id_ejercicio);
                                  } else {
                                    cat_eje_provider.isdisponible(
                                        1, eje.id_ejercicio);
                                  }
                                });
                              }),
                          IconButton(
                              onPressed: () {
                                cat_eje_provider.advertencia(
                                    context,
                                    eje.id_ejercicio,
                                    eje.id_cat_eje,
                                    eje.fileid);
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Agregar a la rutina"),
                        IconButton(
                            onPressed: () {
                              rutina.obtener_usuarios_rutina(widget.id_rutina).then((List<UserModel> users) {
                                setState(() {
                                  rutina.agregarEjercicio(context,widget.id_rutina!, eje.id_ejercicio!);
                                  for(var user in users){
                                    rutina.agregarEjercicio(context,widget.id_rutina!, eje.id_ejercicio!);
                                    rutina.api_rutina.asignatRutina(Rutina_Ejercicio_Model(
                                        id_rutina: widget.id_rutina!,
                                        id_ejercicio: eje.id_ejercicio,
                                        asignado_a: user.idU,
                                        nivel: rutina.rating,
                                        repeticiones: int.parse(rutina.repeticiones.text),
                                        series: int.parse(rutina.series.text))).then((value){
                                    });
                                  }
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 35,
                              color: Colors.green,
                            ))
                      ],
                    ),
                  ),
          ],
        ))));
  }
}
