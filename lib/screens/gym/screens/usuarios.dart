import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/registro.dart';
import 'package:administrador/screens/gym/api/entrenamiento_apis.dart';
import 'package:administrador/screens/gym/api/rutina_apis.dart';
import 'package:administrador/screens/gym/models/entrenamiento_model.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/widgets/input2.dart';
import 'package:administrador/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Usuarios extends StatefulWidget {
  String provine;
  int? id_ent;
  List<Entrenamoento_Model>? entrenamientos = [];
  Entrenamoento_Model? ent;
  Usuarios(
      {Key? key,
      required this.provine,
      this.id_ent,
      this.ent,
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
  bool loading = true;


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
            loading = false;
          });
        });
      });
    } else {
      await ent_api
          .get_usurios_entrenamiento(widget.id_ent)
          .then((List<UserModel> users) {
        setState(() {
          this.users = users;
          loading = false;
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

  buscarP(String bu) {
    final bus = users.cast<UserModel>().where(
        (element) => element.nombre!.toUpperCase().contains(bu.toUpperCase()));
    if (bus.isEmpty) {
      usersBuscar = [];
    } else {
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
      body: loading == false? SizedBox(
        width: width,
        height: height,
        child: users.isEmpty
            ? const Center(
                child: Text(
                "No hay usuarios registrados",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ))
            : Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                      child: Input2(
                    texto: "Buscar",
                    onChanged: (value) => buscarP(value),
                  )),
                  SizedBox(
                    width: width,
                    height: height / 1.4,
                    child: ListView.builder(
                      itemCount: usersBuscar.isEmpty
                          ? users.length
                          : usersBuscar.length,
                      itemBuilder: (context, index) => card(
                          usersBuscar.isEmpty
                              ? users[index]
                              : usersBuscar[index],
                          ent_provider),
                    ),
                  ),
                ],
              ),
      ):LoadingAlert(""),
    );
  }

  Container card(UserModel user, provider_entrenamiento ent_provider) {
    StateSetter _setState;
    BuildContext context2;

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
                            ? const Text("Nutriologo")
                            : const Text("Usuario"),
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
                                color: Color.fromRGBO(6, 19, 249, 1),
                                size: 30,
                              )),
                          Switch(
                              activeColor: Colors.black,
                              value: user.disponible,
                              onChanged: (value) {
                                user.disponible = value;
                                setState(() {
                                  if (value == true) {
                                    auth.isdisponible(0, user.idU);
                                  } else {
                                    auth.isdisponible(1, user.idU);
                                  }
                                });
                              }),
                          IconButton(
                              onPressed: () => auth
                                  .eliminar_empleado(user.idU)
                                  .then((value) => getUsers()),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.black,
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
                                      .eliminar_rutina_usuario(user.idU,
                                          widget.id_ent, widget.entrenamientos)
                                      .then((value) => getUsers()),
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 30,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    print('el token ${user.dispositivos!.first.token}');

                                    int i=0;
                                    bool message = false;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: StatefulBuilder(
                                            // You need this, notice the parameters below:
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              _setState = setState;
                                              final ent = Provider.of<
                                                  provider_entrenamiento>(context);
                                              return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Center(
                                                        child: Text(
                                                            "Seleccion la duracion",style: TextStyle(fontWeight: FontWeight.bold),)),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    ent.inicio.year == 1995
                                                        ? ElevatedButton(
                                                        onPressed: () {
                                                          _setState(() {
                                                            ent.mostrarFechaInicio(
                                                                context);
                                                          });
                                                        },
                                                        child: const Text(
                                                            "Fecha Inicio"))
                                                        : Text(ent.formatter
                                                        .format(DateTime.parse(
                                                        ent.inicio
                                                            .toString()))
                                                        .toUpperCase()),
                                                    ent.fin.year == 1995
                                                        ? ElevatedButton(
                                                        onPressed: () {
                                                          _setState(() {
                                                            ent.mostrarFechaFin(
                                                                context);
                                                          });
                                                        },
                                                        child: const Text(
                                                            "Fecha Fin"))
                                                        : Text(ent.formatter
                                                        .format(DateTime.parse(
                                                        ent.fin.toString()))
                                                        .toUpperCase()),
                                                    const SizedBox(height: 15,),
                                                    if(message == true)
                                                    const Text("Las fechas son requeridas",style: TextStyle(color: Colors.red),),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        DialogButton(
                                                          color: Colors.red,
                                                          child: const Text(
                                                            "Cancelar",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            i =0;
                                                            ent_provider.limpiarForm();
                                                            Navigator.pop(context);

                                                          },
                                                          width: 120,
                                                        ),
                                                        DialogButton(
                                                          color: Colors.green,
                                                          child: const Text(
                                                            "Aceptar",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            i=1;
                                                            if(ent_provider.fin ==  DateTime(1995) || ent_provider.inicio ==  DateTime(1995)){
                                                              _setState(() {
                                                                message = true;
                                                              });

                                                            }else{
                                                              _setState(() {
                                                                message = false;
                                                              });
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                          width: 120,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),

                                        );
                                      },
                                    ).whenComplete((){
                                      if(i == 1 && message == false){

                                        ent_provider.tieneEntUse(user.idU).then((value) {
                                          print('id del usuario ${user.idU}');
                                          if(value == 0){
                                            ent_provider.existe_el_ususrio(
                                                context,
                                                user.idU,
                                                widget.id_ent,
                                                user.tipo_user,
                                                widget.entrenamientos,
                                              user,
                                              widget.ent!
                                            );

                                          }else{
                                            ent_provider.yaTieneUsuario(context);
                                          }
                                        });
                                      }
                                    });
                                  },
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
