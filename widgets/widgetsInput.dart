import 'package:flutter/material.dart';
class InputTextos extends StatelessWidget {
  String rotulo;
  String label;
  TextEditingController controller;
  bool senha;
  IconData? icone;

  InputTextos(this.rotulo, this.label, {required this.controller, this.senha = false, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: senha,
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: label,
          prefixIcon: icone == null ? null : Icon(icone),
        ),
      ),
    );
  }
}
