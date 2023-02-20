import 'package:administrador/screens/gym/api/categorias_apis.dart';
import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class provider_cat_eje with ChangeNotifier {
  TextEditingController nombre = TextEditingController();
  List<Categoria_eje> categorias = [];
  Api_cat api_cat = Api_cat();
  bool isAgregar = false;
  bool iseditar = false;
  final ImagePicker _picker = ImagePicker();
  late Categoria_eje? cate;
  XFile? image;
  String uri_image = "";



   getCategorias() async{
    api_cat.get_eje_cat().then((List<Categoria_eje> categorias) {
      this.categorias = categorias;
      notifyListeners();
    });
  }

  getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  registrarCatEje() {
    api_cat
        .subirImagenCatEje(image!, Categoria_eje(nombre: nombre.text),"registrar")
        .then((cat) {
      if (cat != null) {
        isAgregar = false;
        image = null;
        nombre.clear();
        categorias = [];
        getCategorias();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  advertencia(context,id,fileid,) {
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
            eliminar_eje_cat(id,fileid);
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }
  actualizar(Categoria_eje cat){
    cate!.nombre = nombre.text;
    if(image != null){
      api_cat.subirImagenCatEje(image, cat, "actualizar").then((value){
        iseditar = false;
        getCategorias();
      });    }else{
      api_cat.subirImagenCatEje(null, cat, "actualizar").then((value){
        iseditar = false;
        getCategorias();
      });
      notifyListeners();
    }
    //print('${cate!.toJson()}');
  }

  eliminar_eje_cat(id_cat_eje,fileid){
    api_cat.eliminar_cat_eje(id_cat_eje,fileid).then((value) => getCategorias());
    notifyListeners();

  }

}