import 'package:administrador/screens/gym/models/novedad.dart';
import 'package:administrador/screens/gym/providers/provider_novedad.dart';
import 'package:administrador/screens/gym/screens/novedades/form_novedades.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HistorialNovedades extends StatefulWidget {
  const HistorialNovedades({Key? key}) : super(key: key);

  @override
  State<HistorialNovedades> createState() => _HistorialNovedadesState();
}

class _HistorialNovedadesState extends State<HistorialNovedades> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    final novedad = await Provider.of<provider_novedad>(context, listen: false);
    novedad.getNovedades();
  }

  @override
  Widget build(BuildContext context) {
    final novedad = Provider.of<provider_novedad>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Novedades"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(NovedadesForm(proviene: "add"));
            novedad.novedad = NovedadModel();
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add_circle)),
      body: novedad.novedades.isEmpty
          ?const  Center(
              child: Text("No hay novedaded",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            )
          : ListView.builder(
              itemCount: novedad.novedades.length,
              itemBuilder: (context, index) =>
                  contenerdorMo(novedad.novedades[index], context)),
    );
  }

  ListTile contenerdorMo(NovedadModel novedad, BuildContext context) {
    return ListTile(
        //TODO: COMPLEMENTAR ESTA IMPLEMENTACION
        //TITLE
        title: Text(novedad.titulo!.toUpperCase()),
        leading: novedad.imagen != null
            ? Image.network(
                novedad.imagen!,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/aptitud-fisica.png"),
              )
            : null,
        subtitle: Text("10-10-2023"),
        onTap: () {
          print('la imagen ${novedad.imagen}');
          Get.to(NovedadesForm(novedadModel: novedad, proviene: "actualiar"));
        });
  }
}
