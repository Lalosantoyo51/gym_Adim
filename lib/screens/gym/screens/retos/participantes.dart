import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/providers/reto_detalles_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:provider/provider.dart';


class Particiapantes extends StatelessWidget {
  final double width;
  final double height;
  final RetoDetallesProvider retosProvider;
  final List<UserModel> users;
  final String inicio;
  final String fin;
  final int regist;
  final int id_reto;

  const Particiapantes({
    super.key,
    required this.width,
    required this.height,
    required this.retosProvider,
    required this.users,
    required this.inicio,
    required this.fin,
    required this.regist,
    required this.id_reto
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: AutoSizeText(
            "Participantes",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: width * .07,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Container(
          width: width * .95,
          height: height * .1,
          margin: EdgeInsets.only(top: height * .02),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(width * .017),
                child:users[index].imagen != null?CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: width * .08,
                    backgroundImage: NetworkImage("${users[index].imagen}")
                ):CircleAvatar(
                backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                radius: width * .08,
                child: Text(
                  "${users[index].nombre.toString().toUpperCase()[0]}"
                      " ${users[index].nombre.toString().toUpperCase()[1]}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                ),
              ),
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width * .87,
              height: height * .05,
            ),
            AutoSizeText(
              "Inicio: ${inicio.replaceAll("00:00:00", "")}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: width * .07, color: Colors.white),
            ),
            AutoSizeText(
              "Fin de Reto: ${fin.replaceAll("00:00:00", "")}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: width * .07, color: Colors.white),
            ),
          ],
        ),

      ],
    );
  }
}
