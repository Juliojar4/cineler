import 'package:flutter/material.dart';
class Capa extends StatelessWidget {
  final String? url; //Endereço da imagem (pode faltar na API)
  final double largura;
  final double altura;

  Capa(this.url, {this.largura = 50, this.altura = 75});

  @override
  Widget build(BuildContext context) {
    final semImagem = Container(
      width: largura,
      height: altura,
      color: Colors.grey.shade300,
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
    if (url == null) return semImagem;
    return Image.network(url!,
        width: largura,
        height: altura,
        fit: BoxFit.cover,
        //sem Internet a lista continua funcionando, só sem a imagem
        errorBuilder: (context, erro, pilha) => semImagem);
  }
}
