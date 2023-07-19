import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Drop extends StatefulWidget {

  Drop({Key? key}) : super(key: key);

  @override
  State<Drop> createState() => _DropState();
}

class _DropState extends State<Drop> {
  String selectedValue = "0";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> series = const [
      DropdownMenuItem(value: "0", child: Text("Selecciona un opcion")),
      DropdownMenuItem(value: "Serie recta", child: Text("Serie recta")),
      DropdownMenuItem(value: "Biserie", child: Text("Biserie")),
      DropdownMenuItem(value: "Triserie", child: Text("Triserie")),
      DropdownMenuItem(value: "Circuito", child: Text("Circuito")),
      DropdownMenuItem(value: "Super Series", child: Text("Super Series")),
    ];
    return series;
  }
  @override
  Widget build(BuildContext context) {
    final rutina = Provider.of<provider_rutina>(context);
    return  DropdownButton(
      value: selectedValue,
      items: dropdownItems,
      onChanged: (value){
        setState(() {
          selectedValue = value!;
          rutina.selectedValue = value;
        });
      },
    );
  }
}
