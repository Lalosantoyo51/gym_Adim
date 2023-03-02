import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/rutina_model.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class provider_rutina with ChangeNotifier {
  List<Rutina_Model> rutinas = [];
  List<Rutina_Ejercicio_Model> ejercicios_rutina = [];
  Rutina_Apis api_rutina = Rutina_Apis();
  bool loading = false;
  UserModel? user;
  TextEditingController nombre = TextEditingController();
  TextEditingController series = TextEditingController();
  TextEditingController repeticiones = TextEditingController();
  TextEditingController nivel = TextEditingController();
  int rating = 0;
  String la = "";

  getRutina() async {
    await getUser();
    loading = true;
    api_rutina.get_rutinas(user!.idU).then((List<Rutina_Model> rutinas) {
      this.rutinas = rutinas;
      notifyListeners();
      loading = false;
    });
  }

   Future getEjerciciosRutina(int id_rutina) async {
    print('id $id_rutina');
    loading = true;
    api_rutina
        .get_ejercicio_rutina(id_rutina)
        .then((List<Rutina_Ejercicio_Model> rutinas) {
          this.ejercicios_rutina = rutinas;
      notifyListeners();
      loading = false;
    });
  }

  Future getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var usu = sp.getString("usuario");
    print('usu ${usu}');
    if (usu != null) {
      user = UserModel.fromJson2(json.decode(usu));
    }
    notifyListeners();
  }

  Future eliminar_rutina(id_rutina)async{
    api_rutina.eliminar_rutina(id_rutina).then((value) => getRutina());
  }


  succes(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Correto",
      desc: "Se a agregado correctamente el ejercicio",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pop();
          },
          width: 120,
        ),
      ],
    ).show();
  }
  succes2(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Correto",
      desc: "Se a agregado correctamente",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }


  agregarEjercicio(context, int id_rutina, int id_ejercicio) async{
    await getUser();
    await Alert(
        context: context,
        title: "Añadir ejercicio a la rutina",
        content: Column(
          children: <Widget>[
            TextField(
              controller: series,
              decoration: InputDecoration(
                labelText: 'Series',
              ),
            ),
            TextField(
              controller: repeticiones,
              decoration: InputDecoration(
                labelText: 'Repeticiones',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Nivel"),
            SizedBox(
              height: 5,
            ),
            Nivel(
              initialRating: 0,
              size: MediaQuery.of(context).size.width * .1,
              isEnabled: false,
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            color: Colors.green,
            onPressed: () {
              api_rutina.asignatRutina(Rutina_Ejercicio_Model(
                  id_rutina: id_rutina,
                  id_ejercicio: id_ejercicio,
                  asignado_a: user!.idU,
                  nivel: rating,
                  repeticiones: int.parse(repeticiones.text),
                  series: int.parse(series.text))).then((value){
                    Navigator.pop(context);
                    succes(context);
              });
            },
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  advertencia(context,id_rutina) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "Estas seguro de eliminar el registro?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            eliminar_rutina(id_rutina);
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }
  advertencia2(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "Este usuario ya esta asignado a esta rutina",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        ),

      ],
    ).show();
  }
  agregarRutina(context) {
    getUser();
    Alert(
      context: context,
      type: AlertType.info,
      title: "Agrega la nueva rutina",
      content: Column(
        children: [
          Input(inputController: nombre, texto: "Nombre")
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            api_rutina.insetRutina(Rutina_Model(nombre: nombre.text,id_usuario: user!.idU,tipo_user: user!.tipo_user)).then((value) => getRutina());
            Navigator.of(context).pop();
            nombre.clear();
          },
          width: 120,
        )
      ],
    ).show();
  }

  obtener_usuarios(id_rutina){
    api_rutina.get_usurios(id_rutina);
  }
  Future <List<UserModel>> obtener_usuarios_rutina(id_rutina){
   return api_rutina.get_usurios_rutina(id_rutina);
  }
  Future existe_el_ususrio(context,asignado_a,id_rutina,tipo_usuario)async{
    api_rutina.existe_el_ususrio(asignado_a, id_rutina).then((value) {
      if(value == "succes"){
        asignarUsuario(id_rutina, asignado_a, tipo_usuario).then((value) => succes2(context));
      }else{
        advertencia2(context);
      }
    });
    notifyListeners();
  }

  Future asignarUsuario(id_rutina,id_usuario, tipo_usuario)async{
    print('Asignar user');
    await getEjerciciosRutina(id_rutina);
    int cont = 0;
    ejercicios_rutina.forEach((element) async{
      cont ++;
      print('aaa ${element.nombre}');
      await api_rutina.asignatRutina(Rutina_Ejercicio_Model(
        series: element.series,
        repeticiones: element.repeticiones,
        nivel: element.nivel,
        id_ejercicio: element.id_ejercicio,
        id_rutina: id_rutina,
        asignado_a: id_usuario,
        tipo_usuario: tipo_usuario
      ));
    });
  }
  Future eliminar_rutina_usuario(asignado_a,id_rutina)async{
    await api_rutina.eliminar_rutina_usuario(asignado_a).then((value) => getUser());
  }
  Future eliminar_ejercicio_rutina(id_rutina, id_ejercicio)async{
    await api_rutina.eliminar_ejercicio_rutina(id_rutina, id_ejercicio);
  }


}
