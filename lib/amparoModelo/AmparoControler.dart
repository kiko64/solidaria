import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/amparoModelo/AmparoModel.dart';
import 'package:emision/polizaModelo/LiquidarControler.dart';

class DBAmparo {

  DBAmparo._();
  static DBAmparo db = DBAmparo._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();                                    // if _database is null we instantiate it
    return _database;
  }

  factory DBAmparo() {                                             // fixCombo (16 feb 2019): new factory para el combo, diferente forma de relacionar el db
    if(db == null) {
      db = DBAmparo._();
    }
    return db;
  }

  Future<Database> initDB() async {                                // fixCombo (16 feb 2019): add Future<Database>
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    );
  }

  Future<List<Map<String, dynamic>>> getConceptoMapList() async {  // fixCombo (16 feb 2019): gets all conceptos from database
    Database db = await this.database;
    var result = await db.rawQuery('select concepto as registro, descripcion from concepto where grupo = 18 order by concepto');
    return result;
  }

  Future<List<Concepto>> getConceptoList() async {                 // fixCombo (16 feb 2019): gets all conceptos from database => memory (conceptoList)
    var conceptoMapList = await getConceptoMapList();
    int count = conceptoMapList.length;
    List<Concepto> conceptoList = List<Concepto>();
    for(int i = 0; i < count; i++) {
      conceptoList.add(Concepto.fromMapObject(conceptoMapList[i]));
    }
    return conceptoList;
  }

  newAmparo(Amparo registro) async {

    final db = await database;

    //   'amparo ,orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,porcentaje, valorAsegurado, tasaAmparo, prima

    String sentencia = "delete from amparo where concepto between 10400 and 10410 and poliza = "+registro.poliza.toString();
    await db.execute(sentencia);

    int id = 1;
    sentencia = "select count(*) as id from amparo where poliza = "+registro.poliza.toString();
    var consulta = await db.rawQuery( sentencia );
    if ( consulta.first["id"] > 0 ) {
      sentencia = "select max(orden)+1 as id from amparo where poliza = "+registro.poliza.toString();
      var consulta = await db.rawQuery( sentencia );

      id = consulta.first["id"];
    }

    print ('Pasa'+ id.toString() ) ;

    print('Última amparo: '+registro.poliza.toString()+'-'+id.toString());

    registro.orden = id;

    var crud = await db.rawInsert (
      "insert into amparo ( orden, poliza, concepto, dias, fechaInicial, fechaFinal, " +
      "porcentaje, valorAsegurado, tasaAmparo, prima ) "
      "values( ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )",
      [
        registro.orden,
        registro.poliza,
        registro.concepto,

        registro.dias,
        registro.fechaInicial,
        registro.fechaFinal,

        registro.porcentaje,
        registro.valorAsegurado,
        registro.tasaAmparo,
        registro.prima
      ]
    );   // newAmparo.sincronizar

//    consulta = await db.rawQuery("select max(amparo) as id from amparo");
//    id = consulta.first["id"];
//    print('Última amparo: '+id.toString());

    nuevoAmparo(registro.poliza.toString(), "10090", "I", '1', '' );

    return crud;
  }

  updateAmparo(Amparo registro) async {
    final db = await database;

    Amparo sincronizar = Amparo (
        concepto: registro.concepto,
        dias: registro.dias,
        fechaInicial: registro.fechaInicial,
        fechaFinal: registro.fechaFinal,

        porcentaje: registro.porcentaje,
        valorAsegurado: registro.valorAsegurado,
        tasaAmparo: registro.tasaAmparo,
        prima: registro.prima
    );

    var crud = await db.update("amparo", sincronizar.toMap(),
        where: "amparo = ?", whereArgs: [registro.amparo]);

    nuevoAmparo( registro.poliza.toString(), "10090", "I", '1', '' );

    return crud;
  }
/*
  blockOrUnblock(Amparo registro) async {

    final db = await database;

    String sentencia="0";
    if (registro.sincronizar > 0)
      sentencia="1";

    sentencia="update amparo set sincronizar = "+sentencia+
        " where amparo = "+registro.amparo.toString();
    print(sentencia);

    var crud = await db.execute(sentencia);
    return crud;
  }
*/
  deleteAmparo( int id, int poliza ) async {

    final db = await database;
    db.delete("amparo", where: "amparo = ?", whereArgs: [id]);

    nuevoAmparo( poliza.toString(), "10090", "I", '1', '' );
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from amparo");
  }

  getAmparo( int id ) async {
    final db = await database;
    var consulta = await db.query("v_amparo", where: "amparo = ? ", whereArgs: [id]);
    return consulta.isNotEmpty ? Amparo.fromMap(consulta.first) : null;
  }

  Future<List<Amparo>> getAllAmparo( int poliza ) async {
    final db = await database;
//    var consulta = await db.query("v_amparo order by poliza,orden ");
    var consulta = await db.query("v_amparo", where: "poliza = ? ", whereArgs: [poliza], orderBy: "poliza,orden");

    List<Amparo> list =
    consulta.isNotEmpty ? consulta.map((c) => Amparo.fromMap(c)).toList() : [];
    return list;
  }

}

class AmparoBloc {

  AmparoBloc( int poliza ) {
    getAmparo( poliza );
  }

  final _amparoController = StreamController<List<Amparo>>.broadcast();
  get amparos => _amparoController.stream;

  add( Amparo client ) {
    DBAmparo.db.newAmparo( client );
    getAmparo( client.poliza );
  }

  update( Amparo client ) {
    DBAmparo.db.updateAmparo(client);
    getAmparo( client.poliza );
  }

  delete( int id, int poliza ) {
    DBAmparo.db.deleteAmparo( id, poliza );
    getAmparo( poliza );
  }

  dispose() {
    _amparoController.close();
  }

  getAmparo( int poliza ) async {
    _amparoController.sink.add(await DBAmparo.db.getAllAmparo( poliza ));
  }

  blockUnblock( Amparo client ) {
//    DBAmparo.db.blockOrUnblock(client);
    getAmparo( client.poliza );
  }

}

void nuevoAmparo( String id, String clase, String crud, String auxiliar, String comodin) async {
  await DBLiquidador.nuevoAmparos( id, clase, crud, auxiliar, comodin );
}

