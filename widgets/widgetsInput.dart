import 'package:flutter/material.dart';
class InputTextos extends StatelessWidget {
  String rotulo; //Podera atribuir um rótulo
  String label; //Podera atribuir um "hint"
  TextEditingController controller;
  //Para pegar o texto digitado
  bool senha; //Esconde o texto digitado

  InputTextos(this.rotulo, this.label, {required this.controller, this.senha = false});
  //Construtor

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
