import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:math'as math;
class regalos extends StatelessWidget {
  final double width;
  final double height;
  final List<UserModel>ganadores;

  const regalos({Key? key, required this.width, required this.height,required this.ganadores})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * .4,
      child: Column(
        children: [
          SizedBox(
            width: width,
            child: AutoSizeText(
              "Ganadores",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: width * .07, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: width * .95,
            height: height * .1,
            margin: EdgeInsets.only(top: height * .02),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ganadores.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(width * .017),
                  child:ganadores[index].imagen != null?CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: width * .08,
                      backgroundImage: NetworkImage("${ganadores[index].imagen}")
                  ):CircleAvatar(
                    backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    radius: width * .08,
                    child: Text(
                      "${ganadores[index].nombre.toString().toUpperCase()[0]}"
                          " ${ganadores[index].nombre.toString().toUpperCase()[1]}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
