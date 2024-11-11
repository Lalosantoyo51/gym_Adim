import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/screens/gym/screens/nutricion/formNutricion.dart';
import 'package:administrador/screens/gym/screens/nutricion/historial.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';



class UsuarioNu extends StatefulWidget {
  const UsuarioNu({Key? key}) : super(key: key);

  @override
  State<UsuarioNu> createState() => _UsuarioNuState();
}

class _UsuarioNuState extends State<UsuarioNu> {

  List<UserModel> users = [];

  @override
  void initState() {
    // TODO: implement initState
    getUsuario();
    super.initState();
  }

  getUsuario() {
    // TODO: implement initState
    final nutriP = Provider.of<provider_nutricion>(context, listen: false);
    nutriP.getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final nutriP = Provider.of<provider_nutricion>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(title: Text("Usuarios"),centerTitle: true,backgroundColor: Colors.black,),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Center(
                child: Input2(
                  texto: "Buscar",
                  onChanged: (value) => nutriP.buscarUsuario(value),
                )),
            Container(
                height: height/1.3,
                child: listaUsuarios(nutriP.usuariosBuscar.isEmpty
                    ? nutriP.usuarios
                    : nutriP.usuariosBuscar)),
          ],
        ),
      ),
    );
  }
  ListView listaUsuarios(
      List<UserModel> list) {
    final nutriP = Provider.of<provider_nutricion>(context);

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: (){
          Get.to(HistorialNutri(userModel: list[index]));
        },
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Card(
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 10,),
                              Text("${list[index].nombre} ${list[index].apellidos}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(width: 10,),
                              Text("${list[index].email}"),
                            ],
                          ),
                        ],
                      ),
                    )))),
      ),
    );
  }
}
