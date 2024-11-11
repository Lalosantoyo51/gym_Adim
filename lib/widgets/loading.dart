// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoadingAlert extends StatefulWidget {
  String messageAler;
  LoadingAlert(this.messageAler);
  @override
  _LoadingAlertState createState() => _LoadingAlertState();
}

class _LoadingAlertState extends State<LoadingAlert> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(image: AssetImage("assets/cargando.gif"),fit: BoxFit.fill,)
        ),
      ),
    );
  }
}