import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'strezzlah.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> insertUser(String email, String password) async {
    final db = await instance.database;
    try {
      return await db.insert('users', {
        'email': email,
        'password': _hashPassword(password),
      });
    } catch (e) {
      return -1; // for duplicate entry or error
    }
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await instance.database;
    final hashedPassword = _hashPassword(password);
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<bool> login(String email, String password) async {
    final user = await getUser(email, password);
    return user != null;
  }

  Future<int> register(String email, String password) async {
    return await insertUser(email, password);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
