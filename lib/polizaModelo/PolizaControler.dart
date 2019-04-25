import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/polizaModelo/PolizaModel.dart';
import 'package:emision/polizaModelo/LiquidarControler.dart';
import 'package:emision/auxiliarModelo/Database.dart';

class DBPoliza {

  DBPoliza._();
  static DBPoliza db = DBPoliza._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();                                   // if _database is null we instantiate it
    return _database;
  }

  factory DBPoliza() {                                             // fixCombo (16 feb 2019): new factory para el combo, diferente forma de relacionar el db
    if(db == null) {
      db = DBPoliza._();
    }
    return db;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    );
  }

  Future<List<Map<String, dynamic>>> getObjetoMapList() async {   // fixCombo (16 feb 2019): gets all objetos from database
    Database db = await this.database;
    var result = await db.rawQuery('select clase as registro, descripcion from clase where tipo = 46 order by clase');
    return result;
  }

  Future<List<Objeto>> getObjetoList() async {                    // fixCombo (16 feb 2019): gets all objetos from database => memory (objetoList)
    var objetoMapList = await getObjetoMapList();
    int count = objetoMapList.length;
    List<Objeto> objetoList = List<Objeto>();
    for (int i = 0; i < count; i++) {
      objetoList.add(Objeto.fromMapObject(objetoMapList[i]));
    }
    return objetoList;
  }

  newPoliza(Poliza registro) async {
    final db = await database;

    var crud = await db.rawInsert (
        "insert into poliza ( sede, fechaEmision, periodo, numero, temporario, estado, intermediario, comision, cupoOperativo, "
        "afianzado, tipoPoliza, clausulado, periodoEmision, retroactividad, fechaHoraInicial, fechaHoraFinal, "+
        "contratante, objeto, numeroContrato, valorContrato, fechaInicial, fechaFinal, sincronizar ) "
        "values("
        " ?, ?, ?, ?, ?, ?, ?, ?, ?, "
        " ?, ?, ?, ?, ?, ?, ?, "
        " ?, ?, ?, ?, ?, ?, 0 )",
        [
          registro.sede,
          registro.fechaEmision,
          registro.periodo,
          registro.numero,
          registro.temporario,
          registro.estado,

          registro.intermediario,
          registro.comision,
          registro.cupoOperativo,

          registro.afianzado,
          registro.tipoPoliza,
          registro.clausulado,

          registro.periodoEmision,
          registro.retroactividad,
          registro.fechaHoraInicial,
          registro.fechaHoraFinal,

          registro.contratante,
          registro.objeto,
          registro.numeroContrato,
          registro.valorContrato,
          registro.fechaInicial,
          registro.fechaFinal
        ]
    );   // newPoliza.sincronizar

    var consulta = await db.rawQuery("select max(poliza) as id from poliza");
    int id = consulta.first["id"];
    print('Última poliza: '+id.toString());

    await nuevoAmparo( id.toString(), registro.objeto.toString(), "I", registro.afianzado.toString(), '' );

    return crud;
  }

  updatePoliza(Poliza registro) async {
    final db = await database;

    Poliza sincronizar = Poliza (
        sede: registro.sede,

        fechaEmision: registro.fechaEmision,
        periodo: registro.periodo,
        numero: registro.numero,
        temporario: registro.temporario,
        estado: registro.estado,

        intermediario: registro.intermediario,
        comision: registro.comision,
        cupoOperativo: registro.cupoOperativo,

        afianzado: registro.afianzado,
        tipoPoliza: registro.tipoPoliza,
        clausulado: registro.clausulado,

        periodoEmision: registro.periodoEmision,
        retroactividad: registro.retroactividad,
        fechaHoraInicial: registro.fechaHoraInicial,
        fechaHoraFinal: registro.fechaHoraFinal,

        contratante: registro.contratante,
        objeto: registro.objeto,
        numeroContrato: registro.numeroContrato,
        valorContrato: registro.valorContrato,
        fechaInicial: registro.fechaInicial,
        fechaFinal: registro.fechaFinal
    );

    var crud = await db.update("poliza", sincronizar.toMap(),
        where: "poliza = ?", whereArgs: [registro.poliza]);
    return crud;
  }

  blockOrUnblock(Poliza registro) async {

    final db = await database;

    String sentencia="0";
    if (registro.sincronizar > 0)
      sentencia="1";

    sentencia="update poliza set sincronizar = "+sentencia+
        " where poliza = "+registro.poliza.toString();
    print(sentencia);

    var crud = await db.execute(sentencia);
    return crud;
  }

  deletePoliza(int id) async {

    final db = await database;
    db.delete("poliza", where: "poliza = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from poliza");
  }

  getPoliza(int id) async {
    final db = await database;
    var consulta = await db.query("v_poliza", where: "poliza = ? ", whereArgs: [id]);
    return consulta.isNotEmpty ? Poliza.fromMap(consulta.first) : null;
  }

  Future<List<Poliza>> getAllPoliza() async {
    final db = await database;
    var consulta = await db.query("v_poliza order by poliza ");
    List<Poliza> list =
    consulta.isNotEmpty ? consulta.map((c) => Poliza.fromMap(c)).toList() : [];
    return list;
  }

}

class PolizaBloc {

  PolizaBloc() {
    getPoliza();
  }

  final _polizaController = StreamController<List<Poliza>>.broadcast();
  get polizas => _polizaController.stream;

  add(Poliza client) {
    DBPoliza.db.newPoliza(client);
    getPoliza();
  }

  update(Poliza client) {
    DBPoliza.db.updatePoliza(client);
    getPoliza();
  }

  delete(int id) {
    DBPoliza.db.deletePoliza(id);
    getPoliza();
  }

  dispose() {
    _polizaController.close();
  }

  getPoliza() async {
    _polizaController.sink.add(await DBPoliza.db.getAllPoliza());
  }

  blockUnblock(Poliza client) {
    DBPoliza.db.blockOrUnblock(client);
    getPoliza();
  }

}

void nuevoAmparo( String id, String clase, String crud, String auxiliar, String comodin) async {
  await DBLiquidador.nuevoAmparos( id, clase, crud, auxiliar, comodin );
}

