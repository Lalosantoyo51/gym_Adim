import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/registro.dart';
import 'package:administrador/screens/gym/api/entrenamiento_apis.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/input2.dart';
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
  List<UserModel> usersBuscar = [];
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

  buscarP(String bu){
    final bus = users.cast<UserModel>().where((element) => element.nombre!.toUpperCase().contains(bu.toUpperCase()));
    if(bus.isEmpty){
      usersBuscar = [];
    }else{
      usersBuscar = [];
      bus.forEach((UserModel user) {
        usersBuscar.add(user);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final rutina = Provider.of<provider_rutina>(context);
    final ent_provider = Provider.of<provider_entrenamiento>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
                child: Input2(
                  texto: "Buscar",
                  onChanged: (value) => buscarP(value),
                )),
            SizedBox(
              width: width,
              height: height/1.4,
              child: ListView.builder(
                itemCount: usersBuscar.isEmpty? users.length:usersBuscar.length,
                itemBuilder: (context, index) =>card(usersBuscar.isEmpty?users[index]:usersBuscar[index], ent_provider) ,
              ),
            ),
          ],
        ),
      ),
    );

  }
  Container card(UserModel user, provider_entrenamiento ent_provider){
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${user.nombre} ${user.apellidos}"),
                        Text("${user.email}"),
                        user.tipo_user == 3
                            ? const Text("Aministrador")
                            : user.tipo_user == 4
                            ? const Text("Instrusctor")
                            : user.tipo_user == 5
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
                                  user: user,
                                ))?.then((value) => getUsers()),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                  size: 30,
                                )),
                            Switch(
                                activeColor: Colors.black,
                                value: user.disponible,
                                onChanged: (value) {
                                  user.disponible = value;
                                  setState(() {
                                    if (value == true) {
                                      auth.isdisponible(
                                          0, user.idU);
                                    } else {
                                      auth.isdisponible(
                                          1, user.idU);
                                    }
                                  });
                                }),
                            IconButton(
                                onPressed: () => auth
                                    .eliminar_empleado(user.idU)
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
                                    user.idU,
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
                                        user.idU,
                                        widget.id_ent,
                                        user.tipo_user,
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
                ))));
  }
}

