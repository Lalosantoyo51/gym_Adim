import 'package:flutter/material.dart';

class BottomGradiant extends StatelessWidget {
  final Color colorInicial;
  final Color colorFinal;
  final double width;
  final double heigth;

  const BottomGradiant({
    super.key,
    required this.colorFinal,
    required this.colorInicial,
    required this.width,
    required this.heigth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(255, 159, 95, 0.11999999731779099),
            offset: Offset(9, 12),
            blurRadius: 16,
          )
        ],
        gradient: LinearGradient(
          begin: const Alignment(0.8333333134651184, -8.310762744656586e-9),
          end: const Alignment(8.310762744656586e-9, 0.8333333134651184),
          colors: [
            colorInicial,
            colorFinal,
          ],
        ),
      ),
    );
  }
}
