import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/entrenamiento_apis.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/dias.dart';
import 'package:administrador/screens/gym/models/entrenamiento_eje.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/models/rutina_ejercicio_model.dart';
import 'package:administrador/screens/gym/models/serie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class provider_entrenamiento with ChangeNotifier {
  Entrenamiento_Apis ent_api =  Entrenamiento_Apis();
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
  List<Entrenamoento_Model> entrenamientosVista = [];

  UserModel? user;

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
  TimeOfDay time= const TimeOfDay(hour: 0,minute: 0);
  int intensidad = 0;
  int se = 10;



  final DateFormat formatter = DateFormat('dd-MMMM-yyyy',"es");
  late DateTime inicio =DateTime(1995);
  late DateTime fin =DateTime(1995);


  getEjerciciosRutina(int id_rutina,i) async {
    print('el id ${id_rutina}, i $i');
    Rutina_Apis()
        .get_ejercicio_rutina(id_rutina)
        .then((List<SerieModel> series) {
      dias[i].series = series;
      notifyListeners();
    });
  }



  mostrarFechaInicio(context)async{
    DateTime date = await PlatformDatePicker.showDate(
        locale: const Locale('es'),
    backgroundColor: Colors.black87,
    context: context,
    firstDate: DateTime(DateTime.now().year - 2),
    initialDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 2),
    );
    inicio = date;
    notifyListeners();
  }
  mostrarFechaFin(context)async{
    DateTime date = await PlatformDatePicker.showDate(
      locale: const Locale('es'),
      backgroundColor: Colors.black87,
      context: context,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    fin = date;
    notifyListeners();
  }
  next(){
    if(step <3){
      step ++;
    }
    notifyListeners();
  }
  back(){
    if(step >-1){
      step--;
    }
    notifyListeners();
  }

  onchange(int index, value){
    switch(index) {
      case 0: {
        selectLunes = value;
        dias[index].num_dia = 0;
        dias[index].id_rutina = int.parse(value);

        notifyListeners();
      }
      break;

      case 1: {
        selectMartes = value;
        dias[index].num_dia = 1;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
      }
      break;
      case 2: {
        selectMiercoles = value;
        dias[index].num_dia = 2;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
         }
      break;

      case 3: {
        selectJueves = value;
        dias[index].num_dia = 3;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
      }
      break;

      case 4: {
        selectViernes = value;
        dias[index].num_dia = 4;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
      }
      break;

      case 5: {
        selectSabado = value;
        dias[index].num_dia = 5;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
      }
      break;
      case 6: {
        selectDomingo = value;
        dias[index].num_dia = 6;
        dias[index].id_rutina = int.parse(value);
        notifyListeners();
      }
      break;
    }
  }
  verReloj(context, proviene)async{
    TimeOfDay time2 = await PlatformDatePicker.showTime(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      showCupertino: false,
    );
    if(time2 != null){
      /*if(proviene == 1){
        time = time2;
      }else{
        ejercicio_cardio_vascular = time2;
      }*/
    }
    notifyListeners();
  }
  asignarInt(va){
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
  insertarEntrenamiento()async{
    await getUser();
    await ent_api.insetEnt(Entrenamoento_Model(
      creado_por: user!.idU,
      descanso: descanso.text,
      ejercicio_cardio_vascular: ejercicio_cardio_vascular.text,
      fecha_fin: fin.toString(),
      fecha_inicio: inicio.toString(),
      intensidad: intensidad,
      nombre_ent: nombre_entrenamiento.text,
      observaciones: observaciones.text,
      repeticiones_en_reserva: repeticiones_en_reserva.text,
      typo_user: user!.tipo_user
    )).then((Entrenamoento_Model ent) async{
      for (var dia in dias){
        if(dia.enable == true){
          dia.id_ent = ent.id_ent;
          for(var serie in dia.series!){
            for(var eje in serie.ejercicios!){
              eje.id_ent = ent.id_ent;
              await ent_api.insertar_ejercicios_entrenamiento(Entrenamiento_Eje(id_ent: ent.id_ent!,
                  num_dia: dia.num_dia!,
                  id_rutina: eje.id_rutina!,
                  id_serie: serie.id_serie!,
                  id_ejercicio: eje.id_ejercicio!,
                  serie: eje.series!,
                  repeticion: eje.repeticiones.toString(),
                  asignado_a: user!.idU));
            }
          }
        }
      }
    });
    notifyListeners();
  }
  onchangeS(value,index,index2,dia){
    dias[dia].series![index].ejercicios![index2].series = value;
    notifyListeners();
  }
  onchangeR(String value,dia,{index, index2}){
    dias[dia].series![index].ejercicios![index2].repeticiones = int.parse(value);
    notifyListeners();
  }
  asignard(int i){
    se = i;
    notifyListeners();
  }

  getEntrenamientos(){
    ent_api.obtenerEntrenamiento().then((List<Entrenamoento_Model> entrena){
      entrena.forEach((element) {
        element.dias!.forEach((dia) {
          dia.series!.removeWhere((element) => element.ejercicios!.isEmpty);
        });
      });
      entrenamientos= entrena;
      notifyListeners();
    });
  }

}