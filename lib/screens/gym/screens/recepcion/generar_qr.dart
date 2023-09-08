import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/screens/recepcion/usuarios.dart';
import 'package:administrador/widgets/bottom_gradiant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
class Genererar_QR extends StatefulWidget {
  const Genererar_QR({Key? key}) : super(key: key);

  @override
  State<Genererar_QR> createState() => _Genererar_QRState();
}

class _Genererar_QRState extends State<Genererar_QR> {

  @override
  void initState() {
    // TODO: implement initState
    final provider = Provider.of<provider_entrenamiento>(context, listen: false);
    provider.getAsistencia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<provider_entrenamiento>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar qr"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Column(
            children: [
              Text("Escanea el codigo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              QrImage(
                data: "GymWonder",
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01,bottom: 10),
                child: GestureDetector(
                  onTap: () =>Get.to(Asistencia_Usuario(listAsistencia: provider.asitencias)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      BottomGradiant(
                        colorFinal: const Color.fromRGBO(0, 0, 0, 1),
                        colorInicial: const Color.fromRGBO(0, 0, 0, 1),
                        width: MediaQuery.of(context).size.width * .75,
                        heigth: MediaQuery.of(context).size.height * .04,
                      ),
                      Text(
                        "Ver usuarios",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
