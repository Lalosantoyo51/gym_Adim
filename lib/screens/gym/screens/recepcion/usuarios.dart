import 'package:administrador/screens/gym/models/asistencia.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Asistencia_Usuario extends StatefulWidget {
  const Asistencia_Usuario({Key? key})
      : super(key: key);

  @override
  State<Asistencia_Usuario> createState() => _Asistencia_UsuarioState();
}

class _Asistencia_UsuarioState extends State<Asistencia_Usuario> {
  @override
  void initState() {
    // TODO: implement initState
    // TODO: implement initState
    final provider = Provider.of<provider_entrenamiento>(context, listen: false);
    provider.getAsistencia();
    super.initState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final providerEnt = Provider.of<provider_entrenamiento>(context);
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (providerEnt.showUser) {
                providerEnt.mostrarInfo();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "usuarios",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
          width: width,
          height: heigth,
          child: providerEnt.showUser == false
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: providerEnt.asitencias.length,
                  itemBuilder: (context, index) => Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Card(
                        child: Container(
                            child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: width / 2,
                            child: Text(
                                "${providerEnt.asitencias[index].nombre} ${providerEnt.asitencias[index].apellido}")),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Acciones"),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      providerEnt.selectAsistencia = index;
                                      providerEnt.mostrarInfo();
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      color: Color.fromRGBO(6, 19, 249, 1),
                                      size: 30,
                                    )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ))),
                  ),
                )
              : ListaXusuario(
                  asistenciaModel:
                  providerEnt.asitencias[providerEnt.selectAsistencia])),
    );
  }
}

class ListaXusuario extends StatelessWidget {
  final AsistenciaModel asistenciaModel;
  const ListaXusuario({Key? key, required this.asistenciaModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerEnt = Provider.of<provider_entrenamiento>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: asistenciaModel.asistencia!.isNotEmpty
          ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Asistencia de ${asistenciaModel.nombre} ${asistenciaModel.apellido}",
                  style: const TextStyle(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      "Fecha",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "hora",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: asistenciaModel.asistencia!.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(providerEnt.formatter.format(DateTime.parse(
                              asistenciaModel.asistencia![index]["fecha"])),
                          style: const TextStyle(fontSize: 18),
                          ),
                          Text(providerEnt.horaFormatter.format(DateTime.parse(
                              asistenciaModel.asistencia![index]["fecha"])),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${asistenciaModel.nombre}  ${asistenciaModel.apellido}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const Text(
                  "No cuenta con asistencias",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            )),
    );
  }
}
