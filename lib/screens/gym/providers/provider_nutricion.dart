import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/nutri_apis.dart';
import 'package:administrador/screens/gym/models/comida.dart';
import 'package:administrador/screens/gym/models/nutricion.dart';
import 'package:administrador/screens/gym/screens/nutricion/historial.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class provider_nutricion with ChangeNotifier {
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy', "es");
  NutriApis nutriApis = NutriApis();
  int step = 0;
  int cont = 0;
  TextEditingController proteinas = TextEditingController();
  TextEditingController lipidos = TextEditingController();
  TextEditingController carbohidratos = TextEditingController();
  TextEditingController comida1 = TextEditingController();
  TextEditingController descipcion1 = TextEditingController();
  TextEditingController hora1 = TextEditingController();
  TextEditingController comida2 = TextEditingController();
  TextEditingController descipcion2 = TextEditingController();
  TextEditingController hora2 = TextEditingController();
  TextEditingController comida3 = TextEditingController();
  TextEditingController descipcion3 = TextEditingController();
  TextEditingController hora3 = TextEditingController();
  TextEditingController comida4 = TextEditingController();
  TextEditingController descipcion4 = TextEditingController();
  TextEditingController hora4 = TextEditingController();
  TextEditingController comida5 = TextEditingController();
  TextEditingController descipcion5 = TextEditingController();
  TextEditingController hora5 = TextEditingController();
  TextEditingController comida6 = TextEditingController();
  TextEditingController descipcion6 = TextEditingController();
  TextEditingController hora6 = TextEditingController();
  TextEditingController pre = TextEditingController();
  TextEditingController ente = TextEditingController();
  TextEditingController despues = TextEditingController();
  TextEditingController suplementacion = TextEditingController();
  TextEditingController tips = TextEditingController();
  TextEditingController observaciones = TextEditingController();
  List<ComidaModel> comidas = [];
  List<NutricionModel> histNu = [];
  List<UserModel> usuarios = [];
  List<UserModel> usuariosBuscar = [];

  late NutricionModel nutricion = NutricionModel();

  insetNutricion(int id_user, UserModel user) async {
    nutricion.observaciones = observaciones.text;
    nutricion.tips = tips.text;
    nutricion.suplementacion = observaciones.text;
    nutricion.despues = despues.text;
    nutricion.asignado_a = id_user;
    nutricion.entrenamiento = ente.text;
    nutricion.pre_ent = pre.text;
    nutricion.proteinas = double.parse(proteinas.text);
    nutricion.carbohidratos = double.parse(carbohidratos.text);
    nutricion.lipidos = double.parse(lipidos.text);
    nutricion.comidas = comidas;
    print('comidas ${comidas.length}');
    comidas.forEach((element) {
      print('comida ${element.titulo}');
    });

    await nutriApis.insertNutri(nutricion).then((NutricionModel nu) {
      comidas.forEach((comida) {
        comida.asignado_a = id_user;
        comida.id_nutricion = nu.id_nutricion!;
        nutriApis.insertComida(comida);
        Get.to(HistorialNutri(userModel: user));
      });
    });
  }

  agregarComidas() {
    if (comida1.text.isNotEmpty) {
      comidas.add(ComidaModel(comida1.text, descipcion1.text, hora1.text));
    }
    if (comida2.text.isNotEmpty) {
      comidas.add(ComidaModel(comida2.text, descipcion2.text, hora2.text));
    }
    if (comida3.text.isNotEmpty) {
      comidas.add(ComidaModel(comida3.text, descipcion3.text, hora3.text));
    }
    if (comida4.text.isNotEmpty) {
      comidas.add(ComidaModel(comida4.text, descipcion4.text, hora4.text));
    }
    if (comida5.text.isNotEmpty) {
      comidas.add(ComidaModel(comida5.text, descipcion5.text, hora5.text));
    }
    if (comida6.text.isNotEmpty) {
      comidas.add(ComidaModel(comida6.text, descipcion6.text, hora6.text));
    }
  }

  Future getHistorial(int asignado_a) async {
    nutriApis.historialNu(asignado_a).then((value) {
      histNu = value;
      notifyListeners();
    });
  }

  Future getUsuarios() async {
    nutriApis.getUsuarios().then((List<UserModel> users) {
      usuarios = users;
      notifyListeners();
    });
  }

  buscarUsuario(String bu) {
    final user = usuarios.cast<UserModel>().where(
        (element) => element.nombre!.toUpperCase().contains(bu.toUpperCase()));
    if (user.isEmpty) {
      usuariosBuscar = [];
    } else {
      usuariosBuscar = [];
      user.forEach((UserModel user) {
        usuariosBuscar.add(user);
      });
    }
    notifyListeners();
  }

  verHora(context, num) async {
    Future<TimeOfDay?> selectedTime24Hour = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((v) {
      if(v != null){
        switch (num) {
          case 1:
            hora1.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
          case 2:
            hora2.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
          case 3:
            hora3.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
          case 4:
            hora4.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
          case 5:
            hora5.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
          case 6:
            hora6.text ="${v.hour.toString()}:${v.minute.toString()}";
            break;
        }
      }
      notifyListeners();
    });
  }

  limpiarForm(){
    step = 0;
    cont = 0;
    comidas.clear();
    proteinas.clear();
    lipidos.clear();
    carbohidratos.clear();
    comida1.clear();
    descipcion1.clear();
    hora1.clear();
    comida2.clear();
    descipcion2.clear();
    hora2.clear();
    comida3.clear();
    descipcion3.clear();
    hora3.clear();
    comida4.clear();
    descipcion4.clear();
    hora4.clear();
    comida5.clear();
    descipcion5.clear();
    hora5.clear();
    comida6.clear();
    descipcion6.clear();
    hora6.clear();
    pre.clear();
    ente.clear();
    despues.clear();
    suplementacion.clear();
    tips.clear();
    observaciones.clear();
  }
}
