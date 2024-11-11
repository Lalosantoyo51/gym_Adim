import 'package:administrador/screens/gym/models/reto.dart';
import 'package:administrador/screens/gym/providers/reto_detalles_provider.dart';
import 'package:administrador/screens/gym/screens/retos/participantes.dart';
import 'package:administrador/screens/gym/screens/retos/regalos.dart';
import 'package:administrador/screens/gym/screens/retos/usuarios.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

class RetosDetalle extends StatefulWidget {
  RetoModel reto;
  int regis;
  RetosDetalle({super.key, required this.reto, required this.regis});

  @override
  State<RetosDetalle> createState() => _RetosDetalleState();
}

class _RetosDetalleState extends State<RetosDetalle> {
  @override
  void initState() {

    // TODO: implement initStat
    init();
    super.initState();
  }

  init(){
    final retosProvider = Provider.of<RetoDetallesProvider>(context,listen: false);
    if(retosProvider.isScroll != 1){
      retosProvider.cambiarEstado(1);
    }
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final retosProvider = Provider.of<RetoDetallesProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
            top: 0,
            bottom: height * retosProvider.conteinerSecond,
            child: GestureDetector(
              onTap: () {
                retosProvider.cambiarEstado(1);
              },
              child: Container(
                width: width,
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color.fromARGB(255, 255, 254, 254),
                            Color.fromARGB(255, 66, 66, 66)
                          ],
                          stops: [retosProvider.stop1, retosProvider.stop2],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      child: Image.network(
                        widget.reto.imagen!,
                        fit: BoxFit.cover,
                        width: width,
                        height: height,
                      ),
                    ),
                    Positioned(
                      bottom: height * .08,
                      left: width * .05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.reto.nombre!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width * .08,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: width * .95,
                            child: Text(
                              widget.reto.descripcion!,
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * .04),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
            top: height * retosProvider.conteinerFirst,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              /* onVerticalDragUpdate: ((details) {
                if (details.primaryDelta! < -5) {
                  retosProvider.cambiarEstado(true);
                } else if (details.primaryDelta! > 5) {
                  retosProvider.cambiarEstado(false);
                }
              }*/
              onTap: (() {
                retosProvider.cambiarEstado(2);
              }),
              child: Container(
                width: width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 6, 132, 154),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: height * .05),
                        child: retosProvider.isScroll != 2
                            ? FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * .06),
                                      child: AutoSizeText(
                                        "Participantes",
                                        style: TextStyle(
                                            fontSize: width * .07,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: width * .05),
                                        child: SizedBox(
                                            width: width * .25,
                                            child: Image.asset(
                                                "assets/Perfiles.png")))
                                  ],
                                ),
                              )
                            : Particiapantes(
                                width: width,
                                height: height,
                                users: widget.reto.users ?? [],
                                fin: widget.reto.fecha_fin!,
                                inicio: widget.reto.fecha_inicio!,
                                regist: widget.regis,
                                id_reto: widget.reto.id_reto!,
                                retosProvider: retosProvider)),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
            top: height * retosProvider.conteinerthird,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              /* onVerticalDragUpdate: ((details) {
                if (details.primaryDelta! < -5) {
                  retosProvider.cambiarEstado(true);
                } else if (details.primaryDelta! > 5) {
                  retosProvider.cambiarEstado(false);
                }
              }*/
              onTap: (() {
                if (widget.reto.ganadores == null ) {
                  retosProvider.cambiarEstado(3);
                }
              }),
              child: Container(
                width: width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: height * .05),
                        child: retosProvider.isScroll != 3
                            ? FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * .06),
                                      child: AutoSizeText(
                                        "Ganadores",
                                        style: TextStyle(fontSize: width * .07),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: width * .05),
                                        child: SizedBox(
                                            width: width * .27,
                                            child:  widget
                                                .reto.ganadores == null || widget
                                                .reto.ganadores!.isNotEmpty
                                                ? Image.asset(
                                                    "assets/Perfiles.png")
                                                : ElevatedButton(
                                                    child: Text("Seleccionar"),
                                                    onPressed: () {
                                                      Get.to(usuariosReto(retoModel: widget.reto,proviene: 2,));
                                                    })))
                                  ],
                                ),
                              )
                            : regalos(
                                ganadores: widget.reto.ganadores ?? [],
                                width: width,
                                height: height,
                              )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
