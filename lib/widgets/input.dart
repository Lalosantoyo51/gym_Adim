import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController inputController;
  final String texto;
  final double fontSize;
  final double sizeInput;
  final bool isEmpty;
  final bool isBlack;
  final bool estado;
  final bool editable;
  final bool obscureText;
  bool isnumerico = false;
   Input({
    super.key,
    required this.inputController,
    required this.texto,
    this.estado = false,
    this.sizeInput = 300,
    this.fontSize = 14,
    this.isEmpty = false,
    this.isBlack = true,
    this.editable = true,
    this.obscureText = false,
    this.isnumerico = false
  });

  @override
  State<Input> createState() => _Input();
}

class _Input extends State<Input> {
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

          child: TextField(
            keyboardType:widget.isnumerico == true? TextInputType.number:TextInputType.text,
            obscureText: widget.obscureText,
            enabled: widget.editable,
            controller: widget.inputController,
            onChanged: (value) {
              setState(() {});
            },
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: Text(
                widget.texto,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: accentColor,
              hintStyle: TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(border)),
              ),
            ),
          ),
        ),
        Text(
          (widget.isEmpty == true ||
                      widget.inputController.text.isEmpty == true) &&
                  widget.estado == true
              ? "Campo requerido"
              : "",
          style: TextStyle(color: widget.isBlack ? Colors.black : Colors.white),
        )
      ],
    );
  }
}
