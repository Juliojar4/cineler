class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha; //guarda somente o hash da senha

  Usuario({this.id, required this.nome, required this.email, required this.senha});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
      };

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
    );
  }
}
