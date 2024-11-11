import 'package:flutter/material.dart';

class Input2 extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String texto;
  final double fontSize;
  final double sizeInput;
  final bool isEmpty;
  final bool isBlack;
  final bool estado;
  final bool editable;
  const Input2({
    super.key,
    required this.texto,
    this.onChanged,
    this.estado = false,
    this.sizeInput = 300,
    this.fontSize = 14,
    this.isEmpty = false,
    this.isBlack = true,
    this.editable = true,
  });

  @override
  State<Input2> createState() => _Input2();
}

class _Input2 extends State<Input2> {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(0, 0, 0, 1);
    const secondaryColor = Color.fromRGBO(0, 0, 0, 1);
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
