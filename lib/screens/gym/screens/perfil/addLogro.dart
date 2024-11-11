import 'dart:io';

import 'package:administrador/screens/Autentificacion/Model/perfil.dart';
import 'package:administrador/screens/gym/api/profile_api.dart';
import 'package:administrador/screens/gym/models/profile.dart';
import 'package:administrador/screens/gym/screens/perfil/Profile.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart';

class AddLogro extends StatefulWidget {
  ProfileModel perfil;
  int idUser;
  int pos;
  AddLogro(
      {Key? key, required this.perfil, required this.idUser, required this.pos})
      : super(key: key);

  @override
  State<AddLogro> createState() => _AddLogroState();
}

class _AddLogroState extends State<AddLogro> {
  ProfileApi api = ProfileApi();
  TextEditingController descripcion = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  XFile? image2;
  bool cargando = false;

  getImage() async {
    setState(() {
      cargando = true;
    });
    print('el pois ${widget.pos}');
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await api
          .subirImagen(image, widget.perfil, widget.idUser, pos: widget.pos)
          .then((value) {
        cargando = false;
      });
    }
    cargando = false;
    setState(() {});
  }

  getImage2() async {
    setState(() {
      cargando = true;
    });
    int newPos = widget.pos + 1;
    image2 = await _picker.pickImage(source: ImageSource.gallery);
    if (image2 != null) {
      await api
          .subirImagen(image2, widget.perfil, widget.idUser, pos: newPos)
          .then((value) {
        cargando = false;
      });
    }
    setState(() {});
  }

  succes() {
    Alert(
        context: context,
        type: AlertType.success,
        title: "Correcto",
        desc: "Registro Agregado",
        buttons: [
          DialogButton(
            onPressed: () {
              Get.offAll(() => Profile());
            },
            child: Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  err() {
    Alert(
        context: context,
        type: AlertType.warning,
        title: "Advertencia",
        desc: "Todos los campos son requeridos",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Agregar Logro",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black),
      body: Stack(
        children: [
          cargando == false
              ? ListView(
                  children: [
                    SizedBox(height: 10),
                    Center(
                        child: Input(
                            inputController: descripcion,
                            texto: "Descripción")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: image == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text("Foto 1",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                  ))
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(File(image!.path)),
                                          fit: BoxFit.fill)),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            getImage2();
                          },
                          child: image2 == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text("Foto 2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                  ))
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(File(image2!.path)),
                                          fit: BoxFit.fill)),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    TextButton(
                        onPressed: () {
                          print('el pois ${widget.pos}');

                          if (widget.pos == 1) {
                            widget.perfil.logro = descripcion.text;
                          }
                          if (widget.pos == 3) {
                            widget.perfil.logro2 = descripcion.text;
                          }
                          if (widget.pos == 5) {
                            widget.perfil.logro3 = descripcion.text;
                          }
                          if (image != null &&
                              image2 != null &&
                              descripcion.text.isNotEmpty) {
                            api
                                .updateProfile(widget.perfil, widget.idUser)
                                .then((value) => succes());
                          } else {
                            err();
                          }
                        },
                        child: const Text(
                          "Agregar",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              : LoadingAlert(""),
        ],
      ),
    );
  }
}
