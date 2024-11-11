import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/reto.dart';
import 'package:administrador/screens/gym/providers/provider_reto.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class usuariosReto extends StatefulWidget {
  RetoModel retoModel;
  int proviene;
  usuariosReto({Key? key, required this.retoModel, required this.proviene})
      : super(key: key);

  @override
  State<usuariosReto> createState() => _usuariosRetoState();
}

class _usuariosRetoState extends State<usuariosReto> {
  List<UserModel> users = [];

  @override
  void initState() {
    // TODO: implement initState
    getUsuario();
    super.initState();
  }

  getUsuario() {
    // TODO: implement initState
    final retoP = Provider.of<provider_reto>(context, listen: false);
    retoP.getUsuarios(widget.retoModel.id_reto);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final retos = Provider.of<provider_reto>(context);

    return Container(
      width: width,
      height: height,
      child: retos.isCargando == false && widget.proviene == 1
          ? Scaffold(
              appBar: AppBar(
                title: Text(retos.addPerson == false
                    ? "Usuarios agregados"
                    : "Agregar Usuario"),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              floatingActionButton: retos.addPerson == false
                  ? FloatingActionButton(
                      onPressed: () {
                        retos.cambiar();
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.black)
                  : FloatingActionButton(
                      onPressed: () {
                        retos.cambiar();
                      },
                      child: Icon(Icons.cancel),
                      backgroundColor: Colors.red),
              body: retos.addPerson == false && retos.userRetos.isNotEmpty
                  ? listaUsuarios(retos.userRetos, retos.addPerson, retos)
                  : retos.addPerson == false && retos.userRetos.isEmpty ||
                          retos.addPerson == true &&
                              retos.userDisponibles.isEmpty
                      ? const Center(
                          child: Text(
                          "No hay usuarios disponibles",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ))
                      : listaUsuarios(
                          retos.userDisponibles, retos.addPerson, retos))
          : retos.isCargando == false && widget.proviene == 2
              ? Scaffold(
                  appBar: AppBar(
                    title: Text("Seleccionar ganador"),
                    centerTitle: true,
                    backgroundColor: Colors.black,
                  ),
                  body: retos.addPerson == false && retos.userRetos.isNotEmpty
                      ? SizedBox(
                          width: width,
                          height: height,
                          child: Column(
                            children: [
                              const Text(
                                  "Como se va seleccionando es el orden de los ganadores"),
                              SizedBox(
                                  width: width,
                                  height: height / 1.5,
                                  child: listaUsuariosRegis(
                                      widget.retoModel.users!)),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black, // Background color
                                ),
                                onPressed: () {
                                  Iterable<UserModel> newl =
                                      widget.retoModel.users!.where((element) =>
                                          element.seleccionado == true);
                                  if(newl.isNotEmpty){
                                    retos.selecGandor(newl,widget.retoModel.id_reto,context);
                                  }else{
                                    retos.error(context);
                                  }

                                },
                                child: Text("Registrar Ganadores"),
                              )
                            ],
                          ))
                      : retos.addPerson == false && retos.userRetos.isEmpty ||
                              retos.addPerson == true &&
                                  retos.userDisponibles.isEmpty
                          ? const Center(
                              child: Text(
                              "No hay usuarios disponibles",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ))
                          : listaUsuarios(
                              retos.userDisponibles, retos.addPerson, retos))
              : LoadingAlert("Cargando..."),
    );
  }

  ListView listaUsuarios(
      List<UserModel> list, bool status, provider_reto reto) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Card(
              child: Container(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${list[index].nombre} ${list[index].apellidos}"),
                  Text(list[index].email),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Acciones"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {
                                reto.accion(context, widget.retoModel.id_reto,
                                    list[index].idU)
                              },
                          icon: Icon(
                            status == false ? Icons.cancel : Icons.add_circle,
                            color: status == false ? Colors.red : Colors.green,
                            size: 30,
                          )),
                    ],
                  ),
                ],
              )
            ],
          )))),
    );
  }

  ListView listaUsuariosRegis(List<UserModel> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Card(
              child: Container(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${list[index].nombre} ${list[index].apellidos}"),
                  Text(list[index].email),
                ],
              ),
              Checkbox(
                  value: list[index].seleccionado,
                  onChanged: (va) {
                    setState(() {
                      list[index].seleccionado = va;
                    });
                  })
            ],
          )))),
    );
  }
}
