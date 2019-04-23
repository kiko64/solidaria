import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/anexoModelo/AnexoModel.dart';

class DBAnexo {

  DBAnexo._();
  static DBAnexo db = DBAnexo._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();       // if _database is null we instantiate it
    return _database;
  }

  factory DBAnexo() {                                             // fixCombo (16 feb 2019): new factory para el combo, diferente forma de relacionar el db
    if(db == null) {
      db = DBAnexo._();
    }
    return db;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    );
  }

  Future<List<Map<String, dynamic>>> getCategoriaMapList() async {  // fixCombo (16 feb 2019): gets all registros from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 221 order by registro');
    return result;
  }

  Future<List<Categoria>> getCategoriaList() async {                 // fixCombo (16 feb 2019): gets all registros from database => memory (registroList)
    var registroMapList = await getCategoriaMapList();
    int count = registroMapList.length;
    List<Categoria> registroList = List<Categoria>();
    for(int i = 0; i < count; i++) {
      registroList.add(Categoria.fromMapObject(registroMapList[i]));
    }
    return registroList;
  }

  newAnexo(Anexo registro) async {
    final db = await database;

    print('Interno   '+registro.interno.toString());
    print('Categoría '+registro.categoria.toString());
    print('Documento '+registro.documento);

    var crud = await db.rawInsert (
      "insert into anexo ( interno, categoria, documento ) "
      "values ( ?, ?, ? ) ",
      [
        registro.interno,
        registro.categoria,
        registro.documento
      ]
    );   // newAnexo.sincronizar

    var consulta = await db.rawQuery("select max(anexo) as id from anexo");
    int id = consulta.first["id"];
    print('Último auxiliar: '+id.toString());

    return crud;
  }

  updateAnexo(Anexo registro) async {
    final db = await database;

    Anexo sincronizar = Anexo(
      interno: registro.interno,
      categoria: registro.categoria,
      documento: registro.documento
    );

    var crud = await db.update("anexo", sincronizar.toMap(),
        where: "anexo = ?", whereArgs: [registro.anexo]);
    return crud;
  }
/*
  blockOrUnblock(Anexo registro) async {

    final db = await database;
    String sentencia="0";
    if (registro.sincronizar > 0)
      sentencia="1";

    sentencia="update anexo set sincronizar = "+sentencia+
        " where anexo = "+registro.anexo.toString();
    print(sentencia);

    var crud = await db.execute(sentencia);
    return crud;
  }
*/
  deleteAnexo(int id) async {

    final db = await database;
    db.delete("anexo", where: "anexo = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from anexo");
  }

  getAnexo(int id) async {
    final db = await database;
    var consulta = await db.query("v_anexo", where: "anexo = ? ", whereArgs: [id]);
    return consulta.isNotEmpty ? Anexo.fromMap(consulta.first) : null;
  }

  Future<List<Anexo>> getAllAnexo(String busqueda) async {
    final db = await database;

    if ( busqueda.length > 0)
      busqueda="titulo like '%${busqueda}%' OR  subtitulo LIKE '%${busqueda}%'";
    else
      busqueda="1 = 1";

    var consulta = await db.query("v_anexo", where: busqueda, orderBy: "anexo" );

    List<Anexo> list =
    consulta.isNotEmpty ? consulta.map((c) => Anexo.fromMap(c)).toList() : [];
    return list;
  }

}

class AnexoBloc {

  AnexoBloc(String busqueda) {
    getAnexo(busqueda);
  }

  final _anexoController = StreamController<List<Anexo>>.broadcast();
  get anexos => _anexoController.stream;

  add(Anexo client) {
    DBAnexo.db.newAnexo(client);
    getAnexo('');
  }

  update(Anexo client) {
    DBAnexo.db.updateAnexo(client);
    getAnexo('');
  }

  delete(int id) {
    DBAnexo.db.deleteAnexo(id);
    getAnexo('');
  }

  dispose() {
    _anexoController.close();
  }

  getAnexo(String busqueda) async {
    _anexoController.sink.add(await DBAnexo.db.getAllAnexo(busqueda));
  }
/*
  blockUnblock(Anexo client) {
    DBAnexo.db.blockOrUnblock(client);
    getAnexo('');
  }
*/
}
