import 'package:flutter/material.dart';
class Botoes extends StatelessWidget {
  String texto;
  void Function() onPressed;
  bool secundario;
  Botoes(this.texto, {required this.onPressed, this.secundario = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: secundario
          ? OutlinedButton(onPressed: onPressed, child: Text(texto))
          : FilledButton(onPressed: onPressed, child: Text(texto)),
    );
  }
}
