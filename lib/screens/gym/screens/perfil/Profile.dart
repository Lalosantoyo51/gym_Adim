import 'dart:convert';
import 'dart:io';
import 'package:administrador/presentation/blocs/notifications/bloc.dart';
import 'package:administrador/presentation/screens/home_screen.dart';
import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/login.dart';
import 'package:administrador/screens/gym/api/profile_api.dart';
import 'package:administrador/screens/gym/models/profile.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:administrador/screens/gym/screens/categoria_ejercicio.dart';
import 'package:administrador/screens/gym/screens/entrenamientos.dart';
import 'package:administrador/screens/gym/screens/novedades/historial.dart';
import 'package:administrador/screens/gym/screens/nutricion/usuarios.dart';
import 'package:administrador/screens/gym/screens/perfil/addLogro.dart';
import 'package:administrador/screens/gym/screens/perfil/editPerfil.dart';
import 'package:administrador/screens/gym/screens/recepcion/generar_qr.dart';
import 'package:administrador/screens/gym/screens/retos/retosP.dart';
import 'package:administrador/screens/gym/screens/rutina.dart';
import 'package:administrador/screens/gym/screens/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? image;
  ProfileApi api = ProfileApi();
  final ImagePicker _picker = ImagePicker();
  bool isEditingAboutme = false;
  TextEditingController url = TextEditingController();
  TextEditingController aboutme = TextEditingController();
  late ProfileModel perfil = ProfileModel();
  late UserModel user = UserModel(
      nombre: "",
      email: "",
      celular: "",
      genero: 1,
      fehca_nac: "",
      apellidos: "",
      password: "",
      tipo_user: 1);
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int pos = 1;

  void _onItemTapped(int index)async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 0:
          Get.to(Usuarios(
            provine: "home",
            entrenamientos: [],
          ));
          break;
        case 1:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_cat_eje>(
                    create: (_) => provider_cat_eje()),
                ChangeNotifierProvider<provider_ejercicios>(
                    create: (_) => provider_ejercicios()),
              ],
              builder: (context, child) =>
                  Categoria_ejercicio(proviene: "home"),
            ),
          ));
          break;
        case 2:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_rutina>(
                    create: (_) => provider_rutina()),
              ],
              builder: (context, child) => Rutina(),
            ),
          ));
          break;
        case 3:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_rutina>(
                    create: (_) => provider_rutina()),
              ],
              builder: (context, child) => Entrenamiento(),
            ),
          ));
          break;
        case 4:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_rutina>(
                    create: (_) => provider_rutina()),
              ],
              builder: (context, child) => RetosP(),
            ),
          ));
          break;
        case 5:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_rutina>(
                    create: (_) => provider_rutina()),
              ],
              builder: (context, child) => Genererar_QR(),
            ),
          ));
          break;
        case 6:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_nutricion>(
                    create: (_) => provider_nutricion()),
              ],
              builder: (context, child) => UsuarioNu(),
            ),
          ));
          break;
        case 7:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_nutricion>(
                    create: (_) => provider_nutricion()),
              ],
              builder: (context, child) => HistorialNovedades(),
            ),
          ));
          break;
        case 8:
          sp.clear();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<provider_rutina>(
                    create: (_) => provider_rutina()),
              ],
              builder: (context, child) => Login(),
            ),
          ));
          break;
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
  }

  getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    ProfileApi api = ProfileApi();
    var usu = sp.getString("usuario");
    if (usu != null) {
      user = UserModel.fromJson2(json.decode(usu));
      print('aaa ${user.imagen}');

      api.getProfile(user.idU).then((ProfileModel? perfil) {
        this.perfil = perfil!;
        if (perfil.img11 != null && perfil.logro != null) {
          pos = 3;
        }
        if (perfil.img21 != null && perfil.logro2 != null) {
          pos = 5;
        }
        setState(() {});
      });
    }
  }

  addLink(String tipo, {String? valor}) {
    if (valor != null) {
      url.text = valor;
    } else {
      url.clear();
    }
    Alert(
        context: context,
        type: AlertType.warning,
        content: Column(
          children: <Widget>[
            TextField(
              controller: url,
              decoration: InputDecoration(
                icon: const Icon(Icons.link),
                labelText: 'Agregar $tipo',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              updateUrl(tipo);
              updateProfile();
            },
            child: const Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  updateProfile() {
    api.updateProfile(perfil, user.idU).then((value) {
      if (value == "Se actualizo") {
        url.clear();
      }
    });
  }

  updateUrl(tipo, {String? valor}) {
    print('valor $valor');
    if (tipo == "youtube") {
      perfil.youtube = url.text;
    }
    if (tipo == "tiktok") {
      perfil.tiktok = url.text;
    }
    if (tipo == "twitter") {
      perfil.twitter = url.text;
    }
    if (tipo == "insta") {
      perfil.insta = url.text;
    }
  }
  Future<void> _launchInBrowser(String url) async {
    print('la url $url');
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch ';
    }
  }
  err(String tipo){
    Alert(
        context: context,
        type: AlertType.warning,
        title: "Advertencia",
        desc: "No se agregado la red social $tipo",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  subirImg(){
    ControladorAuth autC = ControladorAuth();
    autC.subirImagenUser(image, user!, "actualizar");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: menu(context),
      body: Container(
        width: width,
        height: height,
        child: CustomScrollView(
          shrinkWrap: true,
          physics: user.tipo_user ==4 ||user.tipo_user ==6 ?ScrollPhysics(): NeverScrollableScrollPhysics(),
          slivers: [cabeza(width,height),if(user.tipo_user ==4 ||user.tipo_user ==6) body()],
        ),
      ),
    );
  }

  Drawer menu(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Column(
                children:  [
                 const CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage("assets/HombreCaraPerfil.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  Text("${user.nombre} ${user.apellidos}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          if(user.tipo_user ==2)
          ListTile(
            title: const Text('Usuarios'),
            selected: _selectedIndex == 0,
            onTap: () {
              // Update the state of the app
              _onItemTapped(0);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2)
            const Divider(),
          if(user.tipo_user ==2)
            ListTile(
            title: const Text('Grupos Musculares'),
            selected: _selectedIndex == 1,
            onTap: () {
              // Update the state of the app
              _onItemTapped(1);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
            const Divider(),
          if(user.tipo_user ==2 || user.tipo_user ==4 || user.tipo_user ==6)

            ListTile(
            title: const Text('Rutinas'),
            selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              _onItemTapped(2);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2 || user.tipo_user ==4 || user.tipo_user ==6)
            const Divider(),
          if(user.tipo_user ==2 || user.tipo_user ==4 || user.tipo_user ==6)
            ListTile(
            title: const Text('Entrenamiento'),
            selected: _selectedIndex == 3,
            onTap: () {
              // Update the state of the app
              _onItemTapped(3);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2 || user.tipo_user ==4 || user.tipo_user ==6)
            const Divider(),
          ListTile(
            title: const Text('Retos'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(4);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
            const Divider(),
          if(user.tipo_user ==2 || user.tipo_user ==3)
            ListTile(
            title: const Text('Recepcion'),
            selected: _selectedIndex == 5,
            onTap: () {
              // Update the state of the app
              _onItemTapped(5);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2 || user.tipo_user ==3)
            const Divider(),
          if(user.tipo_user ==2 || user.tipo_user ==5)
            ListTile(
            title: const Text('Nutrición'),
            selected: _selectedIndex == 6,
            onTap: () {
              // Update the state of the app
              _onItemTapped(6);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2 || user.tipo_user ==5)
            const Divider(),
          if(user.tipo_user ==2 || user.tipo_user ==3)
            ListTile(
            title: const Text('Novedades'),
            selected: _selectedIndex == 7,
            onTap: () {
              // Update the state of the app
              _onItemTapped(7);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          if(user.tipo_user ==2 || user.tipo_user ==3)
            const Divider(),
          ListTile(
            title: const Text('Salir'),
            selected: _selectedIndex == 8,
            onTap: () {
              // Update the state of the app
              _onItemTapped(8);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  SliverList body() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, bottom: 20, right: 20, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Acerca de mi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      isEditingAboutme == false
                          ? IconButton(
                              onPressed: () {
                                isEditingAboutme = true;
                                if (perfil.aboutme != null) {
                                  aboutme.text = perfil.aboutme!;
                                }
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                          : IconButton(
                              onPressed: () {
                                perfil.aboutme = aboutme.text;
                                updateProfile();
                                isEditingAboutme = false;
                                setState(() {});
                              },
                              icon: const Icon(Icons.done, color: Colors.black))
                    ],
                  ),
                  const SizedBox(height: 5),
                  isEditingAboutme == false
                      ? Text(perfil.aboutme != null
                          ? perfil.aboutme!
                          : "Agrega una descripcion acerca de ti")
                      : TextField(
                          controller: aboutme,
                          maxLines: 8,
                          maxLength: 255,
                        ),
                  //TextField(
                  //  minLines: 3, // Set this
                  //  maxLines: 6, // and this
                  //  keyboardType: TextInputType.multiline,
                  //),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Logros destacados",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(perfil.logro == null
                          ? "0/3"
                          : perfil.logro != null && perfil.logro2 == null
                              ? "1/3"
                              : perfil.logro2 != null && perfil.logro3 == null
                                  ? "2/3"
                                  : "3/3")
                    ],
                  ),
                  if (pos == 1)
                    const Center(child: Text("No tienes logros agregados.")),
                  const SizedBox(
                    height: 10,
                  ),

                  if (perfil.logro != null)
                    logro(context, perfil.logro!, "${perfil.img11}",
                        "${perfil.img12}",1),
                  if (perfil.logro2 != null)
                    logro(context, perfil.logro2!, "${perfil.img21}",
                        "${perfil.img22}",3),
                  if (perfil.logro3 != null)
                    logro(context, perfil.logro3!, "${perfil.img31}",
                        "${perfil.img32}",5),
                  if (perfil.logro3 == null)
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(AddLogro(
                            perfil: perfil,
                            idUser: user.idU,
                            pos: pos,
                          ));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black)),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Agregar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20)),
                            )),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        childCount: 1,
      ),
    );
  }

  InkWell logro(BuildContext context, String logro, String img1, String img2, int pos) {
    return InkWell(
      onTap: (){
        Get.to(EditProfile(perfil: perfil, idUser: user.idU, pos: pos));
      },
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(logro),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: Image.network(
                          img1,
                          fit: BoxFit.fill,
                        )),
                    const SizedBox(width: 15),
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: Image.network(
                          img2,
                          fit: BoxFit.fill,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),const Positioned(
              right: 10,
              child:  Icon(Icons.edit,color: Colors.black,size: 25,))
        ],
      ),
    );
  }

  SliverAppBar cabeza(double width, double h) {
    final blocNoti = context.watch<NotificationsBloc>().state.notifications;

    return SliverAppBar(
      expandedHeight: user.tipo_user ==4 ||user.tipo_user == 6 ?390.0:h,
      floating: true,
      pinned: true,
      snap: true,
      actionsIconTheme: const IconThemeData(opacity: 0.0),
      flexibleSpace: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Container(
            width: width,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage(
                          "assets/login.jpeg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        )),
                  ),
                ),
                Center(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: ()async{
                          await getImage();
                          if(image != null){
                          await subirImg();
                          }
                            },
                             child:image== null && user.imagen == null?  const CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                                  AssetImage("assets/HombreCaraPerfil.png"),
                              backgroundColor: Colors.transparent,
                            ):image!= null ?  CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                              FileImage(File(image!.path.toString())),
                              backgroundColor: Colors.transparent,
                            ):CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                              NetworkImage("${user.imagen!}"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Text("${user.nombre} ${user.apellidos}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25)),
                          const SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    user.tipo_user == 2
                                        ? "Super Usuario":
                                    user.tipo_user == 3
                                        ? "Recepcionista"
                                        : user.tipo_user == 4
                                            ? "Instructor"
                                            : user.tipo_user == 5
                                                ? "Nutriologo"
                                                : "Preparador Fisico",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20)),
                              )),
                          const SizedBox(height: 10),
                          if(user.tipo_user == 4 ||user.tipo_user == 6)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 25, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: ()=> perfil.youtube != null ?_launchInBrowser(perfil.youtube!):err("Youtube"),
                                      child: const CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage:
                                            AssetImage("assets/youtube.png"),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    perfil.youtube == null
                                        ? IconButton(
                                            onPressed: () {
                                              addLink("youtube");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              addLink("youtube",
                                                  valor: perfil.youtube);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 25,
                                            ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: ()=> perfil.tiktok != null ? _launchInBrowser(perfil.tiktok!):err("Tiktok"),
                                        child: const CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          AssetImage("assets/tiktok.png"),
                                      backgroundColor: Colors.transparent,
                                    )),
                                    perfil.tiktok == null
                                        ? IconButton(
                                            onPressed: () {
                                              addLink("tiktok");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              addLink("tiktok",
                                                  valor: perfil.tiktok);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 25,
                                            ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: ()=>  perfil.twitter != null ?_launchInBrowser(perfil.twitter!):err("Twitter"),
                                        child: const CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          AssetImage("assets/twitter.png"),
                                      backgroundColor: Colors.white,
                                    )),
                                    perfil.twitter == null
                                        ? IconButton(
                                            onPressed: () {
                                              addLink("twitter");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              addLink("twitter",
                                                  valor: perfil.twitter);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 25,
                                            ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: ()=>  perfil.insta != null ?_launchInBrowser(perfil.insta!):err("Instagram"),
                                        child: const CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          AssetImage("assets/insta.png"),
                                      backgroundColor: Colors.white,
                                    )),
                                    perfil.insta == null
                                        ? IconButton(
                                            onPressed: () {
                                              addLink("insta");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              addLink("insta",
                                                  valor: perfil.insta);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 25,
                                            ))
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                if(user.tipo_user == 4 || user.tipo_user ==6)
                  Positioned(
                      right: 120,
                      top: MediaQuery.of(context).size.height/5.5,
                      child: Image.asset( user.tipo_user == 4?"assets/Gratis.png":"assets/premium.png",width: 50,height: 50,)),
              ],
            ),
          )),
          Positioned(
            bottom: -7,
            left: 0,
            right: 0,
            child: Container(
              height: 33,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
            ),
          ),

          Positioned(
            right: 20,
            top: 45,

            child: Stack(
              children: [
                //                      Get.to(HomeScreen());
                InkWell(onTap: () =>Get.to(HomeScreen()),
                
                child: Image.asset("assets/noti.png",width: 40,height: 40,color: Colors.white),
                ),
                if(blocNoti.isNotEmpty)
                  CircleAvatar(
                    minRadius: 10,
                    child: Text("${blocNoti.length}"), backgroundColor: Colors.red,)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
