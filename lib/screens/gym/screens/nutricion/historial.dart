import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/screens/gym/screens/nutricion/dietaPage.dart';
import 'package:administrador/screens/gym/screens/nutricion/formNutricion.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HistorialNutri extends StatefulWidget {

  UserModel userModel;
  HistorialNutri({Key? key,required this.userModel}) : super(key: key);

  @override
  State<HistorialNutri> createState() => _HistorialNutriState();
}

class _HistorialNutriState extends State<HistorialNutri> {
  @override
  void initState() {
    // TODO: implement initState
    getHisto();
    super.initState();
  }

  getHisto() {
    final nutriP = Provider.of<provider_nutricion>(context, listen: false);
    nutriP.getHistorial(widget.userModel.idU);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final nutriP = Provider.of<provider_nutricion>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Historial",
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          Get.to(FormNutricion(userModel: widget.userModel));
        },child: Icon(Icons.add),
      ),
      body: Container(
          width: width,
          height: height,
          child: ListView.builder(
            itemCount: nutriP.histNu.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                Get.to(DietaPage(nutricionModel: nutriP.histNu[index],));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person,color: Colors.black,size: 25,),
                          SizedBox(width: 25),
                          Text("${widget.userModel.nombre} ${widget.userModel.apellidos}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_month,color: Colors.black,size: 25,),
                          SizedBox(width: 25),
                          Text("${nutriP.formatter.format(DateTime.parse("${nutriP.histNu[index].created_at}"))}"),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
