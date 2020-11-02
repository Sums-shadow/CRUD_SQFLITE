import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:roger/model/produitModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  var table = "produit";
  var myDataBase = "roger.db";
  Database db;

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, myDataBase);

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE $table(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom TEXT,
          prix TEXT)""");
    });
  }

  Future<int> insertData(Produit prod) async {
    db = await init();
    return await db.insert(table, prod.toMap());
  }

  fetchData() async {
    final db = await init();

    return await db.query(table);
  }

  Future<int> deleteData(int id) async {
    db = await init();
    int result = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return result;
  }
   Future<int> deleteAll() async {
    db = await init();
    int result = await db.delete(table);
    return result;
  }

  Future<int> updateData(var id, Produit prod) async {
    db =await init();
    return await db.update(table, prod.toMapSansId(), where: "id=?", whereArgs: [id]);
  }
}
