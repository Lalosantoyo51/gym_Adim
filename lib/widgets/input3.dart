import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Input3 extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String texto;
  final double fontSize;
  final double sizeInput;
  final bool isEmpty;
  final bool isBlack;
  final bool estado;
  final bool editable;
  int index;
  int index2;
  int dia;
  int proviene;
  final bool isNumber;
   Input3({
    super.key,
    required this.texto,
    required this.dia,
    required this.index,
    required this.index2,
    required this.proviene,
    required this.isNumber,
    this.onChanged,
    this.estado = false,
    this.sizeInput = 300,
    this.fontSize = 14,
    this.isEmpty = false,
    this.isBlack = true,
    this.editable = true,
  });

  @override
  State<Input3> createState() => _Input3();
}

class _Input3 extends State<Input3> {
  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    final ent = Provider.of<provider_entrenamiento>(context, listen: false);
    if(widget.proviene ==1){
      if(ent.dias[widget.dia].series![widget.index].ejercicios![widget.index2].series != "0" )
      inputController.text = ent.dias[widget.dia].series![widget.index].ejercicios![widget.index2].series.toString();

    }else{
      if(ent.dias[widget.dia].series![widget.index].ejercicios![widget.index2].repeticiones != 0 )

        inputController.text = ent.dias[widget.dia].series![widget.index].ejercicios![widget.index2].repeticiones.toString();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(255, 138, 95, 1);
    const secondaryColor = Color.fromRGBO(255, 138, 95, 1);
    const accentColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);
    const double border = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 1,
        ),
        Container(
          height: 50,
          width: widget.sizeInput,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                color: Colors.grey.withOpacity(.1),
              ),
            ],
          ),
          child: TextField(

            keyboardType: widget.isNumber == true ?TextInputType.number:TextInputType.text,
            enabled: widget.editable,
            controller: inputController,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: Text(
                widget.texto,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: primaryColor),
              ),
              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: accentColor,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: errorColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
