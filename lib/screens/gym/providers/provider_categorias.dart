import 'package:administrador/screens/gym/api/categorias_apis.dart';
import 'package:administrador/screens/gym/models/categoria_eje.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class provider_cat_eje with ChangeNotifier {
  TextEditingController nombre = TextEditingController();
  TextEditingController buscar = TextEditingController();
  List<Categoria_eje> categorias = [];
  List<Categoria_eje> categoriasBuscar = [];
  Api_cat api_cat = Api_cat();
  bool isAgregar = false;
  bool iseditar = false;
  final ImagePicker _picker = ImagePicker();
  late Categoria_eje? cate;
  XFile? image;
  String uri_image = "";
  bool loading = false;
  bool isBuscar = false;


   getCategorias() async{
     loading = true;
    api_cat.get_eje_cat().then((List<Categoria_eje> categorias) {
      this.categorias = categorias;
      loading = false;
      notifyListeners();
    });
  }

  getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  registrarCatEje() {
     loading = true;
    api_cat
        .subirImagenCatEje(image!, Categoria_eje(nombre: nombre.text),"registrar")
        .then((cat) {
      if (cat != null) {
        isAgregar = false;
        image = null;
        nombre.clear();
        categorias = [];
        getCategorias();
        loading = false;
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
     loading = true;
    cate!.nombre = nombre.text;
    if(image != null){
      api_cat.subirImagenCatEje(image, cat, "actualizar").then((value){
        iseditar = false;
        getCategorias();
        loading = false;
      });    }else{
      api_cat.subirImagenCatEje(null, cat, "actualizar").then((value){
        iseditar = false;
        loading = false;
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

  buscarP(String bu){
    final bua =
    categorias.cast<Categoria_eje>().where((element) => element!.nombre.toUpperCase().contains(bu.toUpperCase()));
    if(bua.isEmpty){
      categoriasBuscar = [];
    }else{
      categoriasBuscar = [];
      bua.forEach((Categoria_eje cat) {
        categoriasBuscar.add(cat);
      });
    }
    notifyListeners();
  }

}