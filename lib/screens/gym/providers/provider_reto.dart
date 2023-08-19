import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/api/retos_apis.dart';
import 'package:administrador/screens/gym/models/reto.dart';
import 'package:administrador/screens/gym/screens/retos/retosP.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class provider_reto with ChangeNotifier {
  bool addPerson = false;
  List<UserModel> userRetos = [];
  List<UserModel> userDisponibles = [];
  bool isCargando = false;
  List<RetoModel> listReto = [];
  List<RetoModel> listRetoHistorial = [];
  RetoApis retoApis = RetoApis();
  TextEditingController nombre = TextEditingController();
  TextEditingController objetivo = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController premio = TextEditingController();

  double nivel = 0.0;
  late DateTime inicio = DateTime(1995);
  late DateTime fin = DateTime(1995);
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy', "es");
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  mostrarFechaInicio(context) async {
    DateTime date = await PlatformDatePicker.showDate(
      locale: const Locale('es'),
      backgroundColor: Colors.black87,
      context: context,
      firstDate: DateTime(DateTime.now().year - 2),
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
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (date.isNull) {
    } else {
      fin = date;
      notifyListeners();
    }
  }

  onChangeNivel(double valor) {
    nivel = valor;
    notifyListeners();
  }

  insertarReto(context, String accion) {
    isCargando = true;
    notifyListeners();

    retoApis
        .subirImagenCatEje(
            image,
            RetoModel(
                nombre: nombre.text,
                objetivos: objetivo.text,
                descripcion: descripcion.text,
                nivel: nivel.toInt(),
                fecha_fin: fin.toString(),
                fecha_inicio: inicio.toString(),
                premio: premio.text),
            accion)
        .then((value) {
      getRetos();
      message(context, "Registro agregado ");
    });
  }

  getRetos() async {
    isCargando = true;
    await retoApis.get_retos().then((List<RetoModel> list) {
      listReto = list;
      isCargando = false;

      notifyListeners();
    });
  }

  getRetosHistorial() async {
    isCargando = true;
    await retoApis.get_retoHistorial().then((List<RetoModel> list) {
      listRetoHistorial = list;
      isCargando = false;
      notifyListeners();
    });
  }

  limpiarDatos() {
    nombre.clear();
    objetivo.clear();
    descripcion.clear();
    premio.clear();
    nivel = 0.0;
    inicio = DateTime(1995);
    fin = DateTime(1995);
    image = null;
    notifyListeners();
  }

  actualizar(context, RetoModel reto) {
    isCargando = true;
    reto.nombre = nombre.text;
    reto.objetivos = objetivo.text;
    reto.descripcion = descripcion.text;
    reto.premio = premio.text;
    reto.nivel = nivel.toInt();
    reto.fecha_fin = fin.toString();
    reto.fecha_inicio = inicio.toString();
    if (image != null) {
      retoApis.subirImagenCatEje(image, reto, "actualizar").then((value) {
        message(context, "Se actualizo el reto");
        getRetos();
      });
    } else {
      retoApis.subirImagenCatEje(null, reto, "actualizar").then((value) {
        message(context, "Se actualizo el reto");
        getRetos();
      });
      notifyListeners();
    }
  }

  eliminarReto(int id_reto, int fileid) {
    isCargando = true;
    retoApis.eliminar_reto(id_reto, fileid).then((value) => getRetos());
  }

  advertencia(context, int id_reto, int fileid,accion, {id_usuario}) async {
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      desc: "¿Estas seguro de eliminar el registro?",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          color: Colors.red,
          onPressed: () {
            if(accion == "reto"){
              eliminarReto(id_reto, fileid);
            }else{
              retoApis.eliminarRetoUsuario(id_reto, id_usuario).then((value) => getUsuarios(id_reto));
            }
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  message(context, String message,) async {
    await Alert(
      context: context,
      type: AlertType.success,
      title: "Correcto",
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            Get.offAll(RetosP());
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

  getUsuarios(id_reto) async {
    isCargando = true;
    await retoApis.getusuarioxreto(id_reto).then((List<UserModel> listUser) {
      userRetos = listUser;
    });
    await retoApis.getUsuariosDisponibles().then((List<UserModel> listUser) {
      userDisponibles = listUser;
      isCargando = false;

      notifyListeners();
    });
    if (userRetos.isNotEmpty) {
      userRetos.forEach((UserModel ob) {
        userDisponibles.removeWhere((UserModel user) => user.idU == ob.idU);
      });
    }
  }

  asignarUsuario(id_reto, id_usuario, asignadox) {
    retoApis.asignarUsu(id_reto, id_usuario, asignadox).then((value) => getUsuarios(id_reto));
  }

  accion(context,id_reto, id_usuario)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var usu = sp.getString("usuario");
    print('usu ${usu}');
    if (usu != null) {
      UserModel user = UserModel.fromJson2(json.decode(usu));
      if(addPerson == true){
        asignarUsuario(id_reto, id_usuario, user.idU);
      }else{
        advertencia(context, id_reto, 0, accion,id_usuario: id_usuario);
      }
    }


  }

  cambiar() {
    if (addPerson == false) {
      addPerson = true;
    } else {
      addPerson = false;
    }
    notifyListeners();
  }
}
