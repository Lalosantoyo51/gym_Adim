import 'dart:convert';

import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/Autentificacion/Screen/login.dart';
import 'package:administrador/screens/gym/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
   UserModel? user;

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  getUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var usu = sp.getString("usuario");
    print('usu ${usu}');
    if(usu != null){
      user = UserModel.fromJson2(json.decode(usu));
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return user == null?Login(): HomeAdmin(user: user!,);
  }
}


