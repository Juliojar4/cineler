import 'package:flutter/material.dart';
class InputTextos extends StatelessWidget {
  String rotulo;
  String label;
  TextEditingController controller;
  bool senha;

  InputTextos(this.rotulo, this.label, {required this.controller, this.senha = false});

  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      controller:  controller,
      obscureText: senha,
      style: TextStyle (
          color: Colors.black,
          backgroundColor: Colors.white
      ),
      decoration: InputDecoration(
          labelText: rotulo,
          hintText: label
      ),
    );

  }


}
