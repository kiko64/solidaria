import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/accionModelo/AccionModel.dart';

class DBAccion {

  DBAccion._();

  static final DBAccion db = DBAccion._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();       // if _database is null we instantiate it
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    );
  }

  newAccion(Accion registro) async {
    final db = await database;

    var crud = await db.rawInsert (
      "insert into g_accion ( fecha, agenda, categoria, usuario, sincronizar, interno, descripcion, titulo, subtitulo, detalle, seguimiento, procedencia, posicion ) "
      "values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) ",
      [
        registro.fecha,
        registro.agenda,
        registro.categoria,
        registro.usuario,
        registro.sincronizar,

        registro.interno,
        registro.descripcion,
        registro.titulo,
        registro.subtitulo,

        registro.detalle,
        registro.seguimiento,
        registro.procedencia,
        registro.posicion
      ]
    );   // newAccion.sincronizar

    var consulta = await db.rawQuery("select max(accion) as id from g_accion");
    int id = consulta.first["id"];
    print('Último auxiliar: '+id.toString());

    return crud;
  }

  updateAccion(Accion registro) async {
    final db = await database;

    Accion sincronizar = Accion(
      fecha: registro.fecha,
      agenda: registro.agenda,
      categoria: registro.categoria,
      usuario: registro.usuario,
      sincronizar: registro.sincronizar,
      interno: registro.interno,
      descripcion: registro.descripcion,
      titulo: registro.titulo,
      subtitulo: registro.subtitulo,
      detalle: registro.detalle,
      seguimiento: registro.seguimiento,
      procedencia: registro.procedencia,
      posicion: registro.posicion
    );

    var crud = await db.update("g_accion", sincronizar.toMap(),
        where: "accion = ?", whereArgs: [registro.accion]);
    return crud;
  }

  blockOrUnblock(Accion registro) async {

    final db = await database;

    String sentencia="0";
    if (registro.sincronizar > 0)
      sentencia="1";

    sentencia="update g_accion set sincronizar = "+sentencia+
        " where accion = "+registro.accion.toString();
    print(sentencia);

    var crud = await db.execute(sentencia);
    return crud;
  }

  deleteAccion(int id) async {

    final db = await database;
    db.delete("g_accion", where: "accion = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from g_accion");
  }

  getAccion(int id) async {
    final db = await database;
    var consulta = await db.query("g_accion", where: "accion = ? ", whereArgs: [id]);
    return consulta.isNotEmpty ? Accion.fromMap(consulta.first) : null;
  }

  Future<List<Accion>> getAllAccion(String busqueda) async {
    final db = await database;

    if ( busqueda.length > 0)
      busqueda="titulo like '%${busqueda}%' OR  subtitulo LIKE '%${busqueda}%'";
    else
      busqueda="1 = 1";

    var consulta = await db.query("g_accion", where: busqueda, orderBy: "accion" );

    List<Accion> list =
    consulta.isNotEmpty ? consulta.map((c) => Accion.fromMap(c)).toList() : [];
    return list;
  }

}


class AccionBloc {

  AccionBloc(String busqueda) {
    getAccion(busqueda);
  }

  final _accionController = StreamController<List<Accion>>.broadcast();
  get acciones => _accionController.stream;

  add(Accion client) {
    DBAccion.db.newAccion(client);
    getAccion('');
  }

  update(Accion client) {
    DBAccion.db.updateAccion(client);
    getAccion('');
  }

  delete(int id) {
    DBAccion.db.deleteAccion(id);
    getAccion('');
  }

  dispose() {
    _accionController.close();
  }

  getAccion(String busqueda) async {
    _accionController.sink.add(await DBAccion.db.getAllAccion(busqueda));
  }

  blockUnblock(Accion client) {
    DBAccion.db.blockOrUnblock(client);
    getAccion('');
  }

}
