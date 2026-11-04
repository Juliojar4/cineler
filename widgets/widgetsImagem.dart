import 'package:flutter/material.dart';
class Imagens extends StatelessWidget {
  String? url;
  double altura;
  Imagens(this.url, this.altura);

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Icon(Icons.image_not_supported, size: altura);
    }
    return Image.network(
      url!,
      height: altura,
      errorBuilder: (context, erro, pilha) => Icon(Icons.image_not_supported, size: altura),
    );
  }
}
