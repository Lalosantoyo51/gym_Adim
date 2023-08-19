import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/registro.dart';
import 'package:administrador/screens/gym/api/entrenamiento_apis.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Usuarios extends StatefulWidget {
  String provine;
  int? id_ent;
  List<Entrenamoento_Model>? entrenamientos = [];
  Usuarios(
      {Key? key,
      required this.provine,
      this.id_ent,
      required this.entrenamientos})
      : super(key: key);

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  ControladorAuth auth = ControladorAuth();
  Rutina_Apis rutina_api = Rutina_Apis();
  Entrenamiento_Apis ent_api = Entrenamiento_Apis();
  List<UserModel> users = [];
  bool enable = true;
  bool isAdding = false;

  @override
  void initState() {
    // TODO: implement initState
    getUsers();
    super.initState();
  }

  getUsers() async {
    if (widget.provine == "home") {
      await auth.getUser().then((UserModel? user) {
        auth.get_admins(user!.email).then((List<UserModel> users) {
          setState(() {
            this.users = users;
            for (var user in users) {
              if (user.enable == 1) {
                user.disponible = true;
              } else {
                user.disponible = false;
              }
            }
          });
        });
      });
    } else {
      await ent_api
          .get_usurios_entrenamiento(widget.id_ent)
          .then((List<UserModel> users) {
        setState(() {
          this.users = users;
        });
      });
    }
  }

  adding() async {
    if (isAdding == false) {
      isAdding = true;
      await ent_api.get_usurios(widget.id_ent).then((List<UserModel> users) {
        setState(() {
          this.users = users;
        });
      });
    } else {
      isAdding = false;
      getUsers();
    }
  }

  gets() async {
    await ent_api.get_usurios(widget.id_ent).then((List<UserModel> users) {
      setState(() {
        this.users = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final rutina = Provider.of<provider_rutina>(context);
    final ent_provider = Provider.of<provider_entrenamiento>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.provine == "home" ? "Usuarios" : "Usuarios de la rutina",
          ),
          centerTitle: true,
          backgroundColor: Colors.black),
      floatingActionButton: FloatingActionButton(
          onPressed: () => widget.provine == "home"
              ? Get.to(Registro(
                  proviene: "registo",
                ))?.then((value) => getUsers())
              : adding(),
          backgroundColor: Colors.black,
          child: Icon(isAdding == false ? Icons.add : Icons.cancel)),
      body: Container(
        width: width,
        height: height,
        child: ListView.builder(
          itemCount: users.length,
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
                      Text("${users[index].nombre} ${users[index].apellidos}"),
                      Text("${users[index].email}"),
                      users[index].tipo_user == 3
                          ? const Text("Aministrador")
                          : users[index].tipo_user == 4
                              ? const Text("Instrusctor")
                              : users[index].tipo_user == 5
                                  ? Text("Nutriologo")
                                  : Text("Usuario"),
                    ],
                  ),
                  widget.provine == "home"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Acciones"),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () => Get.to(Registro(
                                          proviene: "editar",
                                          user: users[index],
                                        ))?.then((value) => getUsers()),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                      size: 30,
                                    )),
                                Switch(
                                    activeColor: Colors.black,
                                    value: users[index].disponible,
                                    onChanged: (value) {
                                      users[index].disponible = value;
                                      setState(() {
                                        if (value == true) {
                                          auth.isdisponible(
                                              0, users[index].idU);
                                        } else {
                                          auth.isdisponible(
                                              1, users[index].idU);
                                        }
                                      });
                                    }),
                                IconButton(
                                    onPressed: () => auth
                                        .eliminar_empleado(users[index].idU)
                                        .then((value) => getUsers()),
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 30,
                                    )),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Acciones"),
                            Row(
                              children: [
                                isAdding == false
                                    ? IconButton(
                                        onPressed: () => ent_provider
                                            .eliminar_rutina_usuario(
                                                users[index].idU,
                                                widget.id_ent,
                                                widget.entrenamientos)
                                            .then((value) => getUsers()),
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 30,
                                        ))
                                    : IconButton(
                                        onPressed: () =>
                                            ent_provider.existe_el_ususrio(
                                                context,
                                                users[index].idU,
                                                widget.id_ent,
                                                users[index].tipo_user,
                                                widget.entrenamientos),
                                        /*onPressed: () => rutina.asignarUsuario(widget.id_rutina,users[index].idU,users[index].tipo_user).then((value){
                                print('el value sss $value');
                                              if(value =="succes"){
                                  rutina.succes2(context);
                                }else{
                                  rutina.advertencia2(context);
                                }
                              }),*/
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.green,
                                          size: 30,
                                        )),
                              ],
                            ),
                          ],
                        ),
                ],
              )))),
        ),
      ),
    );
  }
}
