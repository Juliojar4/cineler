import 'package:flutter/material.dart';
class InputTextos extends StatelessWidget {
  final String rotulo; //Podera atribuir um rótulo
  final String label; //Podera atribuir um "hint"
  final TextEditingController controller;
  //Para pegar o texto digitado
  final bool senha; //Esconde o texto digitado
  final bool obrigatorio; //Avisa quando o campo estiver vazio

  InputTextos(this.rotulo, this.label,
      {required this.controller, this.senha = false, this.obrigatorio = false});
  //Construtor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: senha,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
            labelText: obrigatorio ? "$rotulo *" : rotulo,
            hintText: label,
            border: OutlineInputBorder()),
        validator: (valor) {
          if (obrigatorio && (valor == null || valor.trim().isEmpty)) {
            return "Campo obrigatório";
          }
          return null;
        },
      ),
    );
  }
}
