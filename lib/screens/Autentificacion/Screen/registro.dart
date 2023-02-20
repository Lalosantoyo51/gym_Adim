import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:administrador/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:intl/intl.dart';

class Registro extends StatefulWidget {
  String proviene;
  UserModel? user;
  Registro({super.key,this.proviene= "",this.user});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  ControladorAuth auth = ControladorAuth();
  TextEditingController email = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  TextEditingController contrasena_confirmacion = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController nacimiento = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final List genero = [
    {"nombre": "Genero", "id": 0},
    {"nombre": "Masculino", "id": 1},
    {"nombre": "Femenino", "id": 2},
  ];
  final List roles = [
    {"nombre": "Rol", "id": 0},
    {"nombre": "Administrador", "id": 3},
    {"nombre": "Instructor", "id": 4},
    {"nombre": "Nutriologo", "id": 5},
  ];
  int select = 0;
  int select2 = 0;
  //ControladorAuth auth = ControladorAuth();
  bool estado = false;
  @override
  void initState() {
    // TODO: implement initState
    print('proviene ${widget.proviene}');
    if(widget.proviene == "editar"){
      insert();
    }
    super.initState();
  }
  insert(){
    nombre.text = widget.user!.nombre;
    apellidos.text = widget.user!.apellidos;
    email.text = widget.user!.email;
    select = widget.user!.genero;
    nacimiento.text = widget.user!.fehca_nac;
    celular.text = widget.user!.celular;
    select2 = widget.user!.tipo_user;
    setState(() {});
  }

  crearNuevoUsuario(){
    if (nombre.text != "" &&
        apellidos.text != "" &&
        email.text != "" &&
        select != 0 &&
        select2 != 0 &&
        nacimiento.text != "" &&
        celular.text != "" &&
        contrasena.text != "" &&
        contrasena_confirmacion.text != "") {
      if (contrasena.text == contrasena_confirmacion.text) {
        auth.registrarUsuario(UserModel(
            tipo_user: select2,
            nombre: nombre.text,
            email: email.text,
            celular: celular.text,
            genero: select,
            fehca_nac: nacimiento.text,
            apellidos: apellidos.text,
            password: contrasena.text)).then((value){
          if(value == null){
            print('el value es null');
          }else{
            Navigator.pop(context);
          }
        });
        //Get.to(const Modulo(), transition: Transition.fadeIn);

      } else {
        print('las contraseña no coinciden');
      }
    }else{
      estado = true;

      print('Todos los campos son requeridos');
    }
  }

  editarUsuario(){
    if (nombre.text != "" &&
        apellidos.text != "" &&
        nacimiento.text != "" &&
        celular.text != "" ) {
        auth.actualizar_empleado(UserModel(
          idU: widget.user!.idU,
            tipo_user: select2,
            nombre: nombre.text,
            email: email.text,
            celular: celular.text,
            genero: select,
            fehca_nac: nacimiento.text,
            apellidos: apellidos.text,
            password: contrasena.text)).then((value){
          Navigator.pop(context);
        });
        //Get.to(const Modulo(), transition: Transition.fadeIn);
    }else{
      estado = true;
      print('Todos los campos son requeridos');
    }
  }

  verCalendario() async {
    DateTime date = await PlatformDatePicker.showDate(
      locale: const Locale('es'),
      backgroundColor: Colors.black87,
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    setState(() {
      nacimiento.text = formatter.format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: width * .125,
          right: width * .125,
          top: height * .05,
        ),
        height: height,
        width: width,
        child: ListView(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Ingresa los Datos",
                  style: TextStyle(
                    fontFamily: "Century",
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Input(
              inputController: nombre,
              texto: "Nombre",
              estado: estado,
            ),
            Input(
              inputController: apellidos,
              texto: "Apellidos",
              estado: estado,
            ),
            Input(
              inputController: email,
              texto: "Email",
              estado: estado,
              editable: widget.proviene == "editar"? false:true,
            ),
            widget.proviene == "editar"?
            Input(
              inputController: contrasena,
              texto: "${genero.firstWhere((element) => element["id"]== widget.user!.genero)["nombre"]}",
              estado: estado,
              editable: false,
            ):
            drop(height, context,genero,1,estado),
            SizedBox(
              height: height*.02,
            ),
            InkWell(
              onTap: ()=>verCalendario(),
              child: Input(
                editable: false,
                inputController: nacimiento,
                texto: "Fecha de Nacimiento",
                estado: estado,
              ),
            ),
            Input(inputController: celular, texto: "Celular", estado: estado),
            widget.proviene == "editar"?
            Input(
              inputController: contrasena,
              texto: "${roles.firstWhere((element) => element["id"]== widget.user!.tipo_user)["nombre"]}",
              estado: estado,
              editable: false,
            ):
            drop(height, context,roles,2,estado),
            SizedBox(
              height: height*.02,
            ),
            widget.proviene == "editar"?SizedBox():
            Input(
              inputController: contrasena,
              texto: "Contraseña",
              estado: estado,
            ),
            widget.proviene == "editar"?SizedBox():

            Input(
              inputController: contrasena_confirmacion,
              texto: "Confirmar Contrasena",
              estado: estado,
            ),
            Padding(
              padding: EdgeInsets.only(top: height * .01),
              child: GestureDetector(
                onTap: () {
                 setState(() {});
                 if(widget.proviene == "editar"){
                   editarUsuario();
                 }else{
                   crearNuevoUsuario();
                 }

                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    BottomGradiant(
                      colorFinal: const Color.fromRGBO(238, 70, 61, 1),
                      colorInicial: const Color.fromRGBO(255, 138, 95, 1),
                      width: width * .75,
                      heigth: height * .07,
                    ),
                    Text(
                      widget.proviene == "editar"? "Actualizar":
                      "Registrar",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column drop(double height, BuildContext context, List list,int provine,estado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5,),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: Color.fromRGBO(255, 138, 95, 1),
                style: BorderStyle.solid,
                width: 0.80),
          ),
          child: DropdownButton(
            underline: Container(),
            items: list
                .map((value) => DropdownMenuItem(
                      value: value['id'],
                      child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child:  Text(
                            value['nombre'],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: select == 0 && provine == 1 || select2 ==0 && provine ==2
                                    ? const Color.fromRGBO(255, 138, 95, 1)
                                    : Colors.black),
                          )),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if(provine == 1){
                  select = int.parse(value.toString());
                }else{
                  select2 = int.parse(value.toString());
                }
              });
            },
            isExpanded: true,
            value: provine == 1? select:select2,
          ),
        ),
        estado == true ?
        Text("Campo requerido"):SizedBox()

      ],
    );
  }
}
