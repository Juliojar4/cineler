import 'package:flutter/material.dart';
class Textos extends StatelessWidget {
  String seutexto;
  Textos(this.seutexto);

  @override
  Widget build(BuildContext context) {
    return Text(
      seutexto,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
