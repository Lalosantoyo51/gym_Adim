import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/ejercicio.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/rutina_model.dart';
import 'package:administrador/screens/gym/models/serie.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/rutina.dart';
import 'package:administrador/widgets/drop.dart';
import 'package:administrador/widgets/input.dart';
import 'package:administrador/widgets/nivel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class provider_rutina with ChangeNotifier {
  List<Rutina_Model> rutinas = [];
  List<Rutina_Ejercicio_Model> ejercicios_rutina = [];
  List<SerieModel> listSeries = [];
  Rutina_Apis api_rutina = Rutina_Apis();
  bool loading = false;
  UserModel? user;
  TextEditingController nombre = TextEditingController();
  TextEditingController series = TextEditingController();
  TextEditingController repeticiones = TextEditingController();
  TextEditingController nivel = TextEditingController();
  int rating = 0;
  String la = "";
  String selectedValue = "0";
  List<Ejercicio_Model> ejercicios = [];



  Future <List<Rutina_Model>> getRutina() async {
    await getUser();
    loading = true;
    await api_rutina.get_rutinas(user!.idU).then((List<Rutina_Model> rutinas) {
      this.rutinas = rutinas;
      loading = false;
      notifyListeners();
    });
    return rutinas;
  }

   getEjerciciosRutina(int id_rutina) async {
    print('id $id_rutina');
    loading = true;
    api_rutina
        .get_ejercicio_rutina(id_rutina)
        .then((List<SerieModel> series) {
      this.listSeries = series;
      loading = false;
      notifyListeners();
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

  Future eliminar_rutina(id_rutina) async {
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
            Get.to(Rutina());
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

  agregarEjercicio(context, int id_rutina, int id_ejercicio) async {
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
              api_rutina
                  .asignatRutina(Rutina_Ejercicio_Model(
                      id_rutina: id_rutina,
                      id_ejercicio: id_ejercicio,
                      asignado_a: user!.idU,
                      nivel: rating,
                      repeticiones: int.parse(repeticiones.text),
                      series: series.text))
                  .then((value) {
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

  advertencia(context, id_rutina) {
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
        children: [Input(inputController: nombre, texto: "Nombre")],
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
            api_rutina
                .insetRutina(Rutina_Model(
                    nombre: nombre.text,
                    id_usuario: user!.idU,
                    tipo_user: user!.tipo_user))
                .then((value) => getRutina());
            Navigator.of(context).pop();
            nombre.clear();
          },
          width: 120,
        )
      ],
    ).show();
  }

  obtener_usuarios(id_rutina) {
    api_rutina.get_usurios(id_rutina);
  }

  Future<List<UserModel>> obtener_usuarios_rutina(id_rutina) {
    return api_rutina.get_usurios_rutina(id_rutina);
  }

  Future existe_el_ususrio(context, asignado_a, id_rutina, tipo_usuario) async {
    api_rutina.existe_el_ususrio(asignado_a, id_rutina).then((value) {
      if (value == "succes") {
        asignarUsuario(id_rutina, asignado_a, tipo_usuario)
            .then((value) => succes2(context));
      } else {
        advertencia2(context);
      }
    });
    notifyListeners();
  }

  Future asignarUsuario(id_rutina, id_usuario, tipo_usuario) async {
    print('Asignar user');
    await getEjerciciosRutina(id_rutina);
    int cont = 0;
    listSeries.forEach((element) {
      element.ejercicios!.forEach((element2) async {
        cont++;
        print('aaa ${element2.nombre}');
        await api_rutina.asignatRutina(Rutina_Ejercicio_Model(
            series: element2.series,
            id_serie: element.id_serie,
            repeticiones: element2.repeticiones,
            nivel: element2.nivel,
            id_ejercicio: element2.id_ejercicio,
            id_rutina: id_rutina,
            asignado_a: id_usuario,
            tipo_usuario: tipo_usuario));
      });
    });
  }

  agregarSerie(context,id_rutina) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Tipo de Serie",
      content: Column(
        children: [
          Drop()
        ]
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
          color: Colors.green,
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<provider_cat_eje>(create: (_) => provider_cat_eje()),
                        ChangeNotifierProvider<provider_ejercicios>(create: (_) => provider_ejercicios()),
                      ],
                      builder: (context, child) => Categoria_ejercicio(proviene: "rutina",id_rutina: id_rutina),
                    )));
          },
          width: 120,
        )
      ],
    ).show();
    notifyListeners();

  }

  Future eliminar_rutina_usuario(asignado_a, id_rutina) async {
    await api_rutina
        .eliminar_rutina_usuario(asignado_a)
        .then((value) => getUser());
  }

  Future eliminar_ejercicio_rutina(id_rutina, id_ejercicio) async {
    await api_rutina.eliminar_ejercicio_rutina(id_rutina, id_ejercicio);
  }
  addEjercicio(Ejercicio_Model eje,id_rutina)async{
    await getUser();
     ejercicios.add(eje);
    ejercicios_rutina.add(Rutina_Ejercicio_Model(
      id_ejercicio: eje.id_ejercicio,
      asignado_a: user!.idU,
      tipo_usuario: user!.tipo_user,
      id_rutina: id_rutina
    ));
    notifyListeners();
  }


  insertRutina(id_rutina,context){
    int contador = 0;
    api_rutina.insetar_serie(SerieModel(
      id_rutina: id_rutina,
      serie: selectedValue
    )).then((SerieModel? serie){
      for(var ejercicio in ejercicios_rutina){
        contador++;
        print('el id dela serie ${serie!.id_serie}');
        ejercicio.id_serie = serie!.id_serie;
        ejercicio.asignado_a = user!.idU;
        api_rutina.asignatRutina(ejercicio);
        if(contador == ejercicios_rutina.length){
          print('temino el for');
          ejercicios_rutina = [];
          ejercicios = [];
          succes(context);
          rating = 0;
          notifyListeners();
        }
      }
    });
  }

  onchangeR(String value,{index}){
    ejercicios_rutina[index].repeticiones = int.parse(value);
    print('aaa ${value} el id $index');
  }
  onchangeS(value,index){
    //ejercicios_rutina[index].series = value;
    ejercicios_rutina[index].series = value;
  }
  onChangedRating(double value,index){
    ejercicios_rutina[index].nivel = value.toInt();

    print('sss ${value}');
  }
}
