import 'package:flutter/material.dart';
class Textos extends StatelessWidget {
  final String seutexto;
  final double tamanho;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        seutexto,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface, fontSize: tamanho),
      ),
    );
  }
  Textos(this.seutexto, {this.tamanho = 18});
}
