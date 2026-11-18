import 'package:flutter/material.dart';
class Imagens extends StatelessWidget {
  String? url;
  double altura;
  Imagens(this.url, this.altura);

  @override
  Widget build(BuildContext context) {
    final largura = altura * 2 / 3; // proporção de pôster/capa
    final vazio = Container(
      height: altura,
      width: largura,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported, size: largura / 2),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(altura > 100 ? 16 : 8),
      child: url == null
          ? vazio
          : Image.network(
              url!,
              height: altura,
              width: largura,
              fit: BoxFit.cover,
              errorBuilder: (context, erro, pilha) => vazio,
            ),
    );
  }
}
