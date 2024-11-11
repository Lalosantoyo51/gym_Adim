import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/entrenamiento_apis.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/asistencia.dart';
import 'package:administrador/screens/gym/models/dias.dart';
import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/serie.dart';
import 'package:administrador/screens/gym/screens/entrenamientos.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class provider_entrenamiento with ChangeNotifier {
  Entrenamiento_Apis ent_api = Entrenamiento_Apis();
  List<AsistenciaModel> asitencias = [];
  int selectAsistencia = 0;
  bool loading = false;

  TextEditingController nombre_entrenamiento = TextEditingController();
  List<DiasModel> dias = [
    DiasModel(dia: "Lunes", enable: false, series: []),
    DiasModel(dia: "Martes", enable: false, series: []),
    DiasModel(dia: "Miercoles", enable: false, series: []),
    DiasModel(dia: "Jueves", enable: false, series: []),
    DiasModel(dia: "Viernes", enable: false, series: []),
    DiasModel(dia: "Sabado", enable: false, series: []),
    DiasModel(dia: "Domingo", enable: false, series: []),
  ];

  List<Entrenamoento_Model> entrenamientos = [];
  List<Entrenamoento_Model> entrenamientosBuscar = [];
  List<Entrenamoento_Model> entrenamientosVista = [];

  UserModel? user;
  List<SerieModel> listSeries = [];

  TextEditingController rr = TextEditingController();
  TextEditingController descanso = TextEditingController();
  TextEditingController ejercicio_cardio_vascular = TextEditingController();
  TextEditingController observaciones = TextEditingController();
  TextEditingController repeticiones_en_reserva = TextEditingController();
  int step = 0;
  int dia = 10;
  String selectLunes = "0";
  String selectMartes = "0";
  String selectMiercoles = "0";
  String selectJueves = "0";
  String selectViernes = "0";
  String selectSabado = "0";
  String selectDomingo = "0";
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
  int intensidad = 0;
  int se = 10;
  bool showUser = false;
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy', "es");
  final DateFormat horaFormatter = DateFormat('HH:mm', "es");
  late DateTime inicio = DateTime.now();
  late DateTime fin = DateTime.now();

  getEjerciciosRutina(int id_rutina, i) async {
    print('el id ${id_rutina}, i $i');
    Rutina_Apis()
        .get_ejercicio_rutina(id_rutina)
        .then((List<SerieModel> series) {
      dias[i].series = series;
      notifyListeners();
    });
  }

  getEjerciciosEnt(int id_ent, id_rutina, i) async {
    print('el id ${id_ent}, i $i');
    Entrenamiento_Apis()
        .get_ejercicio_rutina(id_ent, id_rutina)
        .then((List<SerieModel> series) {
      dias[i].series = series;
      notifyListeners();
    });
  }

  mostrarFechaInicio(context) async {
    DateTime date = await PlatformDatePicker.showDate(
      locale: const Locale('es'),
      backgroundColor: Colors.black87,
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (date.isNull) {
    } else {
      inicio = date;
      notifyListeners();
    }
  }

  mostrarFechaFin(context) async {
    DateTime date = await PlatformDatePicker.showDate(
      locale: const Locale('es'),
      backgroundColor: Colors.black87,
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (date.isNull) {
    } else {
      fin = date;
      notifyListeners();
    }
  }

  next(context) {
    print('step ${step}');

    switch (step) {
      case 0:
        if (step == 0 &&
            nombre_entrenamiento.text.isNotEmpty &&
            dias.indexWhere((element) => element.enable == true) == 0) {
          step++;
        } else {
          advetencia2(context,
              "Se debe llenar todos los campos");
        }
        break;
      case 1:
        int cont = 0;
        bool error = false;
        dias.forEach((dia) {
          cont++;
          if (dia.dia == "Lunes" && dia.enable == true) {
            if (selectLunes == "0") {
              advetencia2(context, "Selecciona la rutina para el lunes");
            }
          }
          if (dia.dia == "Martes" && dia.enable == true) {
            if (selectMartes == "0") {
              advetencia2(context, "Selecciona la rutina para el Martes");
            }
          }
          if (dia.dia == "Miercoles" && dia.enable == true) {
            if (selectMiercoles == "0") {
              advetencia2(context, "Selecciona la rutina para el Miercoles");
            }
          }
          if (dia.dia == "Jueves" && dia.enable == true) {
            if (selectJueves == "0") {
              advetencia2(context, "Selecciona la rutina para el Jueves");
            }
          }
          if (dia.dia == "Viernes" && dia.enable == true) {
            if (selectViernes == "0") {
              advetencia2(context, "Selecciona la rutina para el Viernes");
            }
          }
          if (dia.dia == "Sabado" && dia.enable == true) {
            if (selectSabado == "0") {
              advetencia2(context, "Selecciona la rutina para el Sabado");
            }
          }
          if (dia.dia == "Domingo" && dia.enable == true) {
            if (selectDomingo == "0") {
              advetencia2(context, "Selecciona la rutina para el Domingo");
            }
          }
          if (cont == dias.length) {
            if (error == false) {
              step++;
            }
          }
        });
        break;
      case 2:
        int cont = 0;
        bool error = false;
        dias.forEach((dia) {
          cont++;
          if (dia.enable == true) {
            dia.series!.forEach((serie) {
              serie.ejercicios!.forEach((ejercicio) {
                if (ejercicio.series == 0 || ejercicio.repeticiones == 0) {
                  error = true;
                }
              });
            });
          }
          if (cont == dias.length) {
            if (error == false) {
              step++;
            } else {
              advetencia2(context, "Llena todos los campos");
            }
          }
        });
        break;
    }
    notifyListeners();
  }

  back() {
    if (step > -1) {
      step--;
    }
    notifyListeners();
  }

  onchange(int index, value) {
    switch (index) {
      case 0:
        {
          selectLunes = value;
          dias[index].num_dia = 0;
          dias[index].id_rutina = int.parse(value);

          notifyListeners();
        }
        break;

      case 1:
        {
          selectMartes = value;
          dias[index].num_dia = 1;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;
      case 2:
        {
          selectMiercoles = value;
          dias[index].num_dia = 2;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;

      case 3:
        {
          selectJueves = value;
          dias[index].num_dia = 3;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;

      case 4:
        {
          selectViernes = value;
          dias[index].num_dia = 4;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;

      case 5:
        {
          selectSabado = value;
          dias[index].num_dia = 5;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;
      case 6:
        {
          selectDomingo = value;
          dias[index].num_dia = 6;
          dias[index].id_rutina = int.parse(value);
          notifyListeners();
        }
        break;
    }
  }

  verReloj(context, proviene) async {
    TimeOfDay time2 = await PlatformDatePicker.showTime(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      showCupertino: false,
    );
    if (time2 != null) {
      /*if(proviene == 1){
        time = time2;
      }else{
        ejercicio_cardio_vascular = time2;
      }*/
    }
    notifyListeners();
  }

  asignarInt(va) {
    intensidad = int.parse(va);
    notifyListeners();
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

  insertarEntrenamiento(context) async {
    print('inserta el entramiento');
    await getUser();
    await ent_api
        .insetEnt(Entrenamoento_Model(
            creado_por: user!.idU,
            descanso: descanso.text,
            ejercicio_cardio_vascular: ejercicio_cardio_vascular.text,
            fecha_fin: fin.toString(),
            fecha_inicio: inicio.toString(),
            intensidad: intensidad,
            nombre_ent: nombre_entrenamiento.text,
            observaciones: observaciones.text,
            repeticiones_en_reserva: repeticiones_en_reserva.text,
            typo_user: user!.tipo_user))
        .then((Entrenamoento_Model ent) async {
      int cont = 0;
      for (var dia in dias) {
        cont++;
        if (dia.enable == true) {
          dia.id_ent = ent.id_ent;
          for (var serie in dia.series!) {
            for (var eje in serie.ejercicios!) {
              eje.id_ent = ent.id_ent;
              await ent_api.insertar_ejercicios_entrenamiento(Entrenamiento_Eje(
                  id_ent: ent.id_ent!,
                  num_dia: dia.num_dia!,
                  id_rutina: eje.id_rutina!,
                  id_serie: serie.id_serie!,
                  id_ejercicio: eje.id_ejercicio!,
                  serie: eje.series!,
                  repeticion: eje.repeticiones.toString(),
                  fecha_fin: "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  fecha_inicio: "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  asignado_a: user!.idU));
            }
          }
        }
        if (cont == dias.length) {
          limpiarForm();
          succesInsert(context);
        }
      }
    });
    notifyListeners();
  }

  limpiarForm() {
    rr.clear();
    descanso.clear();
    ejercicio_cardio_vascular.clear();
    observaciones.clear();
    repeticiones_en_reserva.clear();
    nombre_entrenamiento.clear();
    entrenamientosVista = [];
    entrenamientos = [];
    inicio = DateTime.now();
    fin = DateTime.now();
    step = 0;
    selectLunes = "0";
    selectMartes = "0";
    selectMiercoles = "0";
    selectJueves = "0";
    selectViernes = "0";
    selectSabado = "0";
    selectDomingo = "0";
    dias = [
      DiasModel(dia: "Lunes", enable: false, series: []),
      DiasModel(dia: "Martes", enable: false, series: []),
      DiasModel(dia: "Miercoles", enable: false, series: []),
      DiasModel(dia: "Jueves", enable: false, series: []),
      DiasModel(dia: "Viernes", enable: false, series: []),
      DiasModel(dia: "Sabado", enable: false, series: []),
      DiasModel(dia: "Domingo", enable: false, series: []),
    ];
  }

  onchangeS(value, index, index2, dia) {
    print('el index 1 $index y el index2 $index2');
    if (index == 0) {
      dias.forEach((dia) {
        dia.series!.forEach((serie) {
          serie.ejercicios!.forEach((ejercicios) {
            ejercicios.series = value;
            notifyListeners();
          });
        });
      });
    } else {
      dias[dia].series![index].ejercicios![index2].series = value;
      notifyListeners();
    }
  }

  onchangeR(String value, dia, {index, index2}) {
    if (index2 == 0) {
      dias.forEach((dia) {
        dia.series!.forEach((serie) {
          serie.ejercicios!.forEach((ejercicios) {
            ejercicios.repeticiones = int.parse(value);
            notifyListeners();
          });
        });
      });
    } else {
      dias[dia].series![index].ejercicios![index2].repeticiones =
          int.parse(value);
    }
    notifyListeners();
  }

  asignard(int i) {
    se = i;
    notifyListeners();
  }

  getEntrenamientos() {
    loading = true;
    ent_api.obtenerEntrenamiento().then((List<Entrenamoento_Model> entrena) {
      entrena.forEach((element) {
        element.dias!.forEach((dia) {
          dia.series!.removeWhere((element) => element.ejercicios!.isEmpty);
        });
      });
      loading = false;
      entrenamientos = entrena;
      entrenamientos.forEach((element) {
        print(
            'existe ${element.dias!.indexWhere((element) => element.num_dia == 2)}');
        var lunes = element.dias!.indexWhere((element) => element.num_dia == 0);
        var martes =
            element.dias!.indexWhere((element) => element.num_dia == 1);
        var miercoles =
            element.dias!.indexWhere((element) => element.num_dia == 2);
        var jueves =
            element.dias!.indexWhere((element) => element.num_dia == 3);
        var viernes =
            element.dias!.indexWhere((element) => element.num_dia == 4);
        var sabado =
            element.dias!.indexWhere((element) => element.num_dia == 5);
        var domingo =
            element.dias!.indexWhere((element) => element.num_dia == 6);
        if (lunes == -1) {
          element.dias!.add(DiasModel(dia: "0", series: [], num_dia: 0));
        }
        if (martes == -1) {
          element.dias!.add(DiasModel(dia: "1", series: [], num_dia: 1));
        }
        if (miercoles == -1) {
          element.dias!.add(DiasModel(dia: "2", series: [], num_dia: 2));
        }
        if (jueves == -1) {
          element.dias!.add(DiasModel(dia: "3", series: [], num_dia: 3));
        }
        if (viernes == -1) {
          element.dias!.add(DiasModel(dia: "4", series: [], num_dia: 4));
        }
        if (sabado == -1) {
          element.dias!.add(DiasModel(dia: "5", series: [], num_dia: 5));
        }
        if (domingo == -1) {
          element.dias!.add(DiasModel(dia: "6", series: [], num_dia: 6));
        }
      });
      notifyListeners();
    });
  }

  eliminarEnt(int id_ent) {
    ent_api.eliminarEnt(id_ent).then((value) => getEntrenamientos());
  }

  advertencia(context, int id_ent) async {
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "¿Estas seguro de eliminar el registro?",
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          color: Color.fromRGBO(6, 19, 249, 1),
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            eliminarEnt(id_ent);
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }


  succesInsert(context) async {
    await Alert(
      context: context,
      type: AlertType.success,
      title: "Correcto",
      desc: "Entrenamiento registrado",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Get.offAll(Entrenamiento());
          },
          width: 120,
        ),
      ],
    ).show();
  }
  yaTieneUsuario(context) async {
    await Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: "Este usuario ya cuenta con un entrenamiento",
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            limpiarForm();
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  advetencia2(context, String message) async {
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: message,
      buttons: [
        DialogButton(
          color: Color.fromRGBO(6, 19, 249, 1),
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

  Future existe_el_ususrio(context, asignado_a, id_ent, tipo_usuario,
      List<Entrenamoento_Model>? list,UserModel user, Entrenamoento_Model ent) async {
    Entrenamiento_Apis api_ent = Entrenamiento_Apis();
    api_ent.existe_el_ususrio(asignado_a, id_ent).then((value) {
      if (value == "succes") {
        asignarUsuario(id_ent, asignado_a, tipo_usuario, list)
            .then((value) => succes2(context, user, ent));
      } else {
        advertencia2(context);
      }
    });
    notifyListeners();
  }


  Future tieneEntUse(int id_user)async{
    return ent_api.tieneEntUse(id_user);
  }

  Future asignarUsuario(
      id_ent, id_usuario, tipo_usuario, List<Entrenamoento_Model>? list) async {
    print('Asignar user');
    int cont = 0;

    list!
        .where((element) => element.id_ent == id_ent)
        .forEach((element2) async {
      print('nombre ${element2.nombre_ent}');
      element2.dias!.forEach((dia) {
        dia!.series!.forEach((se) {
          se.ejercicios!.forEach((eje) async {
            await ent_api.asignatRutina(Entrenamiento_Eje(
                id_ent: id_ent,
                asignado_a: id_usuario,
                id_rutina: eje.id_rutina!,
                id_serie: eje.id_serie!,
                id_ejercicio: eje.id_ejercicio!,
                id_cat_eje: "${eje.id_cat_eje!}",
                num_dia: dia.num_dia!,
                repeticion: "${eje.repeticiones!}",
                serie: "${eje.series}",
                nombre: eje.nombre!,
                fecha_fin: "${fin.year}-${fin.month}-${fin.day}",
                fecha_inicio: "${inicio.year}-${inicio.month}-${inicio.day}",
                instrucciones: eje.instrucciones));
            //await ent_api.pushNotification(id_usuario, token, element2)
          });
        });
      });
    });
  }

  succes2(context, UserModel user, Entrenamoento_Model ent) {
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
            user.dispositivos!.forEach((element) {
              ent_api.pushNotification(user.idU, element.token,ent!);
            });
            limpiarForm();
            Navigator.pop(context);
          },
          width: 120,
        ),
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
            limpiarForm();
            Navigator.of(context).pop();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future eliminar_rutina_usuario(
      asignado_a, id_ent, List<Entrenamoento_Model>? list) async {
    list!
        .where((element) => element.id_ent == id_ent)
        .forEach((element2) async {
      print('nombre ${element2.nombre_ent}');
      element2.dias!.forEach((dia) {
        dia!.series!.forEach((se) {
          se.ejercicios!.forEach((eje) async {
            await ent_api
                .eliminar_rutina_usuario(asignado_a, eje.id_rutina, id_ent)
                .then((value) => getUser());
          });
        });
      });
    });
  }

  getAsistencia() {
    ent_api.getAsistencia().then((List<AsistenciaModel> listAsistencia) {
      asitencias = listAsistencia;
      notifyListeners();
    });
  }

  mostrarInfo() {
    if (showUser) {
      showUser = false;
    } else {
      showUser = true;
    }
    notifyListeners();
  }

  buscarP(String bu) {
    final bus = entrenamientos.cast<Entrenamoento_Model>().where((element) =>
        element.nombre_ent!.toUpperCase().contains(bu.toUpperCase()));
    if (bus.isEmpty) {
      entrenamientosBuscar = [];
    } else {
      entrenamientosBuscar = [];
      bus.forEach((Entrenamoento_Model ent) {
        entrenamientosBuscar.add(ent);
      });
    }
    notifyListeners();
  }
  mandarPush(id_usuario,token,Entrenamoento_Model entre){
    ent_api.pushNotification(id_usuario, token, entre);
  }
}
