import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/titulo.dart';
import '../model/usuario.dart';

class BancoService {
  static Database? _db;

  Future<Database> get _banco async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'cineler.db'),
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
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
            usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
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

  static String _hash(String senha) => sha256.convert(utf8.encode(senha)).toString();

  //RF-01: e-mail repetido é barrado pelo UNIQUE da tabela
  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    final db = await _banco;
    try {
      await db.insert('usuarios',
          Usuario(nome: nome, email: email.toLowerCase(), senha: _hash(senha)).toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception("Já existe um usuário com este e-mail");
      }
      rethrow;
    }
  }

  //RF-02: retorna o usuário se e-mail e senha conferirem
  Future<Usuario?> entrar(String email, String senha) async {
    final db = await _banco;
    final res = await db.query('usuarios',
        where: 'email = ? AND senha = ?', whereArgs: [email.toLowerCase(), _hash(senha)]);
    return res.isEmpty ? null : Usuario.fromMap(res.first);
  }

  //RF-06
  Future<void> salvarTitulo(Usuario usuario, Titulo titulo) async {
    final db = await _banco;
    try {
      await db.insert('titulos', titulo.copiaCom(usuarioId: usuario.id).toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception("Este título já está na sua lista");
      }
      rethrow;
    }
  }

  //RF-07: somente os títulos do usuário ativo
  Future<List<Titulo>> listarTitulos(Usuario usuario) async {
    final db = await _banco;
    final res = await db.query('titulos',
        where: 'usuario_id = ?', whereArgs: [usuario.id], orderBy: 'nome');
    return res.map((t) => Titulo.fromMap(t)).toList();
  }

  //Procura o título na lista do usuário (null se ainda não salvou)
  Future<Titulo?> buscarTitulo(Usuario usuario, Titulo titulo) async {
    final db = await _banco;
    final res = await db.query('titulos',
        where: 'usuario_id = ? AND tipo = ? AND id_api = ?',
        whereArgs: [usuario.id, titulo.tipo, titulo.idApi]);
    return res.isEmpty ? null : Titulo.fromMap(res.first);
  }

  //RF-08
  Future<void> atualizarSituacao(Usuario usuario, Titulo titulo) async {
    final db = await _banco;
    await db.update('titulos', {'situacao': titulo.situacao},
        where: 'id = ? AND usuario_id = ?', whereArgs: [titulo.id, usuario.id]);
  }

  //RF-09
  Future<void> removerTitulo(Usuario usuario, Titulo titulo) async {
    final db = await _banco;
    await db.delete('titulos',
        where: 'id = ? AND usuario_id = ?', whereArgs: [titulo.id, usuario.id]);
  }
}
