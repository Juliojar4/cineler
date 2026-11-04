import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';

class BancoService {
  static Database? _db;

  Future<Database> _abrir() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'cineler.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL)''');
        await db.execute('''
          CREATE TABLE titulos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            id_api TEXT NOT NULL,
            tipo TEXT NOT NULL,
            nome TEXT NOT NULL,
            descricao TEXT,
            imagem TEXT,
            info TEXT,
            situacao TEXT NOT NULL,
            UNIQUE(usuario_id, tipo, id_api))''');
      },
    );
    return _db!;
  }

  //A senha é guardada somente como hash
  String _hash(String senha) {
    return sha256.convert(utf8.encode(senha)).toString();
  }

  //Retorna false se o e-mail já estiver cadastrado
  Future<bool> cadastrarUsuario(String nome, String email, String senha) async {
    final db = await _abrir();
    final id = await db.insert(
      'usuarios',
      {'nome': nome, 'email': email.toLowerCase(), 'senha': _hash(senha)},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return id != 0;
  }

  //Retorna null se o e-mail ou a senha estiverem errados
  Future<Usuario?> entrar(String email, String senha) async {
    final db = await _abrir();
    final res = await db.query('usuarios',
        where: 'email = ? AND senha = ?', whereArgs: [email.toLowerCase(), _hash(senha)]);
    return res.isEmpty ? null : Usuario.fromMap(res.first);
  }

  Future<void> salvarTitulo(Usuario usuario, Titulo titulo) async {
    final db = await _abrir();
    await db.insert('titulos', {...titulo.toMap(), 'usuario_id': usuario.id},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Titulo>> listarTitulos(Usuario usuario) async {
    final db = await _abrir();
    final res = await db.query('titulos',
        where: 'usuario_id = ?', whereArgs: [usuario.id], orderBy: 'nome');
    return res.map((item) => Titulo.fromMap(item)).toList();
  }

  //Procura o título na lista do usuário, retorna null se não estiver salvo
  Future<Titulo?> buscarTitulo(Usuario usuario, Titulo titulo) async {
    final db = await _abrir();
    final res = await db.query('titulos',
        where: 'usuario_id = ? AND tipo = ? AND id_api = ?',
        whereArgs: [usuario.id, titulo.tipo, titulo.idApi]);
    return res.isEmpty ? null : Titulo.fromMap(res.first);
  }

  Future<void> atualizarSituacao(Titulo titulo) async {
    final db = await _abrir();
    await db.update('titulos', {'situacao': titulo.situacao},
        where: 'id = ?', whereArgs: [titulo.id]);
  }

  Future<void> removerTitulo(Titulo titulo) async {
    final db = await _abrir();
    await db.delete('titulos', where: 'id = ?', whereArgs: [titulo.id]);
  }
}
