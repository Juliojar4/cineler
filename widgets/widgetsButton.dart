import 'package:flutter/material.dart';
class Botoes extends StatelessWidget {
  final String texto; //parametro
  final void Function() onPressed; //parametro referente ao metodo que
  //sera chamada da classe Home. Armazenara o caminho (ponteiro) da tela
  //que será chamado
  Botoes(this.texto, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
          child: Text(texto, style: TextStyle(fontSize: 16))),
    );
  }
}
