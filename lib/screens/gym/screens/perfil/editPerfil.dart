import 'dart:io';

import 'package:administrador/screens/gym/api/profile_api.dart';
import 'package:administrador/screens/gym/models/profile.dart';
import 'package:administrador/screens/gym/screens/perfil/Profile.dart';
import 'package:administrador/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  ProfileModel perfil;
  int idUser;
  int pos;

  EditProfile(
      {Key? key, required this.perfil, required this.idUser, required this.pos})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ProfileApi api = ProfileApi();
  TextEditingController descripcion = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  XFile? image2;

  getImage() async {
    print('el pois ${widget.pos}');
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await api.subirImagen(image, widget.perfil, widget.idUser,
          pos: widget.pos);
    }
    setState(() {});
  }

  getImage2() async {
    int newPos = widget.pos + 1;
    image2 = await _picker.pickImage(source: ImageSource.gallery);
    if (image2 != null) {
      await api.subirImagen(image2, widget.perfil, widget.idUser, pos: newPos);
    }
    setState(() {});
  }

  succes() {
    Alert(
        context: context,
        type: AlertType.success,
        title: "Correcto",
        desc: "Registro Actualizado",
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

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  init(){
    if(widget.pos == 1){
      descripcion.text = widget.perfil.logro!;
    }else if(widget.pos == 3){
      descripcion.text = widget.perfil.logro2!;
    }else{
      descripcion.text = widget.perfil.logro3!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Editar Logro",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Center(
              child: Input(inputController: descripcion, texto: "Descripción")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  getImage();
                },
                child: image == null
                    ? Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.pos == 1
                                    ? widget.perfil.img11!
                                    : widget.pos == 3
                                        ? widget.perfil.img21!
                                        : widget.perfil.img31!),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2.5,
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
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.pos == 1
                                    ? widget.perfil.img12!
                                    : widget.pos == 3
                                    ? widget.perfil.img22!
                                    : widget.perfil.img32!),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)))
                    : Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2.5,
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
                if (widget.pos == 1) {
                  widget.perfil.logro = descripcion.text;
                }
                if (widget.pos == 3) {
                  widget.perfil.logro2 = descripcion.text;
                }
                if (widget.pos == 5) {
                  widget.perfil.logro3 = descripcion.text;
                }
                api
                    .updateProfile(widget.perfil, widget.idUser)
                    .then((value) => succes());
              },
              child: const Text(
                "Editar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
