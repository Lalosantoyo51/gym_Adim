import 'dart:convert';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/novedad_api.dart';
import 'package:administrador/screens/gym/models/novedad.dart';
import 'package:administrador/screens/gym/models/pushModel.dart';
import 'package:administrador/screens/gym/screens/novedades/historial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class provider_novedad with ChangeNotifier {
  Novedad_api apiNovedad = Novedad_api();
  TextEditingController nombre = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isAgregar = false;
  bool isCargando = false;
  XFile? image;
  NovedadModel novedad = NovedadModel();
  List<NovedadModel> novedades = [];
  late DateTime inicio = DateTime(1995);
  late DateTime fin = DateTime(1995);
  List<PushModel> listpush = [];
  UserModel? user;

  final DateFormat formatter = DateFormat('dd-MMMM-yyyy', "es");


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

  getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  getNovedades(){
    isCargando = true;

    apiNovedad.getNovedades().then((List<NovedadModel> lisnoved){
      novedades = lisnoved;
      isCargando = false;
    }).then((value) => notifyListeners());


  }
  registrar(BuildContext context){
    isCargando = true;
    novedad.titulo = nombre.text;
    novedad.fecha_inicio = inicio.toString();
    novedad.fecha_fin = fin.toString();
    novedad.create_at = DateTime.now().toString();
    apiNovedad.subirImagenCatEje(image, novedad, "registrar").then((value){
      novedad = value;
      isCargando = false;
      image = null;
      nombre.clear();
      inicio = DateTime(1995);
      fin = DateTime(1995);
      Get.to(HistorialNovedades());
    });
    notifyListeners();
  }

  message(
      context,
      String message,
      ) async {
    await Alert(
      context: context,
      type: AlertType.success,
      title: "Correcto",
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  actualizar(BuildContext context){
    isCargando = true;
    novedad.titulo = nombre.text;
    novedad.fecha_inicio = inicio.toString();
    novedad.fecha_fin = fin.toString();
    apiNovedad.subirImagenCatEje(image, novedad, "actualizar").then((value){
      if(value == "se actualizo el registro"){
        message(context, "Se actualizo el registro");
      }
      isCargando = false;
      notifyListeners();

    });
    notifyListeners();
  }
  getUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var usu = sp.getString("usuario");
    if (usu != null) {
      user = UserModel.fromJson2(json.decode(usu));
    }
  }


  getHitorialPush()async{
    await getUser();
    await apiNovedad.getHistorialPush(user!.idU!).then((List<PushModel> list){
      listpush = list;
    });
    notifyListeners();

  }

}