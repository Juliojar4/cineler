import 'package:flutter/material.dart';
class Botoes extends StatelessWidget {
  String texto; //parametro
  void Function() onPressed; //parametro referente ao metodo que
  //sera chamada da classe Home. Armazenara o caminho (ponteiro) da tela
  //que será chamado
  Botoes(this.texto, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(texto)
    );
  }
}
