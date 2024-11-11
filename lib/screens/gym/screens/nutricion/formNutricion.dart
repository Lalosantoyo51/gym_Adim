import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:administrador/screens/gym/models/nutricion.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class FormNutricion extends StatefulWidget {
  UserModel userModel;

   FormNutricion({Key? key,required this.userModel}) : super(key: key);

  @override
  State<FormNutricion> createState() => _FormNutricionState();
}

class _FormNutricionState extends State<FormNutricion> {
  @override
  void initState() {
    final nutri = Provider.of<provider_nutricion>(context,listen: false);
    nutri.limpiarForm();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final nutri = Provider.of<provider_nutricion>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Nutricion"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) => Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Container(
                height: height/1.4,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        steps(nutri.step),
                        nutri.step == 0?
                        step1(nutri): nutri.step ==1?
                        step2(nutri,width):
                        step3(nutri),
                      ],
                    ),
                  ],
                ),
              ),
              if(isKeyboardVisible == false)
              Positioned(
                  bottom: 10,
                  child: Container(
                    width: width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          nutri.step > 0?
                          boton(nutri, width,"Regresar",(){
                            setState(() {
                              nutri.step--;
                            });
                          }):Container(),
                          nutri.step <= 1?
                          boton(nutri, width, "Siguiente",(){
                            //ocultar los botones cuando el teclado esta visible
                            if(nutri.step == 1){
                              nutri.comidas = [];
                              nutri.agregarComidas();
                            }
                            nutri.step++;

                            print('step ${nutri.step}');
                            setState(() {

                            });
                          }):boton(nutri, width, "Finalizar",(){
                            setState(() {
                              nutri.insetNutricion(widget.userModel.idU,widget.userModel);
                            });
                          }),
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  Column step1(provider_nutricion nutri){
    return Column(
      children: [
        Text("Proteinas"),
        Input(
            inputController: nutri.proteinas,
            texto: "Proteinas",
            isnumerico: true),
        Text("Lipidos"),
        Input(
            inputController: nutri.lipidos,
            texto: "Lipidos",
            isnumerico: true),
        Text("Carbohidratos"),
        Input(
            inputController: nutri.carbohidratos,
            texto: "Carbohidratos",
            isnumerico: true),
      ],
    );
  }
  Column step2(provider_nutricion nutri, double width){
    return Column(
      children: [
        cardComida(nutri.comida1, nutri.descipcion1, 1,nutri.hora1,  nutri),
        if (nutri.cont >= 1)
          cardComida(nutri.comida2, nutri.descipcion2, 2,nutri.hora2,  nutri),
        if (nutri.cont >= 2)
          cardComida(nutri.comida3, nutri.descipcion3, 3,nutri.hora3,  nutri),
        if (nutri.cont >= 3)
          cardComida(nutri.comida4, nutri.descipcion4, 4,nutri.hora4,  nutri),
        if (nutri.cont >= 4)
          cardComida(nutri.comida5, nutri.descipcion5, 5,nutri.hora5,  nutri),
        if (nutri.cont >= 5)
          cardComida(nutri.comida6, nutri.descipcion6, 6,nutri.hora6,  nutri),
        if(nutri.cont < 5)
          InkWell(
            onTap: () {
              setState(() {
                nutri.cont++;
              });
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                width: width / 3,
                color: Colors.black,
                child: const Center(
                    child: Text(
                      "Agregar Comida",
                      style:  TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ))),
          ),
      ],
    );
  }

  Column step3(provider_nutricion nutri){
    return Column(
        children: [
          Text("Comidas Adicionales",style: TextStyle(fontWeight: FontWeight.bold),),
          Text("Pre-Entrenamiento"),
          Input(
              inputController: nutri.pre,
              texto: "Pre-Entrenamiento"),
          Text("Entrenamiento"),
          Input(
              inputController: nutri.ente,
              texto: "Entrenamiento"),
          Text("Despues"),
          Input(
              inputController: nutri.despues,
              texto: "Despues"),
          Text("Suplementacion"),

          Input(
              inputController: nutri.suplementacion,
              texto: "Suplementacion"),
          Text("Tips/indicaciones"),

          Input(
              inputController: nutri.tips,
              texto: "Tips/indicaciones"),
          Text("Observaciones"),

          Input(
              inputController: nutri.observaciones,
              texto: "Observaciones"),
        ],
    );
  }

  Card cardComida(TextEditingController controllerTitulo,
      TextEditingController controllerDescripcion, int num,TextEditingController hora,provider_nutricion nutri) {
    return Card(
      child: Column(
        children: [
          Text("Comida $num"),
          Input(
            inputController: controllerTitulo,
            texto: "Nombre",
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Descripcion"),
                Text("Hora"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.5,
                    child: Input(
                        inputController: controllerDescripcion,
                        texto: "Descripcion"),
                  ),
                  hora.text.isEmpty?
                  InkWell(
                      onTap: ()=> nutri.verHora(context,num),
                      child:  SizedBox(
                        width: 50,
                        child: Input(editable: false,
                            inputController: hora,
                            texto: ""),
                      )):InkWell(
                      onTap: ()=> nutri.verHora(context,num),
                      child: Text("${hora.text}"))
                ]),
          ),
        ],
      ),
    );
  }
  Padding steps(int step) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              "1",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: 20,
            height: 5,
            color: step >= 1 ? Colors.black : Colors.grey.shade300,
          ),
          CircleAvatar(
            backgroundColor: step >= 1 ? Colors.black : Colors.grey.shade300,
            child: Text(
              "2",
              style: TextStyle(color: step >= 1 ? Colors.white : Colors.black),
            ),
          ),
          Container(
            width: 20,
            height: 5,
            color: step >= 2 ? Colors.black : Colors.grey.shade300,
          ),
          CircleAvatar(
            backgroundColor: step >= 2 ? Colors.black : Colors.grey.shade300,
            child: Text(
              "3",
              style: TextStyle(color: step >= 2 ? Colors.white : Colors.black),
            ),
          ),

        ],
      ),
    );
  }
  InkWell boton(provider_nutricion nutri, double width, String text, Callback funcion ){
    return InkWell(
      onTap: funcion,
      child: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          width: width / 2.5,
          color: Colors.black,
          child:  Center(
              child: Text(
                text,
                style:const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }

}
