
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/auxiliarModelo/AuxiliarModel.dart';

int resultado;

class DBProvider {

  DBProvider._();
  static DBProvider db = DBProvider._();      // constructor
  static Database _database;                  // database object

  Future<Database> get database async {       // crear the database' object
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

//  factory DBProvider() => db;
  factory DBProvider() {                                       // fixCombo (16 feb 2019): new factory para el combo, diferente forma de relacionar el db
    if(db == null) {
      db = DBProvider._();
    }
    return db;
  }

  Future<List<Map<String, dynamic>>> getGeneroMapList() async {// fixCombo (16 feb 2019): gets all generos from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 211 order by registro');
    return result;
  }

  Future<List<Genero>> getGeneroList() async {                 // fixCombo (16 feb 2019): gets all generos from database => memory (generoList)
    var generoMapList = await getGeneroMapList();
    int count = generoMapList.length;
    List<Genero> generoList = List<Genero>();
    for(int i = 0; i < count; i++) {
      generoList.add(Genero.fromMapObject(generoMapList[i]));
    }
    return generoList;
  }

  Future<List<Map<String, dynamic>>> getEstadoCivilMapList() async {// fixCombo (16 feb 2019): gets all estadoCiviles from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 1005 order by registro');
    return result;
  }

  Future<List<EstadoCivil>> getEstadoCivilList() async {                 // fixCombo (16 feb 2019): gets all estadoCiviles from database => memory (estadoCivilList)
    var estadoCivilMapList = await getEstadoCivilMapList();
    int count = estadoCivilMapList.length;
    List<EstadoCivil> estadoCivilList = List<EstadoCivil>();
    for(int i = 0; i < count; i++) {
      estadoCivilList.add(EstadoCivil.fromMapObject(estadoCivilMapList[i]));
    }
    return estadoCivilList;
  }

  Future<List<Map<String, dynamic>>> getTipoMapList() async {// fixCombo (16 feb 2019): gets all tipos from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 1002 order by registro');
    return result;
  }

  Future<List<Tipo>> getTipoList() async {                 // fixCombo (16 feb 2019): gets all tipos from database => memory (tipoList)
    var tipoMapList = await getTipoMapList();
    int count = tipoMapList.length;
    List<Tipo> tipoList = List<Tipo>();
    for(int i = 0; i < count; i++) {
      tipoList.add(Tipo.fromMapObject(tipoMapList[i]));
    }
    return tipoList;
  }

  Future<List<Map<String, dynamic>>> getClasificacionMapList() async {// fixCombo (16 feb 2019): gets all clasificaciones from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 1004 order by registro');
    return result;
  }

  Future<List<Clasificacion>> getClasificacionList() async {                 // fixCombo (16 feb 2019): gets all clasificaciones from database => memory (clasificacionList)
    var clasificacionMapList = await getClasificacionMapList();
    int count = clasificacionMapList.length;
    List<Clasificacion> clasificacionList = List<Clasificacion>();
    for(int i = 0; i < count; i++) {
      clasificacionList.add(Clasificacion.fromMapObject(clasificacionMapList[i]));
    }
    return clasificacionList;
  }

  Future<List<Map<String, dynamic>>> getLugarMapList() async {// fixCombo (16 feb 2019): gets all lugares from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 218 order by registro');
    return result;
  }

  Future<List<Lugar>> getLugarList() async {                 // fixCombo (16 feb 2019): gets all lugares from database => memory (lugarList)
    var lugarMapList = await getLugarMapList();
    int count = lugarMapList.length;
    List<Lugar> lugarList = List<Lugar>();
    for(int i = 0; i < count; i++) {
      lugarList.add(Lugar.fromMapObject(lugarMapList[i]));
    }
    return lugarList;
  }

  Future<List<Map<String, dynamic>>> getMunicipioMapList() async {// fixCombo (16 feb 2019): gets all municipios from database
    Database db = await this.database;
    var result = await db.rawQuery('select registro, descripcion from g_registro where tabla = 218 order by registro');
    return result;
  }

  Future<List<Municipio>> getMunicipioList() async {                 // fixCombo (16 feb 2019): gets all municipios from database => memory (municipioList)
    var municipioMapList = await getMunicipioMapList();
    int count = municipioMapList.length;
    List<Municipio> municipioList = List<Municipio>();
    for(int i = 0; i < count; i++) {
      municipioList.add(Municipio.fromMapObject(municipioMapList[i]));
    }
    return municipioList;
  }


  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
       onCreate: (Database db, int version) async {

          print('Creación base datos...');

          await db.execute(
            "create table g_registro ("
            "registro integer  primary key autoincrement,"
            "tabla integer not null,"
            "descripcion text not null,"
            "parametro0 text default null,"
            "parametro1 text default null,"
            "parametro2 text default null,"
            "parametro3 text default null,"
            "parametro4 text default null )"
          );

          await db.execute(
            "create table g_auxiliar ("
            "auxiliar integer primary key autoincrement,"
            "clasificacion integer not null,"
            "tipo integer not null,"
            "identificacion integer not null,"

            "fecha text not null,"
            "password text not null,"
            "token text not null,"

            "primerNombre text not null,"
            "segundoNombre text default null,"
            "primerApellido text default null,"
            "segundoApellido text default null,"
            "favorito text not null,"

            "foto text default null,"
            "nacimiento text default null,"
            "lugar integer not null,"
            "genero integer default null,"
            "estadoCivil integer default null,"

            "direccion text not null,"
            "municipio integer not null,"
            "movil text not null,"
            "fijo text not null,"
            "correo text not null,"
            "documento text not null,"
            "sincronizar integer not null,"

            "foreign key (clasificacion)references g_registro(registro) on delete cascade on update no action,"
            "foreign key (tipo)         references g_registro(registro) on delete cascade on update no action,"
            "foreign key (genero)       references g_registro(registro) on delete cascade on update no action,"
            "foreign key (estadoCivil)  references g_registro(registro) on delete cascade on update no action,"
            "foreign key (lugar)        references g_registro(registro) on delete cascade on update no action,"
            "foreign key (municipio)    references g_registro(registro) on delete cascade on update no action)"
          );

          await db.execute(
            "create table poliza ("
            "poliza integer primary key autoincrement,"
            "sede integer not null,"
            "fechaEmision text not null,"
            "periodo integer not null,"
            "numero integer not null,"
            "temporario integer not null,"
            "estado integer not null,"

            "intermediario integer not null," //new
            "comision real not null,"
            "cupoOperativo integer not null,"

            "afianzado integer not null,"     // change tomador_principal
            "tipoPoliza integer not null,"    // change tipo_poliza
            "clausulado text  not null,"      // new

            "periodoEmision integer not null,"
            "retroactividad integer not null,"
            "fechaHoraInicial text  not null,"// change fecha_hora_inicial
            "fechaHoraFinal text  not null,"  // change fecha_hora_final

            "contratante integer not null,"   //new
            "objeto integer not null,"
            "numeroContrato text not null,"
            "valorContrato real not null,"    // change valor_contrato
            "fechaInicial text not null,"     // change fecha_inicial
            "fechaFinal text not null,"       // change fecha_final
            "sincronizar integer not null,"

            "foreign key (intermediario)  references g_auxiliar(auxiliar) on delete cascade on update no action,"
            "foreign key (afianzado)      references g_auxiliar(auxiliar) on delete cascade on update no action,"
            "foreign key (contratante)    references g_auxiliar(auxiliar) on delete cascade on update no action,"
            "foreign key (sede)           references g_auxiliar(registro) on delete cascade on update no action,"
            "foreign key (estado)         references g_registro(registro) on delete cascade on update no action,"
            "foreign key (objeto)         references clase(clase)         on delete cascade on update no action,"
            "foreign key (tipoPoliza)     references g_registro(registro) on delete cascade on update no action )"

          );

          await db.execute(
            "create table concepto ( "
            "concepto integer not null,"
            "descripcion text not null,"
            "grupo integer not null,"
            "parametro integer not null,"
            "unidad integer not null,"
            "redondeo integer not null,"

            "foreign key (grupo)     references g_registro(registro) on delete cascade on update no action,"
            "foreign key (parametro) references g_registro(registro) on delete cascade on update no action,"
            "foreign key (unidad)    references g_registro(registro) on delete cascade on update no action )"
          );

          await db.execute(
            "create unique index iconcepto on concepto ( concepto )"
          );

          await db.execute(
            "create table clase ( "
            "clase integer not null,"
            "descripcion text not null,"
            "sinonimo integer not null,"
            "observacion integer not null,"
            "tipo integer not null,"
            "documento integer not null,"

            "foreign key (tipo)    references g_registro(registro) on delete cascade on update no action )"
          );

          await db.execute(
            "create unique index iclase on clase ( clase )"
          );

          await db.execute(
            "create table formula ("
            "clase integer not null,"
            "orden integer not null,"
            "concepto integer not null,"
            "debito text not null,"
            "credito text not null,"
            "contador text not null,"
            "cantidad integer not null,"
            "sentencia text not null,"
            "indicador integer not null,"

            "foreign key (concepto) references concepto(concepto) on delete cascade on update no action,"
            "foreign key (clase)    references clase(clase) on delete cascade on update no action,"
            "foreign key (indicador)references g_registro(registro) on delete cascade on update no action )"
          );

          await db.execute(
            "create unique index iformula on formula ( clase, orden )"
          );

          await db.execute(
            "create table valor ("
            "clase integer not null,"
            "orden integer not null,"
            "concepto integer not null,"
            "minimo integer not null,"
            "maximo integer not null,"
            "valor real not null,"

            "foreign key (concepto) references concepto(concepto) on delete cascade on update no action,"
            "foreign key (clase)    references clase( clase ) on delete cascade on update no action )"
          );

          await db.execute(
            "create unique index ivalor on valor ( clase, orden )"
          );

          await db.execute(
            "create table amparo ("
            "amparo integer primary key autoincrement,"
            "orden integer not null,"
            "poliza integer not null,"
            "concepto integer not null,"
            "dias integer not null,"
            "fechaInicial text not null,"
            "fechaFinal text not null,"

            "porcentaje real not null,"
            "valorAsegurado real not null,"

            "tasaAmparo real not null,"
            "prima real not null,"

            "foreign key (poliza) references poliza(poliza) on delete cascade on update no action,"
            "foreign key (concepto) references concepto(concepto) on delete cascade on update no action )"
          );

          await db.execute(
            "create table g_accion ("

            "accion      integer primary key autoincrement,"
            "fecha       text not null,"
            "agenda      integer not null,"
            "categoria   integer not null,"
            "usuario     text not null,"
            "sincronizar integer not null,"

            "interno     integer not null,"
            "descripcion text not null,"
            "titulo      text not null,"
            "subtitulo   text not null,"

            "detalle     text not null,"
            "seguimiento integer not null,"
            "procedencia integer not null,"
            "posicion    text not null,"

            "foreign key (agenda)      references g_registro(registro) on delete cascade on update no action,"
            "foreign key (categoria)   references g_registro(registro) on delete cascade on update no action,"
            "foreign key (seguimiento) references g_registro(registro) on delete cascade on update no action ) "
          );


          await db.execute (
              "create table intermedario ("
                  "intermedario         integer primary key autoincrement,"
                  "asesor               integer not null,"
                  "agencia              integer not null,"
                  "puntoVenta           integer not null,"
                  "clave                text not null,"
                  "comisionCumplimiento real not null,"
                  "delegacion           real not null,"

                  "foreign key (intermedario)references g_auxiliar(auxiliar) on delete cascade on update no action,"
                  "foreign key (agencia)     references g_registro(auxiliar) on delete cascade on update no action,"
                  "foreign key (puntoVenta)  references g_registro(auxiliar) on delete cascade on update no action )"
          );

          await db.execute(
            "create table participacion ("
            "participacion integer primary key autoincrement,"
            "poliza integer not null,"
            "intermediario integer not null,"
            "porcentaje real not null,"

            "foreign key (poliza)      references poliza(poliza) on delete cascade on update no action,"
            "foreign key (intermediario)references g_auxiliar(auxiliar) on delete cascade on update no action )"
          );



          await db.execute(
              "create table afianzado ("
                  "afianzado     integer primary key autoincrement,"
                  "tomador       integer not null,"
                  "cupoOperativo real not null,"
                  "cumuloActual  real not null,"

                  "foreign key (tomador) references g_auxiliar(auxiliar) on delete cascade on update no action )"
          );

//TODO eliminar esta tabla ya que el tomador es el mismo afianzado, falta el contratante
         //TODO Crear tabla contratante???

          await db.execute(
              "create table tomador ("
                  "tomador    integer primary key autoincrement,"
                  "poliza     integer not null,"
                  "afianzado  integer not null,"
                  "porcentaje real not null,"
                  "principal  int not null,"

                  "foreign key (poliza)    references poliza(poliza) on delete cascade on update no action,"
                  "foreign key (afianzado) references g_auxiliar(auxiliar) on delete cascade on update no action )"
          );


          await db.execute(
            "create table operacion ("
            "operacion integer primary key autoincrement,"
            "poliza integer not null,"
            "aseguradora integer not null,"
            "tipo int not null,"
            "participacion real not null,"

            "foreign key (poliza)      references poliza(poliza) on delete cascade on update no action,"
            "foreign key (aseguradora) references g_auxiliar(auxiliar) on delete cascade on update no action,"
            "foreign key (tipo)   references g_registro(registro) on delete cascade on update no action )"
          );


          await db.execute(
            "create table anexo ("
            "anexo integer primary key autoincrement,"
            "interno integer not null,"
            "categoria int not null,"
            "documento text not null,"

            "foreign key (interno) references poliza(poliza) on delete cascade on update no action,"
            "foreign key (categoria) references g_registro(registro) on delete cascade on update no action )"
          );


          await db.execute(
            "create table endoso ("
            "endoso integer primary key autoincrement,"
            "numero int not null,"
            "poliza integer not null,"
            "tipo int not null,"
            "fechaHora text not null,"
            "variable text not null,"
            "cambio text not null,"

            "foreign key (poliza) references poliza(poliza) on delete cascade on update no action,"
            "foreign key (tipo)   references g_registro(registro) on delete cascade on update no action )"
          );

          print('Creación tablas...');

          await db.execute(
            "insert into g_registro (registro, tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(-2, 1000, -2, 'n/a', '', '',           'X'),"   // -1 NO/APLICA
            "(-1, 1000, -1, 'Eliminado', '', '',     'X'),"   // -1 auxiliar.sincronizar   y  g_perfil.estado
            "(0,  1000, 0,  'Desactivado', '', '',   'R'),"   // 0
            "(1,  1000, 1,  'Activo', '', '',        'R'),"   // 1

            "(2,  1001, 10, 'Proceso', '', '',''),"           // 2
            "(3,  1001, 11, 'Seguimiento', '', '', '') "      // 3
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(120, 0,  '', '', '', ''),"                      // 4  concepto.parametros
            "(120, 70, 'Fecha inicial', '', '', ''),"         // 5
            "(120, 71, 'Fecha final', '', '', ''),"           // 6
            "(120, 72, 'Días', '', '', ''),"                  // 7

            "(120, 73, 'Precio'        , '', '', ''),"        // 8  movimiento.parametro
            "(120, 74, 'Descuento', '', '', ''),"             // 9

            "(120, 75, 'Valor unitario', '', '', ''),"        // 10  movimiento.parametro
            "(120, 76, 'Cantidad', '', '', ''),"              // 11
            "(120, 77, 'Total', '', '', ''),"                 // 12

            "(120, 78, 'Valor contable', '', '', ''),"        // 13  amparo.parametro
            "(120, 79, 'Tasa', '', '', ''),"                  // 14
            "(120, 80, 'Base', '', '', ''),"                  // 15
            "(120, 81, 'tarifa', '', '', ''),"                // 16

            "(301, 30100, '', '', '', ''),"                   // 17  concepto.grupo
            "(301, 30101, 'Cumplimiento', '', '', ''),"       // 18

            "(302, 30200, '', '', '', ''),"                   // 19  concepto.unidad
            "(302, 30201, 'Día', '', '', ''),"                // 20
            "(302, 30202, 'Mes', '', '', ''),"                // 21
            "(302, 30203, 'Año', '', '', ''),"                // 22
            "(302, 30204, 'Fecha', '', '', ''),"              // 23
            "(302, 30205, 'Hora', '', '', ''),"               // 24
            "(302, 30206, 'Minuto', '', '', ''),"             // 25
            "(302, 30207, 'Cantidad', '', '', ''),"           // 26
            "(302, 30208, 'Valor', '', '', ''),"              // 27
            "(302, 30209, 'Concepto', '', '', ''),"           // 28
            "(302, 30210, 'Porcentaje', '', '', ''),"         // 29
            "(302, 30211, 'Pesos', '', '', ''),"              // 30
            "(302, 30212, 'Otra',  '',  '', ''),"             // 31

            "(120, 82, 'Valor', '', '', ''),"                 // 32  concepto.parametros
            "(120, 83, ' ', '', '', ''),"                     // 33

            "(107, 10703, 'Cargar',    '', '', ''),"          // 34  formula.indicador
            "(107, 10704, 'Calcular',  '', '', ''),"          // 35
            "(107, 10705, 'Liquidar',  '', '', ''),"          // 36
            "(107, 10706, 'Ejecutar SQL','','',''),"          // 37
            "(107, 10708, 'Acumular',  '', '', ''),"          // 38
            "(107, 10710, 'Inactivo',  '', '', '') "          // 39
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"

            "(1001, '', 'Nueva', '' ,'' ,''),"                // 40  poliza.estado
            "(1001, '', 'Tramite', '' ,'' ,''),"              // 41
            "(1001, '', 'Aprobada', '' ,'' ,''),"             // 42
            "(1001, '', 'Expedida', '' ,'' ,''),"             // 43
            "(1001, '', 'Anulada', '' ,'' ,''),"              // 44

            "(121, '', 'Liquidación', '' ,'' ,''),"           // 45  clase.tipo
            "(121, '', 'Póliza', '' ,'' ,''),"                // 46
            "(121, '', ' ', '' ,'' ,''),"                     // 47

            "(211, 1, 'Masculino', ' ', ' ', '0'),"           // 48 g_auxiliar.genero
            "(211, 1, 'Femenino', ' ', ' ',  '0'),"           // 48

            "(1002, '1', 'Cédula de ciudadanía', '' ,''  ,''),"  //  g_auxiliar.tipo
            "(1002, '1', 'Nit Persona natural', '' ,''   ,''),"
            "(1002, '1', 'Cédula de extranjería', '' ,'' ,''),"
            "(1002, '2', 'Nit', '' ,''                   ,''),"

            "(1004, '1', 'Persona natural', '' ,''        ,''),"  //  g_auxiliar.clasificacion
            "(1004, '2', 'Persona jurídica', '' ,''       ,''),"
            "(1004, '2', 'Consorcio', '' ,''             ,''),"
            "(1004, '2', 'Unión Temporal', '' ,''        ,''),"
            "(1004, '2', 'Cooperativa', '' ,''           ,''),"
            "(1004, '2', 'PreCooperativa', '' ,''        ,''),"
            "(1004, '2', 'Asociación', '' ,''            ,''),"

            "(1005, '1', 'Soltero', '' ,''               ,''),"//  g_auxiliar.estadoCivil
            "(1005, '1', 'Casado', '' ,''                ,''),"

            "(1008, '', 'Expedición', '' ,''            ,''),"//  endoso.tipoMovimiento
            "(1008, '', 'Modificacion', '' ,''          ,''),"
            "(1008, '', 'Modificacion sin cobro de prima', '' ,'' ,''),"
            "(1008, '', 'Acta de inicio', '' ,''        ,''),"
            "(1008, '', 'Prorroga', '' ,''              ,''),"
            "(1008, '', 'Renovacion', '' ,''            ,''),"
            "(1008, '', 'Anulacion de anexo', '' ,''    ,''),"
            "(1008, '', 'Revocación', '' ,''            ,''),"

            "(1010, '', 'Particular', '' ,'',           ''),"//  poliza.tipoPoliza
            "(1010, '', 'Estatal',    '' ,''           ,''),"
            "(1010, '', 'Servicios Públicos Domiciliarios','','',''),"
            "(1010, '', 'Póliza Ecopetrol', '' ,''     ,''),"
            "(1010, '', 'Empresas públicas con régimen privado de contratación', '' ,'',''),"

            "(1012, '', '100% Compañía','',''             ,''),"//  operacion.tipoOperacion
            "(1012, '', 'Coaseguro Aceptado',    '' ,''   ,''),"
            "(1012, '', 'Coaseguro Cedido','',''          ,''),"
            "(1012, '', 'AFR','',''                       ,''),"

            "(221, '', 'Contrato', '', '', '' ),"               // anexo.categorìa
            "(221, '', 'Excel'   , '', '', '' ),"
            "(221, '', 'Nit'     , '', '', '' ),"
            "(221, '', 'Pdf'     , '', '', '' ),"
            "(221, '', 'Otro'    , '', '', '' ) "
          );

          await db.execute(
            "insert into g_registro (registro, tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(1000, 218, 5001, 'MEDELLIN', ' ', ' ', '0') "     // 1000
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 5002, 'ABEJORRAL', ' ', ' ', '0'),"          // 1001
            "(218, 5004, 'ABRIAQUI', ' ', ' ', '0'),"
            "(218, 5021, 'ALEJANDRIA', ' ', ' ', '0'),"
            "(218, 5030, 'AMAGA', ' ', ' ', '0'),"
            "(218, 5031, 'AMALFI', ' ', ' ', '0'),"
            "(218, 5034, 'ANDES', ' ', ' ', '0'),"
            "(218, 5036, 'ANGELOPOLIS', ' ', ' ', '0'),"
            "(218, 5038, 'ANGOSTURA', ' ', ' ', '0'),"
            "(218, 5040, 'ANORI', ' ', ' ', '0'),"
            "(218, 5042, 'SANTAFE DE ANTIOQUIA', ' ', ' ', '0'),"
            "(218, 5044, 'ANZA', ' ', ' ', '0'),"
            "(218, 5045, 'APARTADO', ' ', ' ', '0'),"
            "(218, 5051, 'ARBOLETES', ' ', ' ', '0'),"
            "(218, 5055, 'ARGELIA', ' ', ' ', '0'),"
            "(218, 5059, 'ARMENIA', ' ', ' ', '0'),"
            "(218, 5079, 'BARBOSA', ' ', ' ', '0'),"
            "(218, 5086, 'BELMIRA', ' ', ' ', '0'),"
            "(218, 5088, 'BELLO', ' ', ' ', '0'),"
            "(218, 5091, 'BETANIA', ' ', ' ', '0'),"
            "(218, 5093, 'BETULIA', ' ', ' ', '0'),"
            "(218, 5101, 'CIUDAD BOLIVAR', ' ', ' ', '0'),"
            "(218, 5107, 'BRICEÑO', ' ', ' ', '0'),"
            "(218, 5113, 'BURITICA', ' ', ' ', '0'),"
            "(218, 5120, 'CACERES', ' ', ' ', '0'),"
            "(218, 5125, 'CAICEDO', ' ', ' ', '0'),"
            "(218, 5129, 'CALDAS', ' ', ' ', '0'),"
            "(218, 5134, 'CAMPAMENTO', ' ', ' ', '0'),"
            "(218, 5138, 'CAÑASGORDAS', ' ', ' ', '0'),"
            "(218, 5142, 'CARACOLI', ' ', ' ', '0'),"
            "(218, 5145, 'CARAMANTA', ' ', ' ', '0'),"
            "(218, 5147, 'CAREPA', ' ', ' ', '0'),"
            "(218, 5148, 'EL CARMEN DE VIBORAL', ' ', ' ', '0'),"
            "(218, 5150, 'CAROLINA', ' ', ' ', '0'),"
            "(218, 5154, 'CAUCASIA', ' ', ' ', '0'),"
            "(218, 5172, 'CHIGORODO', ' ', ' ', '0'),"
            "(218, 5190, 'CISNEROS', ' ', ' ', '0'),"
            "(218, 5197, 'COCORNA', ' ', ' ', '0'),"
            "(218, 5206, 'CONCEPCION', ' ', ' ', '0'),"
            "(218, 5209, 'CONCORDIA', ' ', ' ', '0'),"
            "(218, 5212, 'COPACABANA', ' ', ' ', '0'),"
            "(218, 5234, 'DABEIBA', ' ', ' ', '0'),"
            "(218, 5237, 'DON MATIAS', ' ', ' ', '0'),"
            "(218, 5240, 'EBEJICO', ' ', ' ', '0'),"
            "(218, 5250, 'EL BAGRE', ' ', ' ', '0'),"
            "(218, 5264, 'ENTRERRIOS', ' ', ' ', '0'),"
            "(218, 5266, 'ENVIGADO', ' ', ' ', '0'),"
            "(218, 5282, 'FREDONIA', ' ', ' ', '0'),"
            "(218, 5284, 'FRONTINO', ' ', ' ', '0'),"
            "(218, 5306, 'GIRALDO', ' ', ' ', '0'),"
            "(218, 5308, 'GIRARDOTA', ' ', ' ', '0'),"
            "(218, 5310, 'GOMEZ PLATA', ' ', ' ', '0'),"
            "(218, 5313, 'GRANADA', ' ', ' ', '0'),"
            "(218, 5315, 'GUADALUPE', ' ', ' ', '0'),"
            "(218, 5318, 'GUARNE', ' ', ' ', '0'),"
            "(218, 5321, 'GUATAPE', ' ', ' ', '0'),"
            "(218, 5347, 'HELICONIA', ' ', ' ', '0'),"
            "(218, 5353, 'HISPANIA', ' ', ' ', '0'),"
            "(218, 5360, 'ITAGUI', ' ', ' ', '0'),"
            "(218, 5361, 'ITUANGO', ' ', ' ', '0'),"
            "(218, 5364, 'JARDIN', ' ', ' ', '0'),"
            "(218, 5368, 'JERICO', ' ', ' ', '0'),"
            "(218, 5376, 'LA CEJA', ' ', ' ', '0'),"
            "(218, 5380, 'LA ESTRELLA', ' ', ' ', '0'),"
            "(218, 5390, 'LA PINTADA', ' ', ' ', '0'),"
            "(218, 5400, 'LA UNION', ' ', ' ', '0'),"
            "(218, 5411, 'LIBORINA', ' ', ' ', '0'),"
            "(218, 5425, 'MACEO', ' ', ' ', '0'),"
            "(218, 5440, 'MARINILLA', ' ', ' ', '0'),"
            "(218, 5467, 'MONTEBELLO', ' ', ' ', '0'),"
            "(218, 5475, 'MURINDO', ' ', ' ', '0'),"
            "(218, 5480, 'MUTATA', ' ', ' ', '0'),"
            "(218, 5483, 'NARIÑO', ' ', ' ', '0'),"
            "(218, 5490, 'NECOCLI', ' ', ' ', '0'),"
            "(218, 5495, 'NECHI', ' ', ' ', '0'),"
            "(218, 5501, 'OLAYA', ' ', ' ', '0'),"
            "(218, 5541, 'PEDOL', ' ', ' ', '0'),"
            "(218, 5543, 'PEQUE', ' ', ' ', '0'),"
            "(218, 5576, 'PUEBLORRICO', ' ', ' ', '0'),"
            "(218, 5579, 'PUERTO BERRIO', ' ', ' ', '0'),"
            "(218, 5585, 'PUERTO NARE', ' ', ' ', '0'),"
            "(218, 5591, 'PUERTO TRIUNFO', ' ', ' ', '0'),"
            "(218, 5604, 'REMEDIOS', ' ', ' ', '0'),"
            "(218, 5607, 'RETIRO', ' ', ' ', '0'),"
            "(218, 5615, 'RIONEGRO', ' ', ' ', '0'),"
            "(218, 5628, 'SABANALARGA', ' ', ' ', '0'),"
            "(218, 5631, 'SABANETA', ' ', ' ', '0'),"
            "(218, 5642, 'SALGAR', ' ', ' ', '0'),"
            "(218, 5647, 'SAN ANDRES DE CUERQUIA', ' ', ' ', '0'),"
            "(218, 5649, 'SAN CARLOS', ' ', ' ', '0'),"
            "(218, 5652, 'SAN FRANCISCO', ' ', ' ', '0'),"
            "(218, 5656, 'SAN JERONIMO', ' ', ' ', '0'),"
            "(218, 5658, 'SAN JOSE DE LA MONTAÑA', ' ', ' ', '0'),"
            "(218, 5659, 'SAN JUAN DE URABA', ' ', ' ', '0'),"
            "(218, 5660, 'SAN LUIS', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 5664, 'SAN PEDRO', ' ', ' ', '0'),"
            "(218, 5665, 'SAN PEDRO DE URABA', ' ', ' ', '0'),"
            "(218, 5667, 'SAN RAFAEL', ' ', ' ', '0'),"
            "(218, 5670, 'SAN ROQUE', ' ', ' ', '0'),"
            "(218, 5674, 'SAN VICENTE', ' ', ' ', '0'),"
            "(218, 5679, 'SANTA BARBARA', ' ', ' ', '0'),"
            "(218, 5686, 'SANTA ROSA DE OSOS', ' ', ' ', '0'),"
            "(218, 5690, 'SANTO DOMINGO', ' ', ' ', '0'),"
            "(218, 5697, 'EL SANTUARIO', ' ', ' ', '0'),"
            "(218, 5736, 'SEGOVIA', ' ', ' ', '0'),"
            "(218, 5756, 'SONSON', ' ', ' ', '0'),"
            "(218, 5761, 'SOPETRAN', ' ', ' ', '0'),"
            "(218, 5789, 'TAMESIS', ' ', ' ', '0'),"
            "(218, 5790, 'TARAZA', ' ', ' ', '0'),"
            "(218, 5792, 'TARSO', ' ', ' ', '0'),"
            "(218, 5809, 'TITIRIBI', ' ', ' ', '0'),"
            "(218, 5819, 'TOLEDO', ' ', ' ', '0'),"
            "(218, 5837, 'TURBO', ' ', ' ', '0'),"
            "(218, 5842, 'URAMITA', ' ', ' ', '0'),"
            "(218, 5847, 'URRAO', ' ', ' ', '0'),"
            "(218, 5854, 'VALDIVIA', ' ', ' ', '0'),"
            "(218, 5856, 'VALPARAISO', ' ', ' ', '0'),"
            "(218, 5858, 'VEGACHI', ' ', ' ', '0'),"
            "(218, 5861, 'VENECIA', ' ', ' ', '0'),"
            "(218, 5873, 'VIGIA DEL FUERTE', ' ', ' ', '0'),"
            "(218, 5885, 'YALI', ' ', ' ', '0'),"
            "(218, 5887, 'YARUMAL', ' ', ' ', '0'),"
            "(218, 5890, 'YOLOMBO', ' ', ' ', '0'),"
            "(218, 5893, 'YONDO', ' ', ' ', '0'),"
            "(218, 5895, 'ZARAGOZA', ' ', ' ', '0'),"
            "(218, 8001, 'BARRANQUILLA', ' ', ' ', '0'),"
            "(218, 8078, 'BARANOA', ' ', ' ', '0'),"
            "(218, 8137, 'CAMPO DE LA CRUZ', ' ', ' ', '0'),"
            "(218, 8141, 'CANDELARIA', ' ', ' ', '0'),"
            "(218, 8296, 'GALAPA', ' ', ' ', '0'),"
            "(218, 8372, 'JUAN DE ACOSTA', ' ', ' ', '0'),"
            "(218, 8421, 'LURUACO', ' ', ' ', '0'),"
            "(218, 8433, 'MALAMBO', ' ', ' ', '0'),"
            "(218, 8436, 'MANATI', ' ', ' ', '0'),"
            "(218, 8520, 'PALMAR DE VARELA', ' ', ' ', '0'),"
            "(218, 8549, 'PIOJO', ' ', ' ', '0'),"
            "(218, 8558, 'POLONUEVO', ' ', ' ', '0'),"
            "(218, 8560, 'PONEDERA', ' ', ' ', '0'),"
            "(218, 8573, 'PUERTO COLOMBIA', ' ', ' ', '0'),"
            "(218, 8606, 'REPELON', ' ', ' ', '0'),"
            "(218, 8634, 'SABANAGRANDE', ' ', ' ', '0'),"
            "(218, 8638, 'SABANALARGA', ' ', ' ', '0'),"
            "(218, 8675, 'SANTA LUCIA', ' ', ' ', '0'),"
            "(218, 8685, 'SANTO TOMAS', ' ', ' ', '0'),"
            "(218, 8758, 'SOLEDAD', ' ', ' ', '0'),"
            "(218, 8770, 'SUAN', ' ', ' ', '0'),"
            "(218, 8832, 'TUBARA', ' ', ' ', '0'),"
            "(218, 8849, 'USIACURI', ' ', ' ', '0'),"
            "(218, 11001, 'BOGOTA, D.C.', ' ', ' ', '0'),"
            "(218, 13001, 'CARTAGENA', ' ', ' ', '0'),"
            "(218, 13006, 'ACHI', ' ', ' ', '0'),"
            "(218, 13030, 'ALTOS DEL ROSARIO', ' ', ' ', '0'),"
            "(218, 13042, 'ARENAL', ' ', ' ', '0'),"
            "(218, 13052, 'ARJONA', ' ', ' ', '0'),"
            "(218, 13062, 'ARROYOHONDO', ' ', ' ', '0'),"
            "(218, 13074, 'BARRANCO DE LOBA', ' ', ' ', '0'),"
            "(218, 13140, 'CALAMAR', ' ', ' ', '0'),"
            "(218, 13160, 'CANTAGALLO', ' ', ' ', '0'),"
            "(218, 13188, 'CICUCO', ' ', ' ', '0'),"
            "(218, 13212, 'CORDOBA', ' ', ' ', '0'),"
            "(218, 13222, 'CLEMENCIA', ' ', ' ', '0'),"
            "(218, 13244, 'EL CARMEN DE BOLIVAR', ' ', ' ', '0'),"
            "(218, 13248, 'EL GUAMO', ' ', ' ', '0'),"
            "(218, 13268, 'EL PEÑON', ' ', ' ', '0'),"
            "(218, 13300, 'HATILLO DE LOBA', ' ', ' ', '0'),"
            "(218, 13430, 'MAGANGUE', ' ', ' ', '0'),"
            "(218, 13433, 'MAHATES', ' ', ' ', '0'),"
            "(218, 13440, 'MARGARITA', ' ', ' ', '0'),"
            "(218, 13442, 'MARIA LA BAJA', ' ', ' ', '0'),"
            "(218, 13458, 'MONTECRISTO', ' ', ' ', '0'),"
            "(218, 13468, 'MOMPOS', ' ', ' ', '0'),"
            "(218, 13473, 'MORALES', ' ', ' ', '0'),"
            "(218, 13490, 'NOROSI', ' ', ' ', '0'),"
            "(218, 13549, 'PINILLOS', ' ', ' ', '0'),"
            "(218, 13580, 'REGIDOR', ' ', ' ', '0'),"
            "(218, 13600, 'RIO VIEJO', ' ', ' ', '0'),"
            "(218, 13620, 'SAN CRISTOBAL', ' ', ' ', '0'),"
            "(218, 13647, 'SAN ESTANISLAO', ' ', ' ', '0'),"
            "(218, 13650, 'SAN FERNANDO', ' ', ' ', '0'),"
            "(218, 13654, 'SAN JACINTO', ' ', ' ', '0'),"
            "(218, 13655, 'SAN JACINTO DEL CAUCA', ' ', ' ', '0'),"
            "(218, 13657, 'SAN JUAN NEPOMUCENO', ' ', ' ', '0'),"
            "(218, 13667, 'SAN MARTIN DE LOBA', ' ', ' ', '0'),"
            "(218, 13670, 'SAN PABLO', ' ', ' ', '0'),"
            "(218, 13673, 'SANTA CATALINA', ' ', ' ', '0'),"
            "(218, 13683, 'SANTA ROSA', ' ', ' ', '0'),"
            "(218, 13688, 'SANTA ROSA DEL SUR', ' ', ' ', '0'),"
            "(218, 13744, 'SIMITI', ' ', ' ', '0'),"
            "(218, 13760, 'SOPLAVIENTO', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 13780, 'TALAIGUA NUEVO', ' ', ' ', '0'),"
            "(218, 13810, 'TIQUISIO', ' ', ' ', '0'),"
            "(218, 13836, 'TURBACO', ' ', ' ', '0'),"
            "(218, 13838, 'TURBANA', ' ', ' ', '0'),"
            "(218, 13873, 'VILLANUEVA', ' ', ' ', '0'),"
            "(218, 13894, 'ZAMBRANO', ' ', ' ', '0'),"
            "(218, 15001, 'TUNJA', ' ', ' ', '0'),"
            "(218, 15022, 'ALMEIDA', ' ', ' ', '0'),"
            "(218, 15047, 'AQUITANIA', ' ', ' ', '0'),"
            "(218, 15051, 'ARCABUCO', ' ', ' ', '0'),"
            "(218, 15087, 'BELEN', ' ', ' ', '0'),"
            "(218, 15090, 'BERBEO', ' ', ' ', '0'),"
            "(218, 15092, 'BETEITIVA', ' ', ' ', '0'),"
            "(218, 15097, 'BOAVITA', ' ', ' ', '0'),"
            "(218, 15104, 'BOYACA', ' ', ' ', '0'),"
            "(218, 15106, 'BRICEÑO', ' ', ' ', '0'),"
            "(218, 15109, 'BUENAVISTA', ' ', ' ', '0'),"
            "(218, 15114, 'BUSBANZA', ' ', ' ', '0'),"
            "(218, 15131, 'CALDAS', ' ', ' ', '0'),"
            "(218, 15135, 'CAMPOHERMOSO', ' ', ' ', '0'),"
            "(218, 15162, 'CERINZA', ' ', ' ', '0'),"
            "(218, 15172, 'CHINAVITA', ' ', ' ', '0'),"
            "(218, 15176, 'CHIQUINQUIRA', ' ', ' ', '0'),"
            "(218, 15180, 'CHISCAS', ' ', ' ', '0'),"
            "(218, 15183, 'CHITA', ' ', ' ', '0'),"
            "(218, 15185, 'CHITARAQUE', ' ', ' ', '0'),"
            "(218, 15187, 'CHIVATA', ' ', ' ', '0'),"
            "(218, 15189, 'CIENEGA', ' ', ' ', '0'),"
            "(218, 15204, 'COMBITA', ' ', ' ', '0'),"
            "(218, 15212, 'COPER', ' ', ' ', '0'),"
            "(218, 15215, 'CORRALES', ' ', ' ', '0'),"
            "(218, 15218, 'COVARACHIA', ' ', ' ', '0'),"
            "(218, 15223, 'CUBARA', ' ', ' ', '0'),"
            "(218, 15224, 'CUCAITA', ' ', ' ', '0'),"
            "(218, 15226, 'CUITIVA', ' ', ' ', '0'),"
            "(218, 15232, 'CHIQUIZA', ' ', ' ', '0'),"
            "(218, 15236, 'CHIVOR', ' ', ' ', '0'),"
            "(218, 15238, 'DUITAMA', ' ', ' ', '0'),"
            "(218, 15244, 'EL COCUY', ' ', ' ', '0'),"
            "(218, 15248, 'EL ESPINO', ' ', ' ', '0'),"
            "(218, 15272, 'FIRAVITOBA', ' ', ' ', '0'),"
            "(218, 15276, 'FLORESTA', ' ', ' ', '0'),"
            "(218, 15293, 'GACHANTIVA', ' ', ' ', '0'),"
            "(218, 15296, 'GAMEZA', ' ', ' ', '0'),"
            "(218, 15299, 'GARAGOA', ' ', ' ', '0'),"
            "(218, 15317, 'GUACAMAYAS', ' ', ' ', '0'),"
            "(218, 15322, 'GUATEQUE', ' ', ' ', '0'),"
            "(218, 15325, 'GUAYATA', ' ', ' ', '0'),"
            "(218, 15332, 'GsICAN', ' ', ' ', '0'),"
            "(218, 15362, 'IZA', ' ', ' ', '0'),"
            "(218, 15367, 'JENESANO', ' ', ' ', '0'),"
            "(218, 15368, 'JERICO', ' ', ' ', '0'),"
            "(218, 15377, 'LABRANZAGRANDE', ' ', ' ', '0'),"
            "(218, 15380, 'LA CAPILLA', ' ', ' ', '0'),"
            "(218, 15401, 'LA VICTORIA', ' ', ' ', '0'),"
            "(218, 15403, 'LA UVITA', ' ', ' ', '0'),"
            "(218, 15407, 'VILLA DE LEYVA', ' ', ' ', '0'),"
            "(218, 15425, 'MACANAL', ' ', ' ', '0'),"
            "(218, 15442, 'MARIPI', ' ', ' ', '0'),"
            "(218, 15455, 'MIRAFLORES', ' ', ' ', '0'),"
            "(218, 15464, 'MONGUA', ' ', ' ', '0'),"
            "(218, 15466, 'MONGUI', ' ', ' ', '0'),"
            "(218, 15469, 'MONIQUIRA', ' ', ' ', '0'),"
            "(218, 15476, 'MOTAVITA', ' ', ' ', '0'),"
            "(218, 15480, 'MUZO', ' ', ' ', '0'),"
            "(218, 15491, 'NOBSA', ' ', ' ', '0'),"
            "(218, 15494, 'NUEVO COLON', ' ', ' ', '0'),"
            "(218, 15500, 'OICATA', ' ', ' ', '0'),"
            "(218, 15507, 'OTANCHE', ' ', ' ', '0'),"
            "(218, 15511, 'PACHAVITA', ' ', ' ', '0'),"
            "(218, 15514, 'PAEZ', ' ', ' ', '0'),"
            "(218, 15516, 'PAIPA', ' ', ' ', '0'),"
            "(218, 15518, 'PAJARITO', ' ', ' ', '0'),"
            "(218, 15522, 'PANQUEBA', ' ', ' ', '0'),"
            "(218, 15531, 'PAUNA', ' ', ' ', '0'),"
            "(218, 15533, 'PAYA', ' ', ' ', '0'),"
            "(218, 15537, 'PAZ DE RIO', ' ', ' ', '0'),"
            "(218, 15542, 'PESCA', ' ', ' ', '0'),"
            "(218, 15550, 'PISBA', ' ', ' ', '0'),"
            "(218, 15572, 'PUERTO BOYACA', ' ', ' ', '0'),"
            "(218, 15580, 'QUIPAMA', ' ', ' ', '0'),"
            "(218, 15599, 'RAMIRIQUI', ' ', ' ', '0'),"
            "(218, 15600, 'RAQUIRA', ' ', ' ', '0'),"
            "(218, 15621, 'RONDON', ' ', ' ', '0'),"
            "(218, 15632, 'SABOYA', ' ', ' ', '0'),"
            "(218, 15638, 'SACHICA', ' ', ' ', '0'),"
            "(218, 15646, 'SAMACA', ' ', ' ', '0'),"
            "(218, 15660, 'SAN EDUARDO', ' ', ' ', '0'),"
            "(218, 15664, 'SAN JOSE DE PARE', ' ', ' ', '0'),"
            "(218, 15667, 'SAN LUIS DE GACENO', ' ', ' ', '0'),"
            "(218, 15673, 'SAN MATEO', ' ', ' ', '0'),"
            "(218, 15676, 'SAN MIGUEL DE SEMA', ' ', ' ', '0'),"
            "(218, 15681, 'SAN PABLO DE BORBUR', ' ', ' ', '0'),"
            "(218, 15686, 'SANTANA', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 15690, 'SANTA MARIA', ' ', ' ', '0'),"
            "(218, 15693, 'SANTA ROSA DE VITERBO', ' ', ' ', '0'),"
            "(218, 15696, 'SANTA SOFIA', ' ', ' ', '0'),"
            "(218, 15720, 'SATIVANORTE', ' ', ' ', '0'),"
            "(218, 15723, 'SATIVASUR', ' ', ' ', '0'),"
            "(218, 15740, 'SIACHOQUE', ' ', ' ', '0'),"
            "(218, 15753, 'SOATA', ' ', ' ', '0'),"
            "(218, 15755, 'SOCOTA', ' ', ' ', '0'),"
            "(218, 15757, 'SOCHA', ' ', ' ', '0'),"
            "(218, 15759, 'SOGAMOSO', ' ', ' ', '0'),"
            "(218, 15761, 'SOMONDOCO', ' ', ' ', '0'),"
            "(218, 15762, 'SORA', ' ', ' ', '0'),"
            "(218, 15763, 'SOTAQUIRA', ' ', ' ', '0'),"
            "(218, 15764, 'SORACA', ' ', ' ', '0'),"
            "(218, 15774, 'SUSACON', ' ', ' ', '0'),"
            "(218, 15776, 'SUTAMARCHAN', ' ', ' ', '0'),"
            "(218, 15778, 'SUTATENZA', ' ', ' ', '0'),"
            "(218, 15790, 'TASCO', ' ', ' ', '0'),"
            "(218, 15798, 'TENZA', ' ', ' ', '0'),"
            "(218, 15804, 'TIBANA', ' ', ' ', '0'),"
            "(218, 15806, 'TIBASOSA', ' ', ' ', '0'),"
            "(218, 15808, 'TINJACA', ' ', ' ', '0'),"
            "(218, 15810, 'TIPACOQUE', ' ', ' ', '0'),"
            "(218, 15814, 'TOCA', ' ', ' ', '0'),"
            "(218, 15816, 'TOGsI', ' ', ' ', '0'),"
            "(218, 15820, 'TOPAGA', ' ', ' ', '0'),"
            "(218, 15822, 'TOTA', ' ', ' ', '0'),"
            "(218, 15832, 'TUNUNGUA', ' ', ' ', '0'),"
            "(218, 15835, 'TURMEQUE', ' ', ' ', '0'),"
            "(218, 15837, 'TUTA', ' ', ' ', '0'),"
            "(218, 15839, 'TUTAZA', ' ', ' ', '0'),"
            "(218, 15842, 'UMBITA', ' ', ' ', '0'),"
            "(218, 15861, 'VENTAQUEMADA', ' ', ' ', '0'),"
            "(218, 15879, 'VIRACACHA', ' ', ' ', '0'),"
            "(218, 15897, 'ZETAQUIRA', ' ', ' ', '0'),"
            "(218, 17001, 'MANIZALES', ' ', ' ', '0'),"
            "(218, 17013, 'AGUADAS', ' ', ' ', '0'),"
            "(218, 17042, 'ANSERMA', ' ', ' ', '0'),"
            "(218, 17050, 'ARANZAZU', ' ', ' ', '0'),"
            "(218, 17088, 'BELALCAZAR', ' ', ' ', '0'),"
            "(218, 17174, 'CHINCHINA', ' ', ' ', '0'),"
            "(218, 17272, 'FILADELFIA', ' ', ' ', '0'),"
            "(218, 17380, 'LA DORADA', ' ', ' ', '0'),"
            "(218, 17388, 'LA MERCED', ' ', ' ', '0'),"
            "(218, 17433, 'MANZANARES', ' ', ' ', '0'),"
            "(218, 17442, 'MARMATO', ' ', ' ', '0'),"
            "(218, 17444, 'MARQUETALIA', ' ', ' ', '0'),"
            "(218, 17446, 'MARULANDA', ' ', ' ', '0'),"
            "(218, 17486, 'NEIRA', ' ', ' ', '0'),"
            "(218, 17495, 'NORCASIA', ' ', ' ', '0'),"
            "(218, 17513, 'PACORA', ' ', ' ', '0'),"
            "(218, 17524, 'PALESTINA', ' ', ' ', '0'),"
            "(218, 17541, 'PENSILVANIA', ' ', ' ', '0'),"
            "(218, 17614, 'RIOSUCIO', ' ', ' ', '0'),"
            "(218, 17616, 'RISARALDA', ' ', ' ', '0'),"
            "(218, 17653, 'SALAMINA', ' ', ' ', '0'),"
            "(218, 17662, 'SAMANA', ' ', ' ', '0'),"
            "(218, 17665, 'SAN JOSE', ' ', ' ', '0'),"
            "(218, 17777, 'SUPIA', ' ', ' ', '0'),"
            "(218, 17867, 'VICTORIA', ' ', ' ', '0'),"
            "(218, 17873, 'VILLAMARIA', ' ', ' ', '0'),"
            "(218, 17877, 'VITERBO', ' ', ' ', '0'),"
            "(218, 18001, 'FLORENCIA', ' ', ' ', '0'),"
            "(218, 18029, 'ALBANIA', ' ', ' ', '0'),"
            "(218, 18094, 'BELEN DE LOS ANDAQUIES', ' ', ' ', '0'),"
            "(218, 18150, 'CARTAGENA DEL CHAIRA', ' ', ' ', '0'),"
            "(218, 18205, 'CURILLO', ' ', ' ', '0'),"
            "(218, 18247, 'EL DONCELLO', ' ', ' ', '0'),"
            "(218, 18256, 'EL PAUJIL', ' ', ' ', '0'),"
            "(218, 18410, 'LA MONTAÑITA', ' ', ' ', '0'),"
            "(218, 18460, 'MILAN', ' ', ' ', '0'),"
            "(218, 18479, 'MORELIA', ' ', ' ', '0'),"
            "(218, 18592, 'PUERTO RICO', ' ', ' ', '0'),"
            "(218, 18610, 'SAN JOSE DEL FRAGUA', ' ', ' ', '0'),"
            "(218, 18753, 'SAN VICENTE DEL CAGUAN', ' ', ' ', '0'),"
            "(218, 18756, 'SOLANO', ' ', ' ', '0'),"
            "(218, 18785, 'SOLITA', ' ', ' ', '0'),"
            "(218, 18860, 'VALPARAISO', ' ', ' ', '0'),"
            "(218, 19001, 'POPAYAN', ' ', ' ', '0'),"
            "(218, 19022, 'ALMAGUER', ' ', ' ', '0'),"
            "(218, 19050, 'ARGELIA', ' ', ' ', '0'),"
            "(218, 19075, 'BALBOA', ' ', ' ', '0'),"
            "(218, 19100, 'BOLIVAR', ' ', ' ', '0'),"
            "(218, 19110, 'BUENOS AIRES', ' ', ' ', '0'),"
            "(218, 19130, 'CAJIBIO', ' ', ' ', '0'),"
            "(218, 19137, 'CALDONO', ' ', ' ', '0'),"
            "(218, 19142, 'CALOTO', ' ', ' ', '0'),"
            "(218, 19212, 'CORINTO', ' ', ' ', '0'),"
            "(218, 19256, 'EL TAMBO', ' ', ' ', '0'),"
            "(218, 19290, 'FLORENCIA', ' ', ' ', '0'),"
            "(218, 19300, 'GUACHENE', ' ', ' ', '0'),"
            "(218, 19318, 'GUAPI', ' ', ' ', '0'),"
            "(218, 19355, 'INZA', ' ', ' ', '0'),"
            "(218, 19364, 'JAMBALO', ' ', ' ', '0'),"
            "(218, 19392, 'LA SIERRA', ' ', ' ', '0'),"
            "(218, 19397, 'LA VEGA', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 19418, 'LOPEZ', ' ', ' ', '0'),"
            "(218, 19450, 'MERCADERES', ' ', ' ', '0'),"
            "(218, 19455, 'MIRANDA', ' ', ' ', '0'),"
            "(218, 19473, 'MORALES', ' ', ' ', '0'),"
            "(218, 19513, 'PADILLA', ' ', ' ', '0'),"
            "(218, 19517, 'PAEZ', ' ', ' ', '0'),"
            "(218, 19532, 'PATIA', ' ', ' ', '0'),"
            "(218, 19533, 'PIAMONTE', ' ', ' ', '0'),"
            "(218, 19548, 'PIENDAMO', ' ', ' ', '0'),"
            "(218, 19573, 'PUERTO TEJADA', ' ', ' ', '0'),"
            "(218, 19585, 'PURACE', ' ', ' ', '0'),"
            "(218, 19622, 'ROSAS', ' ', ' ', '0'),"
            "(218, 19693, 'SAN SEBASTIAN', ' ', ' ', '0'),"
            "(218, 19698, 'SANTANDER DE QUILICHAO', ' ', ' ', '0'),"
            "(218, 19701, 'SANTA ROSA', ' ', ' ', '0'),"
            "(218, 19743, 'SILVIA', ' ', ' ', '0'),"
            "(218, 19760, 'SOTARA', ' ', ' ', '0'),"
            "(218, 19780, 'SUAREZ', ' ', ' ', '0'),"
            "(218, 19785, 'SUCRE', ' ', ' ', '0'),"
            "(218, 19807, 'TIMBIO', ' ', ' ', '0'),"
            "(218, 19809, 'TIMBIQUI', ' ', ' ', '0'),"
            "(218, 19821, 'TORIBIO', ' ', ' ', '0'),"
            "(218, 19824, 'TOTORO', ' ', ' ', '0'),"
            "(218, 19845, 'VILLA RICA', ' ', ' ', '0'),"
            "(218, 20001, 'VALLEDUPAR', ' ', ' ', '0'),"
            "(218, 20011, 'AGUACHICA', ' ', ' ', '0'),"
            "(218, 20013, 'AGUSTIN CODAZZI', ' ', ' ', '0'),"
            "(218, 20032, 'ASTREA', ' ', ' ', '0'),"
            "(218, 20045, 'BECERRIL', ' ', ' ', '0'),"
            "(218, 20060, 'BOSCONIA', ' ', ' ', '0'),"
            "(218, 20175, 'CHIMICHAGUA', ' ', ' ', '0'),"
            "(218, 20178, 'CHIRIGUANA', ' ', ' ', '0'),"
            "(218, 20228, 'CURUMANI', ' ', ' ', '0'),"
            "(218, 20238, 'EL COPEY', ' ', ' ', '0'),"
            "(218, 20250, 'EL PASO', ' ', ' ', '0'),"
            "(218, 20295, 'GAMARRA', ' ', ' ', '0'),"
            "(218, 20310, 'GONZALEZ', ' ', ' ', '0'),"
            "(218, 20383, 'LA GLORIA', ' ', ' ', '0'),"
            "(218, 20400, 'LA JAGUA DE IBIRICO', ' ', ' ', '0'),"
            "(218, 20443, 'MANAURE', ' ', ' ', '0'),"
            "(218, 20517, 'PAILITAS', ' ', ' ', '0'),"
            "(218, 20550, 'PELAYA', ' ', ' ', '0'),"
            "(218, 20570, 'PUEBLO BELLO', ' ', ' ', '0'),"
            "(218, 20614, 'RIO DE ORO', ' ', ' ', '0'),"
            "(218, 20621, 'LA PAZ', ' ', ' ', '0'),"
            "(218, 20710, 'SAN ALBERTO', ' ', ' ', '0'),"
            "(218, 20750, 'SAN DIEGO', ' ', ' ', '0'),"
            "(218, 20770, 'SAN MARTIN', ' ', ' ', '0'),"
            "(218, 20787, 'TAMALAMEQUE', ' ', ' ', '0'),"
            "(218, 23001, 'MONTERIA', ' ', ' ', '0'),"
            "(218, 23068, 'AYAPEL', ' ', ' ', '0'),"
            "(218, 23079, 'BUENAVISTA', ' ', ' ', '0'),"
            "(218, 23090, 'CANALETE', ' ', ' ', '0'),"
            "(218, 23162, 'CERETE', ' ', ' ', '0'),"
            "(218, 23168, 'CHIMA', ' ', ' ', '0'),"
            "(218, 23182, 'CHINU', ' ', ' ', '0'),"
            "(218, 23189, 'CIENAGA DE ORO', ' ', ' ', '0'),"
            "(218, 23300, 'COTORRA', ' ', ' ', '0'),"
            "(218, 23350, 'LA APARTADA', ' ', ' ', '0'),"
            "(218, 23417, 'LORICA', ' ', ' ', '0'),"
            "(218, 23419, 'LOS CORDOBAS', ' ', ' ', '0'),"
            "(218, 23464, 'MOMIL', ' ', ' ', '0'),"
            "(218, 23466, 'MONTELIBANO', ' ', ' ', '0'),"
            "(218, 23500, 'MOÑITOS', ' ', ' ', '0'),"
            "(218, 23555, 'PLANETA RICA', ' ', ' ', '0'),"
            "(218, 23570, 'PUEBLO NUEVO', ' ', ' ', '0'),"
            "(218, 23574, 'PUERTO ESCONDIDO', ' ', ' ', '0'),"
            "(218, 23580, 'PUERTO LIBERTADOR', ' ', ' ', '0'),"
            "(218, 23586, 'PURISIMA', ' ', ' ', '0'),"
            "(218, 23660, 'SAHAGUN', ' ', ' ', '0'),"
            "(218, 23670, 'SAN ANDRES SOTAVENTO', ' ', ' ', '0'),"
            "(218, 23672, 'SAN ANTERO', ' ', ' ', '0'),"
            "(218, 23675, 'SAN BERNARDO DEL VIENTO', ' ', ' ', '0'),"
            "(218, 23678, 'SAN CARLOS', ' ', ' ', '0'),"
            "(218, 23686, 'SAN PELAYO', ' ', ' ', '0'),"
            "(218, 23807, 'TIERRALTA', ' ', ' ', '0'),"
            "(218, 23855, 'VALENCIA', ' ', ' ', '0'),"
            "(218, 25001, 'AGUA DE DIOS', ' ', ' ', '0'),"
            "(218, 25019, 'ALBAN', ' ', ' ', '0'),"
            "(218, 25035, 'ANAPOIMA', ' ', ' ', '0'),"
            "(218, 25040, 'ANOLAIMA', ' ', ' ', '0'),"
            "(218, 25053, 'ARBELAEZ', ' ', ' ', '0'),"
            "(218, 25086, 'BELTRAN', ' ', ' ', '0'),"
            "(218, 25095, 'BITUIMA', ' ', ' ', '0'),"
            "(218, 25099, 'BOJACA', ' ', ' ', '0'),"
            "(218, 25120, 'CABRERA', ' ', ' ', '0'),"
            "(218, 25123, 'CACHIPAY', ' ', ' ', '0'),"
            "(218, 25126, 'CAJICA', ' ', ' ', '0'),"
            "(218, 25148, 'CAPARRAPI', ' ', ' ', '0'),"
            "(218, 25151, 'CAQUEZA', ' ', ' ', '0'),"
            "(218, 25154, 'CARMEN DE CARUPA', ' ', ' ', '0'),"
            "(218, 25168, 'CHAGUANI', ' ', ' ', '0'),"
            "(218, 25175, 'CHIA', ' ', ' ', '0'),"
            "(218, 25178, 'CHIPAQUE', ' ', ' ', '0'),"
            "(218, 25181, 'CHOACHI', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 25183, 'CHOCONTA', ' ', ' ', '0'),"
            "(218, 25200, 'COGUA', ' ', ' ', '0'),"
            "(218, 25214, 'COTA', ' ', ' ', '0'),"
            "(218, 25224, 'CUCUNUBA', ' ', ' ', '0'),"
            "(218, 25245, 'EL COLEGIO', ' ', ' ', '0'),"
            "(218, 25258, 'EL PEÑON', ' ', ' ', '0'),"
            "(218, 25260, 'EL ROSAL', ' ', ' ', '0'),"
            "(218, 25269, 'FACATATIVA', ' ', ' ', '0'),"
            "(218, 25279, 'FOMEQUE', ' ', ' ', '0'),"
            "(218, 25281, 'FOSCA', ' ', ' ', '0'),"
            "(218, 25286, 'FUNZA', ' ', ' ', '0'),"
            "(218, 25288, 'FUQUENE', ' ', ' ', '0'),"
            "(218, 25290, 'FUSAGASUGA', ' ', ' ', '0'),"
            "(218, 25293, 'GACHALA', ' ', ' ', '0'),"
            "(218, 25295, 'GACHANCIPA', ' ', ' ', '0'),"
            "(218, 25297, 'GACHETA', ' ', ' ', '0'),"
            "(218, 25299, 'GAMA', ' ', ' ', '0'),"
            "(218, 25307, 'GIRARDOT', ' ', ' ', '0'),"
            "(218, 25312, 'GRANADA', ' ', ' ', '0'),"
            "(218, 25317, 'GUACHETA', ' ', ' ', '0'),"
            "(218, 25320, 'GUADUAS', ' ', ' ', '0'),"
            "(218, 25322, 'GUASCA', ' ', ' ', '0'),"
            "(218, 25324, 'GUATAQUI', ' ', ' ', '0'),"
            "(218, 25326, 'GUATAVITA', ' ', ' ', '0'),"
            "(218, 25328, 'GUAYABAL DE SIQUIMA', ' ', ' ', '0'),"
            "(218, 25335, 'GUAYABETAL', ' ', ' ', '0'),"
            "(218, 25339, 'GUTIERREZ', ' ', ' ', '0'),"
            "(218, 25368, 'JERUSALEN', ' ', ' ', '0'),"
            "(218, 25372, 'JUNIN', ' ', ' ', '0'),"
            "(218, 25377, 'LA CALERA', ' ', ' ', '0'),"
            "(218, 25386, 'LA MESA', ' ', ' ', '0'),"
            "(218, 25394, 'LA PALMA', ' ', ' ', '0'),"
            "(218, 25398, 'LA PEÑA', ' ', ' ', '0'),"
            "(218, 25402, 'LA VEGA', ' ', ' ', '0'),"
            "(218, 25407, 'LENGUAZAQUE', ' ', ' ', '0'),"
            "(218, 25426, 'MACHETA', ' ', ' ', '0'),"
            "(218, 25430, 'MADRID', ' ', ' ', '0'),"
            "(218, 25436, 'MANTA', ' ', ' ', '0'),"
            "(218, 25438, 'MEDINA', ' ', ' ', '0'),"
            "(218, 25473, 'MOSQUERA', ' ', ' ', '0'),"
            "(218, 25483, 'NARIÑO', ' ', ' ', '0'),"
            "(218, 25486, 'NEMOCON', ' ', ' ', '0'),"
            "(218, 25488, 'NILO', ' ', ' ', '0'),"
            "(218, 25489, 'NIMAIMA', ' ', ' ', '0'),"
            "(218, 25491, 'NOCAIMA', ' ', ' ', '0'),"
            "(218, 25506, 'VENECIA', ' ', ' ', '0'),"
            "(218, 25513, 'PACHO', ' ', ' ', '0'),"
            "(218, 25518, 'PAIME', ' ', ' ', '0'),"
            "(218, 25524, 'PANDI', ' ', ' ', '0'),"
            "(218, 25530, 'PARATEBUENO', ' ', ' ', '0'),"
            "(218, 25535, 'PASCA', ' ', ' ', '0'),"
            "(218, 25572, 'PUERTO SALGAR', ' ', ' ', '0'),"
            "(218, 25580, 'PULI', ' ', ' ', '0'),"
            "(218, 25592, 'QUEBRADANEGRA', ' ', ' ', '0'),"
            "(218, 25594, 'QUETAME', ' ', ' ', '0'),"
            "(218, 25596, 'QUIPILE', ' ', ' ', '0'),"
            "(218, 25599, 'APULO', ' ', ' ', '0'),"
            "(218, 25612, 'RICAURTE', ' ', ' ', '0'),"
            "(218, 25645, 'SAN ANTONIO DEL TEQUENDAMA', ' ', ' ', '0'),"
            "(218, 25649, 'SAN BERNARDO', ' ', ' ', '0'),"
            "(218, 25653, 'SAN CAYETANO', ' ', ' ', '0'),"
            "(218, 25658, 'SAN FRANCISCO', ' ', ' ', '0'),"
            "(218, 25662, 'SAN JUAN DE RIO SECO', ' ', ' ', '0'),"
            "(218, 25718, 'SASAIMA', ' ', ' ', '0'),"
            "(218, 25736, 'SESQUILE', ' ', ' ', '0'),"
            "(218, 25740, 'SIBATE', ' ', ' ', '0'),"
            "(218, 25743, 'SILVANIA', ' ', ' ', '0'),"
            "(218, 25745, 'SIMIJACA', ' ', ' ', '0'),"
            "(218, 25754, 'SOACHA', ' ', ' ', '0'),"
            "(218, 25758, 'SOPO', ' ', ' ', '0'),"
            "(218, 25769, 'SUBACHOQUE', ' ', ' ', '0'),"
            "(218, 25772, 'SUESCA', ' ', ' ', '0'),"
            "(218, 25777, 'SUPATA', ' ', ' ', '0'),"
            "(218, 25779, 'SUSA', ' ', ' ', '0'),"
            "(218, 25781, 'SUTATAUSA', ' ', ' ', '0'),"
            "(218, 25785, 'TABIO', ' ', ' ', '0'),"
            "(218, 25793, 'TAUSA', ' ', ' ', '0'),"
            "(218, 25797, 'TENA', ' ', ' ', '0'),"
            "(218, 25799, 'TENJO', ' ', ' ', '0'),"
            "(218, 25805, 'TIBACUY', ' ', ' ', '0'),"
            "(218, 25807, 'TIBIRITA', ' ', ' ', '0'),"
            "(218, 25815, 'TOCAIMA', ' ', ' ', '0'),"
            "(218, 25817, 'TOCANCIPA', ' ', ' ', '0'),"
            "(218, 25823, 'TOPAIPI', ' ', ' ', '0'),"
            "(218, 25839, 'UBALA', ' ', ' ', '0'),"
            "(218, 25841, 'UBAQUE', ' ', ' ', '0'),"
            "(218, 25843, 'VILLA DE SAN DIEGO DE UBATE', ' ', ' ', '0'),"
            "(218, 25845, 'UNE', ' ', ' ', '0'),"
            "(218, 25851, 'UTICA', ' ', ' ', '0'),"
            "(218, 25862, 'VERGARA', ' ', ' ', '0'),"
            "(218, 25867, 'VIANI', ' ', ' ', '0'),"
            "(218, 25871, 'VILLAGOMEZ', ' ', ' ', '0'),"
            "(218, 25873, 'VILLAPINZON', ' ', ' ', '0'),"
            "(218, 25875, 'VILLETA', ' ', ' ', '0'),"
            "(218, 25878, 'VIOTA', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 25885, 'YACOPI', ' ', ' ', '0'),"
            "(218, 25898, 'ZIPACON', ' ', ' ', '0'),"
            "(218, 25899, 'ZIPAQUIRA', ' ', ' ', '0'),"
            "(218, 27001, 'QUIBDO', ' ', ' ', '0'),"
            "(218, 27006, 'ACANDI', ' ', ' ', '0'),"
            "(218, 27025, 'ALTO BAUDO', ' ', ' ', '0'),"
            "(218, 27050, 'ATRATO', ' ', ' ', '0'),"
            "(218, 27073, 'BAGADO', ' ', ' ', '0'),"
            "(218, 27075, 'BAHIA SOLANO', ' ', ' ', '0'),"
            "(218, 27077, 'BAJO BAUDO', ' ', ' ', '0'),"
            "(218, 27099, 'BOJAYA', ' ', ' ', '0'),"
            "(218, 27135, 'EL CANTON DEL SAN PABLO', ' ', ' ', '0'),"
            "(218, 27150, 'CARMEN DEL DARIEN', ' ', ' ', '0'),"
            "(218, 27160, 'CERTEGUI', ' ', ' ', '0'),"
            "(218, 27205, 'CONDOTO', ' ', ' ', '0'),"
            "(218, 27245, 'EL CARMEN DE ATRATO', ' ', ' ', '0'),"
            "(218, 27250, 'EL LITORAL DEL SAN JUAN', ' ', ' ', '0'),"
            "(218, 27361, 'ISTMINA', ' ', ' ', '0'),"
            "(218, 27372, 'JURADO', ' ', ' ', '0'),"
            "(218, 27413, 'LLORO', ' ', ' ', '0'),"
            "(218, 27425, 'MEDIO ATRATO', ' ', ' ', '0'),"
            "(218, 27430, 'MEDIO BAUDO', ' ', ' ', '0'),"
            "(218, 27450, 'MEDIO SAN JUAN', ' ', ' ', '0'),"
            "(218, 27491, 'NOVITA', ' ', ' ', '0'),"
            "(218, 27495, 'NUQUI', ' ', ' ', '0'),"
            "(218, 27580, 'RIO IRO', ' ', ' ', '0'),"
            "(218, 27600, 'RIO QUITO', ' ', ' ', '0'),"
            "(218, 27615, 'RIOSUCIO', ' ', ' ', '0'),"
            "(218, 27660, 'SAN JOSE DEL PALMAR', ' ', ' ', '0'),"
            "(218, 27745, 'SIPI', ' ', ' ', '0'),"
            "(218, 27787, 'TADO', ' ', ' ', '0'),"
            "(218, 27800, 'UNGUIA', ' ', ' ', '0'),"
            "(218, 27810, 'UNION PANAMERICANA', ' ', ' ', '0'),"
            "(218, 41001, 'NEIVA', ' ', ' ', '0'),"
            "(218, 41006, 'ACEVEDO', ' ', ' ', '0'),"
            "(218, 41013, 'AGRADO', ' ', ' ', '0'),"
            "(218, 41016, 'AIPE', ' ', ' ', '0'),"
            "(218, 41020, 'ALGECIRAS', ' ', ' ', '0'),"
            "(218, 41026, 'ALTAMIRA', ' ', ' ', '0'),"
            "(218, 41078, 'BARAYA', ' ', ' ', '0'),"
            "(218, 41132, 'CAMPOALEGRE', ' ', ' ', '0'),"
            "(218, 41244, 'ELIAS', ' ', ' ', '0'),"
            "(218, 41298, 'GARZON', ' ', ' ', '0'),"
            "(218, 41319, 'GUADALUPE', ' ', ' ', '0'),"
            "(218, 41349, 'HOBO', ' ', ' ', '0'),"
            "(218, 41357, 'IQUIRA', ' ', ' ', '0'),"
            "(218, 41359, 'ISNOS', ' ', ' ', '0'),"
            "(218, 41378, 'LA ARGENTINA', ' ', ' ', '0'),"
            "(218, 41396, 'LA PLATA', ' ', ' ', '0'),"
            "(218, 41483, 'NATAGA', ' ', ' ', '0'),"
            "(218, 41503, 'OPORAPA', ' ', ' ', '0'),"
            "(218, 41518, 'PAICOL', ' ', ' ', '0'),"
            "(218, 41524, 'PALERMO', ' ', ' ', '0'),"
            "(218, 41530, 'PALESTINA', ' ', ' ', '0'),"
            "(218, 41548, 'PITAL', ' ', ' ', '0'),"
            "(218, 41551, 'PITALITO', ' ', ' ', '0'),"
            "(218, 41615, 'RIVERA', ' ', ' ', '0'),"
            "(218, 41660, 'SALADOBLANCO', ' ', ' ', '0'),"
            "(218, 41668, 'SAN AGUSTIN', ' ', ' ', '0'),"
            "(218, 41676, 'SANTA MARIA', ' ', ' ', '0'),"
            "(218, 41770, 'SUAZA', ' ', ' ', '0'),"
            "(218, 41791, 'TARQUI', ' ', ' ', '0'),"
            "(218, 41797, 'TESALIA', ' ', ' ', '0'),"
            "(218, 41799, 'TELLO', ' ', ' ', '0'),"
            "(218, 41801, 'TERUEL', ' ', ' ', '0'),"
            "(218, 41807, 'TIMANA', ' ', ' ', '0'),"
            "(218, 41872, 'VILLAVIEJA', ' ', ' ', '0'),"
            "(218, 41885, 'YAGUARA', ' ', ' ', '0'),"
            "(218, 41998, 'COLOMBIA', ' ', ' ', '0'),"
            "(218, 44001, 'RIOHACHA', ' ', ' ', '0'),"
            "(218, 44035, 'ALBANIA', ' ', ' ', '0'),"
            "(218, 44078, 'BARRANCAS', ' ', ' ', '0'),"
            "(218, 44090, 'DIBULLA', ' ', ' ', '0'),"
            "(218, 44098, 'DISTRACCION', ' ', ' ', '0'),"
            "(218, 44110, 'EL MOLINO', ' ', ' ', '0'),"
            "(218, 44279, 'FONSECA', ' ', ' ', '0'),"
            "(218, 44378, 'HATONUEVO', ' ', ' ', '0'),"
            "(218, 44420, 'LA JAGUA DEL PILAR', ' ', ' ', '0'),"
            "(218, 44430, 'MAICAO', ' ', ' ', '0'),"
            "(218, 44560, 'MANAURE', ' ', ' ', '0'),"
            "(218, 44650, 'SAN JUAN DEL CESAR', ' ', ' ', '0'),"
            "(218, 44847, 'URIBIA', ' ', ' ', '0'),"
            "(218, 44855, 'URUMITA', ' ', ' ', '0'),"
            "(218, 44874, 'VILLANUEVA', ' ', ' ', '0'),"
            "(218, 47001, 'SANTA MARTA', ' ', ' ', '0'),"
            "(218, 47030, 'ALGARROBO', ' ', ' ', '0'),"
            "(218, 47053, 'ARACATACA', ' ', ' ', '0'),"
            "(218, 47058, 'ARIGUANI', ' ', ' ', '0'),"
            "(218, 47161, 'CERRO SAN ANTONIO', ' ', ' ', '0'),"
            "(218, 47170, 'CHIBOLO', ' ', ' ', '0'),"
            "(218, 47189, 'CIENAGA', ' ', ' ', '0'),"
            "(218, 47205, 'CONCORDIA', ' ', ' ', '0'),"
            "(218, 47245, 'EL BANCO', ' ', ' ', '0'),"
            "(218, 47258, 'EL PIÑON', ' ', ' ', '0'),"
            "(218, 47268, 'EL RETEN', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 47288, 'FUNDACION', ' ', ' ', '0'),"
            "(218, 47318, 'GUAMAL', ' ', ' ', '0'),"
            "(218, 47460, 'NUEVA GRANADA', ' ', ' ', '0'),"
            "(218, 47541, 'PEDRAZA', ' ', ' ', '0'),"
            "(218, 47545, 'PIJIÑO DEL CARMEN', ' ', ' ', '0'),"
            "(218, 47551, 'PIVIJAY', ' ', ' ', '0'),"
            "(218, 47555, 'PLATO', ' ', ' ', '0'),"
            "(218, 47570, 'PUEBLOVIEJO', ' ', ' ', '0'),"
            "(218, 47605, 'REMOLINO', ' ', ' ', '0'),"
            "(218, 47660, 'SABANAS DE SAN ANGEL', ' ', ' ', '0'),"
            "(218, 47675, 'SALAMINA', ' ', ' ', '0'),"
            "(218, 47692, 'SAN SEBASTIAN DE BUENAVISTA', ' ', ' ', '0'),"
            "(218, 47703, 'SAN ZENON', ' ', ' ', '0'),"
            "(218, 47707, 'SANTA ANA', ' ', ' ', '0'),"
            "(218, 47720, 'SANTA BARBARA DE PINTO', ' ', ' ', '0'),"
            "(218, 47745, 'SITIONUEVO', ' ', ' ', '0'),"
            "(218, 47798, 'TENERIFE', ' ', ' ', '0'),"
            "(218, 47960, 'ZAPAYAN', ' ', ' ', '0'),"
            "(218, 47980, 'ZONA BANANERA', ' ', ' ', '0'),"
            "(218, 50001, 'VILLAVICENCIO', ' ', ' ', '0'),"
            "(218, 50006, 'ACACIAS', ' ', ' ', '0'),"
            "(218, 50110, 'BARRANCA DE UPIA', ' ', ' ', '0'),"
            "(218, 50124, 'CABUYARO', ' ', ' ', '0'),"
            "(218, 50150, 'CASTILLA LA NUEVA', ' ', ' ', '0'),"
            "(218, 50223, 'CUBARRAL', ' ', ' ', '0'),"
            "(218, 50226, 'CUMARAL', ' ', ' ', '0'),"
            "(218, 50245, 'EL CALVARIO', ' ', ' ', '0'),"
            "(218, 50251, 'EL CASTILLO', ' ', ' ', '0'),"
            "(218, 50270, 'EL DORADO', ' ', ' ', '0'),"
            "(218, 50287, 'FUENTE DE ORO', ' ', ' ', '0'),"
            "(218, 50313, 'GRANADA', ' ', ' ', '0'),"
            "(218, 50318, 'GUAMAL', ' ', ' ', '0'),"
            "(218, 50325, 'MAPIRIPAN', ' ', ' ', '0'),"
            "(218, 50330, 'MESETAS', ' ', ' ', '0'),"
            "(218, 50350, 'LA MACARENA', ' ', ' ', '0'),"
            "(218, 50370, 'URIBE', ' ', ' ', '0'),"
            "(218, 50400, 'LEJANIAS', ' ', ' ', '0'),"
            "(218, 50450, 'PUERTO CONCORDIA', ' ', ' ', '0'),"
            "(218, 50568, 'PUERTO GAITAN', ' ', ' ', '0'),"
            "(218, 50573, 'PUERTO LOPEZ', ' ', ' ', '0'),"
            "(218, 50577, 'PUERTO LLERAS', ' ', ' ', '0'),"
            "(218, 50590, 'PUERTO RICO', ' ', ' ', '0'),"
            "(218, 50606, 'RESTREPO', ' ', ' ', '0'),"
            "(218, 50680, 'SAN CARLOS DE GUAROA', ' ', ' ', '0'),"
            "(218, 50683, 'SAN JUAN DE ARAMA', ' ', ' ', '0'),"
            "(218, 50686, 'SAN JUANITO', ' ', ' ', '0'),"
            "(218, 50689, 'SAN MARTIN', ' ', ' ', '0'),"
            "(218, 50711, 'VISTAHERMOSA', ' ', ' ', '0'),"
            "(218, 52001, 'PASTO', ' ', ' ', '0'),"
            "(218, 52019, 'ALBAN', ' ', ' ', '0'),"
            "(218, 52022, 'ALDANA', ' ', ' ', '0'),"
            "(218, 52036, 'ANCUYA', ' ', ' ', '0'),"
            "(218, 52051, 'ARBOLEDA', ' ', ' ', '0'),"
            "(218, 52079, 'BARBACOAS', ' ', ' ', '0'),"
            "(218, 52083, 'BELEN', ' ', ' ', '0'),"
            "(218, 52110, 'BUESACO', ' ', ' ', '0'),"
            "(218, 52203, 'COLON', ' ', ' ', '0'),"
            "(218, 52207, 'CONSACA', ' ', ' ', '0'),"
            "(218, 52210, 'CONTADERO', ' ', ' ', '0'),"
            "(218, 52215, 'CORDOBA', ' ', ' ', '0'),"
            "(218, 52224, 'CUASPUD', ' ', ' ', '0'),"
            "(218, 52227, 'CUMBAL', ' ', ' ', '0'),"
            "(218, 52233, 'CUMBITARA', ' ', ' ', '0'),"
            "(218, 52240, 'CHACHAGsI', ' ', ' ', '0'),"
            "(218, 52250, 'EL CHARCO', ' ', ' ', '0'),"
            "(218, 52254, 'EL PEÑOL', ' ', ' ', '0'),"
            "(218, 52256, 'EL ROSARIO', ' ', ' ', '0'),"
            "(218, 52258, 'EL TABLON DE GOMEZ', ' ', ' ', '0'),"
            "(218, 52260, 'EL TAMBO', ' ', ' ', '0'),"
            "(218, 52287, 'FUNES', ' ', ' ', '0'),"
            "(218, 52317, 'GUACHUCAL', ' ', ' ', '0'),"
            "(218, 52320, 'GUAITARILLA', ' ', ' ', '0'),"
            "(218, 52323, 'GUALMATAN', ' ', ' ', '0'),"
            "(218, 52352, 'ILES', ' ', ' ', '0'),"
            "(218, 52354, 'IMUES', ' ', ' ', '0'),"
            "(218, 52356, 'IPIALES', ' ', ' ', '0'),"
            "(218, 52378, 'LA CRUZ', ' ', ' ', '0'),"
            "(218, 52381, 'LA FLORIDA', ' ', ' ', '0'),"
            "(218, 52385, 'LA LLANADA', ' ', ' ', '0'),"
            "(218, 52390, 'LA TOLA', ' ', ' ', '0'),"
            "(218, 52399, 'LA UNION', ' ', ' ', '0'),"
            "(218, 52405, 'LEIVA', ' ', ' ', '0'),"
            "(218, 52411, 'LINARES', ' ', ' ', '0'),"
            "(218, 52418, 'LOS ANDES', ' ', ' ', '0'),"
            "(218, 52427, 'MAGsI', ' ', ' ', '0'),"
            "(218, 52435, 'MALLAMA', ' ', ' ', '0'),"
            "(218, 52473, 'MOSQUERA', ' ', ' ', '0'),"
            "(218, 52480, 'NARIÑO', ' ', ' ', '0'),"
            "(218, 52490, 'OLAYA HERRERA', ' ', ' ', '0'),"
            "(218, 52506, 'OSPINA', ' ', ' ', '0'),"
            "(218, 52520, 'FRANCISCO PIZARRO', ' ', ' ', '0'),"
            "(218, 52540, 'POLICARPA', ' ', ' ', '0'),"
            "(218, 52560, 'POTOSI', ' ', ' ', '0'),"
            "(218, 52565, 'PROVIDENCIA', ' ', ' ', '0'),"
            "(218, 52573, 'PUERRES', ' ', ' ', '0'),"
            "(218, 52585, 'PUPIALES', ' ', ' ', '0'),"
            "(218, 52612, 'RICAURTE', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 52621, 'ROBERTO PAYAN', ' ', ' ', '0'),"
            "(218, 52678, 'SAMANIEGO', ' ', ' ', '0'),"
            "(218, 52683, 'SANDONA', ' ', ' ', '0'),"
            "(218, 52685, 'SAN BERNARDO', ' ', ' ', '0'),"
            "(218, 52687, 'SAN LORENZO', ' ', ' ', '0'),"
            "(218, 52693, 'SAN PABLO', ' ', ' ', '0'),"
            "(218, 52694, 'SAN PEDRO DE CARTAGO', ' ', ' ', '0'),"
            "(218, 52696, 'SANTA BARBARA', ' ', ' ', '0'),"
            "(218, 52699, 'SANTACRUZ', ' ', ' ', '0'),"
            "(218, 52720, 'SAPUYES', ' ', ' ', '0'),"
            "(218, 52786, 'TAMINANGO', ' ', ' ', '0'),"
            "(218, 52788, 'TANGUA', ' ', ' ', '0'),"
            "(218, 52835, 'SAN ANDRES DE TUMACO', ' ', ' ', '0'),"
            "(218, 52838, 'TUQUERRES', ' ', ' ', '0'),"
            "(218, 52885, 'YACUANQUER', ' ', ' ', '0'),"
            "(218, 54001, 'CUCUTA', ' ', ' ', '0'),"
            "(218, 54003, 'ABREGO', ' ', ' ', '0'),"
            "(218, 54051, 'ARBOLEDAS', ' ', ' ', '0'),"
            "(218, 54099, 'BOCHALEMA', ' ', ' ', '0'),"
            "(218, 54109, 'BUCARASICA', ' ', ' ', '0'),"
            "(218, 54125, 'CACOTA', ' ', ' ', '0'),"
            "(218, 54128, 'CACHIRA', ' ', ' ', '0'),"
            "(218, 54172, 'CHINACOTA', ' ', ' ', '0'),"
            "(218, 54174, 'CHITAGA', ' ', ' ', '0'),"
            "(218, 54206, 'CONVENCION', ' ', ' ', '0'),"
            "(218, 54223, 'CUCUTILLA', ' ', ' ', '0'),"
            "(218, 54239, 'DURANIA', ' ', ' ', '0'),"
            "(218, 54245, 'EL CARMEN', ' ', ' ', '0'),"
            "(218, 54250, 'EL TARRA', ' ', ' ', '0'),"
            "(218, 54261, 'EL ZULIA', ' ', ' ', '0'),"
            "(218, 54313, 'GRAMALOTE', ' ', ' ', '0'),"
            "(218, 54344, 'HACARI', ' ', ' ', '0'),"
            "(218, 54347, 'HERRAN', ' ', ' ', '0'),"
            "(218, 54377, 'LABATECA', ' ', ' ', '0'),"
            "(218, 54385, 'LA ESPERANZA', ' ', ' ', '0'),"
            "(218, 54398, 'LA PLAYA', ' ', ' ', '0'),"
            "(218, 54405, 'LOS PATIOS', ' ', ' ', '0'),"
            "(218, 54418, 'LOURDES', ' ', ' ', '0'),"
            "(218, 54480, 'MUTISCUA', ' ', ' ', '0'),"
            "(218, 54498, 'OCAÑA', ' ', ' ', '0'),"
            "(218, 54518, 'PAMPLONA', ' ', ' ', '0'),"
            "(218, 54520, 'PAMPLONITA', ' ', ' ', '0'),"
            "(218, 54553, 'PUERTO SANTANDER', ' ', ' ', '0'),"
            "(218, 54599, 'RAGONVALIA', ' ', ' ', '0'),"
            "(218, 54660, 'SALAZAR', ' ', ' ', '0'),"
            "(218, 54670, 'SAN CALIXTO', ' ', ' ', '0'),"
            "(218, 54673, 'SAN CAYETANO', ' ', ' ', '0'),"
            "(218, 54680, 'SANTIAGO', ' ', ' ', '0'),"
            "(218, 54720, 'SARDINATA', ' ', ' ', '0'),"
            "(218, 54743, 'SILOS', ' ', ' ', '0'),"
            "(218, 54800, 'TEORAMA', ' ', ' ', '0'),"
            "(218, 54810, 'TIBU', ' ', ' ', '0'),"
            "(218, 54820, 'TOLEDO', ' ', ' ', '0'),"
            "(218, 54871, 'VILLA CARO', ' ', ' ', '0'),"
            "(218, 54874, 'VILLA DEL ROSARIO', ' ', ' ', '0'),"
            "(218, 63001, 'ARMENIA', ' ', ' ', '0'),"
            "(218, 63111, 'BUENAVISTA', ' ', ' ', '0'),"
            "(218, 63130, 'CALARCA', ' ', ' ', '0'),"
            "(218, 63190, 'CIRCASIA', ' ', ' ', '0'),"
            "(218, 63212, 'CORDOBA', ' ', ' ', '0'),"
            "(218, 63272, 'FILANDIA', ' ', ' ', '0'),"
            "(218, 63302, 'GENOVA', ' ', ' ', '0'),"
            "(218, 63401, 'LA TEBAIDA', ' ', ' ', '0'),"
            "(218, 63470, 'MONTENEGRO', ' ', ' ', '0'),"
            "(218, 63548, 'PIJAO', ' ', ' ', '0'),"
            "(218, 63594, 'QUIMBAYA', ' ', ' ', '0'),"
            "(218, 63690, 'SALENTO', ' ', ' ', '0'),"
            "(218, 66001, 'PEREIRA', ' ', ' ', '0'),"
            "(218, 66045, 'APIA', ' ', ' ', '0'),"
            "(218, 66075, 'BALBOA', ' ', ' ', '0'),"
            "(218, 66088, 'BELEN DE UMBRIA', ' ', ' ', '0'),"
            "(218, 66170, 'DOSQUEBRADAS', ' ', ' ', '0'),"
            "(218, 66318, 'GUATICA', ' ', ' ', '0'),"
            "(218, 66383, 'LA CELIA', ' ', ' ', '0'),"
            "(218, 66400, 'LA VIRGINIA', ' ', ' ', '0'),"
            "(218, 66440, 'MARSELLA', ' ', ' ', '0'),"
            "(218, 66456, 'MISTRATO', ' ', ' ', '0'),"
            "(218, 66572, 'PUEBLO RICO', ' ', ' ', '0'),"
            "(218, 66594, 'QUINCHIA', ' ', ' ', '0'),"
            "(218, 66682, 'SANTA ROSA DE CABAL', ' ', ' ', '0'),"
            "(218, 66687, 'SANTUARIO', ' ', ' ', '0'),"
            "(218, 68001, 'BUCARAMANGA', ' ', ' ', '0'),"
            "(218, 68013, 'AGUADA', ' ', ' ', '0'),"
            "(218, 68020, 'ALBANIA', ' ', ' ', '0'),"
            "(218, 68051, 'ARATOCA', ' ', ' ', '0'),"
            "(218, 68077, 'BARBOSA', ' ', ' ', '0'),"
            "(218, 68079, 'BARICHARA', ' ', ' ', '0'),"
            "(218, 68081, 'BARRANCABERMEJA', ' ', ' ', '0'),"
            "(218, 68092, 'BETULIA', ' ', ' ', '0'),"
            "(218, 68101, 'BOLIVAR', ' ', ' ', '0'),"
            "(218, 68121, 'CABRERA', ' ', ' ', '0'),"
            "(218, 68132, 'CALIFORNIA', ' ', ' ', '0'),"
            "(218, 68147, 'CAPITANEJO', ' ', ' ', '0'),"
            "(218, 68152, 'CARCASI', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 68160, 'CEPITA', ' ', ' ', '0'),"
            "(218, 68162, 'CERRITO', ' ', ' ', '0'),"
            "(218, 68167, 'CHARALA', ' ', ' ', '0'),"
            "(218, 68169, 'CHARTA', ' ', ' ', '0'),"
            "(218, 68176, 'CHIMA', ' ', ' ', '0'),"
            "(218, 68179, 'CHIPATA', ' ', ' ', '0'),"
            "(218, 68190, 'CIMITARRA', ' ', ' ', '0'),"
            "(218, 68207, 'CONCEPCION', ' ', ' ', '0'),"
            "(218, 68209, 'CONFINES', ' ', ' ', '0'),"
            "(218, 68211, 'CONTRATACION', ' ', ' ', '0'),"
            "(218, 68217, 'COROMORO', ' ', ' ', '0'),"
            "(218, 68229, 'CURITI', ' ', ' ', '0'),"
            "(218, 68235, 'EL CARMEN DE CHUCURI', ' ', ' ', '0'),"
            "(218, 68245, 'EL GUACAMAYO', ' ', ' ', '0'),"
            "(218, 68250, 'EL PEÑON', ' ', ' ', '0'),"
            "(218, 68255, 'EL PLAYON', ' ', ' ', '0'),"
            "(218, 68264, 'ENCINO', ' ', ' ', '0'),"
            "(218, 68266, 'ENCISO', ' ', ' ', '0'),"
            "(218, 68271, 'FLORIAN', ' ', ' ', '0'),"
            "(218, 68276, 'FLORIDABLANCA', ' ', ' ', '0'),"
            "(218, 68296, 'GALAN', ' ', ' ', '0'),"
            "(218, 68298, 'GAMBITA', ' ', ' ', '0'),"
            "(218, 68307, 'GIRON', ' ', ' ', '0'),"
            "(218, 68318, 'GUACA', ' ', ' ', '0'),"
            "(218, 68320, 'GUADALUPE', ' ', ' ', '0'),"
            "(218, 68322, 'GUAPOTA', ' ', ' ', '0'),"
            "(218, 68324, 'GUAVATA', ' ', ' ', '0'),"
            "(218, 68327, 'GsEPSA', ' ', ' ', '0'),"
            "(218, 68344, 'HATO', ' ', ' ', '0'),"
            "(218, 68368, 'JESUS MARIA', ' ', ' ', '0'),"
            "(218, 68370, 'JORDAN', ' ', ' ', '0'),"
            "(218, 68377, 'LA BELLEZA', ' ', ' ', '0'),"
            "(218, 68385, 'LANDAZURI', ' ', ' ', '0'),"
            "(218, 68397, 'LA PAZ', ' ', ' ', '0'),"
            "(218, 68406, 'LEBRIJA', ' ', ' ', '0'),"
            "(218, 68418, 'LOS SANTOS', ' ', ' ', '0'),"
            "(218, 68425, 'MACARAVITA', ' ', ' ', '0'),"
            "(218, 68432, 'MALAGA', ' ', ' ', '0'),"
            "(218, 68444, 'MATANZA', ' ', ' ', '0'),"
            "(218, 68464, 'MOGOTES', ' ', ' ', '0'),"
            "(218, 68468, 'MOLAGAVITA', ' ', ' ', '0'),"
            "(218, 68498, 'OCAMONTE', ' ', ' ', '0'),"
            "(218, 68500, 'OIBA', ' ', ' ', '0'),"
            "(218, 68502, 'ONZAGA', ' ', ' ', '0'),"
            "(218, 68522, 'PALMAR', ' ', ' ', '0'),"
            "(218, 68524, 'PALMAS DEL SOCORRO', ' ', ' ', '0'),"
            "(218, 68533, 'PARAMO', ' ', ' ', '0'),"
            "(218, 68547, 'PIEDECUESTA', ' ', ' ', '0'),"
            "(218, 68549, 'PINCHOTE', ' ', ' ', '0'),"
            "(218, 68572, 'PUENTE NACIONAL', ' ', ' ', '0'),"
            "(218, 68573, 'PUERTO PARRA', ' ', ' ', '0'),"
            "(218, 68575, 'PUERTO WILCHES', ' ', ' ', '0'),"
            "(218, 68615, 'RIONEGRO', ' ', ' ', '0'),"
            "(218, 68655, 'SABANA DE TORRES', ' ', ' ', '0'),"
            "(218, 68669, 'SAN ANDRES', ' ', ' ', '0'),"
            "(218, 68673, 'SAN BENITO', ' ', ' ', '0'),"
            "(218, 68679, 'SAN GIL', ' ', ' ', '0'),"
            "(218, 68682, 'SAN JOAQUIN', ' ', ' ', '0'),"
            "(218, 68684, 'SAN JOSE DE MIRANDA', ' ', ' ', '0'),"
            "(218, 68686, 'SAN MIGUEL', ' ', ' ', '0'),"
            "(218, 68689, 'SAN VICENTE DE CHUCURI', ' ', ' ', '0'),"
            "(218, 68705, 'SANTA BARBARA', ' ', ' ', '0'),"
            "(218, 68720, 'SANTA HELENA DEL OPON', ' ', ' ', '0'),"
            "(218, 68745, 'SIMACOTA', ' ', ' ', '0'),"
            "(218, 68755, 'SOCORRO', ' ', ' ', '0'),"
            "(218, 68770, 'SUAITA', ' ', ' ', '0'),"
            "(218, 68773, 'SUCRE', ' ', ' ', '0'),"
            "(218, 68780, 'SURATA', ' ', ' ', '0'),"
            "(218, 68820, 'TONA', ' ', ' ', '0'),"
            "(218, 68855, 'VALLE DE SAN JOSE', ' ', ' ', '0'),"
            "(218, 68861, 'VELEZ', ' ', ' ', '0'),"
            "(218, 68867, 'VETAS', ' ', ' ', '0'),"
            "(218, 68872, 'VILLANUEVA', ' ', ' ', '0'),"
            "(218, 68895, 'ZAPATOCA', ' ', ' ', '0'),"
            "(218, 70001, 'SINCELEJO', ' ', ' ', '0'),"
            "(218, 70110, 'BUENAVISTA', ' ', ' ', '0'),"
            "(218, 70124, 'CAIMITO', ' ', ' ', '0'),"
            "(218, 70204, 'COLOSO', ' ', ' ', '0'),"
            "(218, 70215, 'COROZAL', ' ', ' ', '0'),"
            "(218, 70221, 'COVEÑAS', ' ', ' ', '0'),"
            "(218, 70230, 'CHALAN', ' ', ' ', '0'),"
            "(218, 70233, 'EL ROBLE', ' ', ' ', '0'),"
            "(218, 70235, 'GALERAS', ' ', ' ', '0'),"
            "(218, 70265, 'GUARANDA', ' ', ' ', '0'),"
            "(218, 70400, 'LA UNION', ' ', ' ', '0'),"
            "(218, 70418, 'LOS PALMITOS', ' ', ' ', '0'),"
            "(218, 70429, 'MAJAGUAL', ' ', ' ', '0'),"
            "(218, 70473, 'MORROA', ' ', ' ', '0'),"
            "(218, 70508, 'OVEJAS', ' ', ' ', '0'),"
            "(218, 70523, 'PALMITO', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 70670, 'SAMPUES', ' ', ' ', '0'),"
            "(218, 70678, 'SAN BENITO ABAD', ' ', ' ', '0'),"
            "(218, 70702, 'SAN JUAN DE BETULIA', ' ', ' ', '0'),"
            "(218, 70708, 'SAN MARCOS', ' ', ' ', '0'),"
            "(218, 70713, 'SAN ONOFRE', ' ', ' ', '0'),"
            "(218, 70717, 'SAN PEDRO', ' ', ' ', '0'),"
            "(218, 70742, 'SAN LUIS DE SINCE', ' ', ' ', '0'),"
            "(218, 70771, 'SUCRE', ' ', ' ', '0'),"
            "(218, 70820, 'SANTIAGO DE TOLU', ' ', ' ', '0'),"
            "(218, 70823, 'TOLU VIEJO', ' ', ' ', '0'),"
            "(218, 73001, 'IBAGUÉ', ' ', ' ', '0'),"
            "(218, 73024, 'ALPUJARRA', ' ', ' ', '0'),"
            "(218, 73026, 'ALVARADO', ' ', ' ', '0'),"
            "(218, 73030, 'AMBALEMA', ' ', ' ', '0'),"
            "(218, 73043, 'ANZOATEGUI', ' ', ' ', '0'),"
            "(218, 73055, 'ARMERO', ' ', ' ', '0'),"
            "(218, 73067, 'ATACO', ' ', ' ', '0'),"
            "(218, 73124, 'CAJAMARCA', ' ', ' ', '0'),"
            "(218, 73148, 'CARMEN DE APICALA', ' ', ' ', '0'),"
            "(218, 73152, 'CASABIANCA', ' ', ' ', '0'),"
            "(218, 73168, 'CHAPARRAL', ' ', ' ', '0'),"
            "(218, 73200, 'COELLO', ' ', ' ', '0'),"
            "(218, 73217, 'COYAIMA', ' ', ' ', '0'),"
            "(218, 73226, 'CUNDAY', ' ', ' ', '0'),"
            "(218, 73236, 'DOLORES', ' ', ' ', '0'),"
            "(218, 73268, 'ESPINAL', ' ', ' ', '0'),"
            "(218, 73270, 'FALAN', ' ', ' ', '0'),"
            "(218, 73275, 'FLANDES', ' ', ' ', '0'),"
            "(218, 73283, 'FRESNO', ' ', ' ', '0'),"
            "(218, 73319, 'GUAMO', ' ', ' ', '0'),"
            "(218, 73347, 'HERVEO', ' ', ' ', '0'),"
            "(218, 73349, 'HONDA', ' ', ' ', '0'),"
            "(218, 73352, 'ICONONZO', ' ', ' ', '0'),"
            "(218, 73408, 'LERIDA', ' ', ' ', '0'),"
            "(218, 73411, 'LIBANO', ' ', ' ', '0'),"
            "(218, 73443, 'MARIQUITA', ' ', ' ', '0'),"
            "(218, 73449, 'MELGAR', ' ', ' ', '0'),"
            "(218, 73461, 'MURILLO', ' ', ' ', '0'),"
            "(218, 73483, 'NATAGAIMA', ' ', ' ', '0'),"
            "(218, 73504, 'ORTEGA', ' ', ' ', '0'),"
            "(218, 73520, 'PALOCABILDO', ' ', ' ', '0'),"
            "(218, 73547, 'PIEDRAS', ' ', ' ', '0'),"
            "(218, 73555, 'PLANADAS', ' ', ' ', '0'),"
            "(218, 73563, 'PRADO', ' ', ' ', '0'),"
            "(218, 73585, 'PURIFICACION', ' ', ' ', '0'),"
            "(218, 73616, 'RIOBLANCO', ' ', ' ', '0'),"
            "(218, 73622, 'RONCESVALLES', ' ', ' ', '0'),"
            "(218, 73624, 'ROVIRA', ' ', ' ', '0'),"
            "(218, 73671, 'SALDAÑA', ' ', ' ', '0'),"
            "(218, 73675, 'SAN ANTONIO', ' ', ' ', '0'),"
            "(218, 73678, 'SAN LUIS', ' ', ' ', '0'),"
            "(218, 73686, 'SANTA ISABEL', ' ', ' ', '0'),"
            "(218, 73770, 'SUAREZ', ' ', ' ', '0'),"
            "(218, 73854, 'VALLE DE SAN JUAN', ' ', ' ', '0'),"
            "(218, 73861, 'VENADILLO', ' ', ' ', '0'),"
            "(218, 73870, 'VILLAHERMOSA', ' ', ' ', '0'),"
            "(218, 73873, 'VILLARRICA', ' ', ' ', '0'),"
            "(218, 76001, 'CALI', ' ', ' ', '0'),"
            "(218, 76020, 'ALCALA', ' ', ' ', '0'),"
            "(218, 76036, 'ANDALUCIA', ' ', ' ', '0'),"
            "(218, 76041, 'ANSERMANUEVO', ' ', ' ', '0'),"
            "(218, 76054, 'ARGELIA', ' ', ' ', '0'),"
            "(218, 76100, 'BOLIVAR', ' ', ' ', '0'),"
            "(218, 76109, 'BUENAVENTURA', ' ', ' ', '0'),"
            "(218, 76111, 'GUADALAJARA DE BUGA', ' ', ' ', '0'),"
            "(218, 76113, 'BUGALAGRANDE', ' ', ' ', '0'),"
            "(218, 76122, 'CAICEDONIA', ' ', ' ', '0'),"
            "(218, 76126, 'CALIMA', ' ', ' ', '0'),"
            "(218, 76130, 'CANDELARIA', ' ', ' ', '0'),"
            "(218, 76147, 'CARTAGO', ' ', ' ', '0'),"
            "(218, 76233, 'DAGUA', ' ', ' ', '0'),"
            "(218, 76243, 'EL AGUILA', ' ', ' ', '0'),"
            "(218, 76246, 'EL CAIRO', ' ', ' ', '0'),"
            "(218, 76248, 'EL CERRITO', ' ', ' ', '0'),"
            "(218, 76250, 'EL DOVIO', ' ', ' ', '0'),"
            "(218, 76275, 'FLORIDA', ' ', ' ', '0'),"
            "(218, 76306, 'GINEBRA', ' ', ' ', '0'),"
            "(218, 76318, 'GUACARI', ' ', ' ', '0'),"
            "(218, 76364, 'JAMUNDI', ' ', ' ', '0'),"
            "(218, 76377, 'LA CUMBRE', ' ', ' ', '0'),"
            "(218, 76400, 'LA UNION', ' ', ' ', '0'),"
            "(218, 76403, 'LA VICTORIA', ' ', ' ', '0'),"
            "(218, 76497, 'OBANDO', ' ', ' ', '0'),"
            "(218, 76520, 'PALMIRA', ' ', ' ', '0'),"
            "(218, 76563, 'PRADERA', ' ', ' ', '0'),"
            "(218, 76606, 'RESTREPO', ' ', ' ', '0'),"
            "(218, 76616, 'RIOFRIO', ' ', ' ', '0'),"
            "(218, 76622, 'ROLDANILLO', ' ', ' ', '0'),"
            "(218, 76670, 'SAN PEDRO', ' ', ' ', '0'),"
            "(218, 76736, 'SEVILLA', ' ', ' ', '0'),"
            "(218, 76823, 'TORO', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into g_registro (tabla, parametro0, descripcion, parametro1,  parametro2,  parametro3) values"
            "(218, 76828, 'TRUJILLO', ' ', ' ', '0'),"
            "(218, 76834, 'TULUA', ' ', ' ', '0'),"
            "(218, 76845, 'ULLOA', ' ', ' ', '0'),"
            "(218, 76863, 'VERSALLES', ' ', ' ', '0'),"
            "(218, 76869, 'VIJES', ' ', ' ', '0'),"
            "(218, 76890, 'YOTOCO', ' ', ' ', '0'),"
            "(218, 76892, 'YUMBO', ' ', ' ', '0'),"
            "(218, 76895, 'ZARZAL', ' ', ' ', '0'),"
            "(218, 81001, 'ARAUCA', ' ', ' ', '0'),"
            "(218, 81065, 'ARAUQUITA', ' ', ' ', '0'),"
            "(218, 81220, 'CRAVO NORTE', ' ', ' ', '0'),"
            "(218, 81300, 'FORTUL', ' ', ' ', '0'),"
            "(218, 81591, 'PUERTO RONDON', ' ', ' ', '0'),"
            "(218, 81736, 'SARAVENA', ' ', ' ', '0'),"
            "(218, 81794, 'TAME', ' ', ' ', '0'),"
            "(218, 85001, 'YOPAL', ' ', ' ', '0'),"
            "(218, 85010, 'AGUAZUL', ' ', ' ', '0'),"
            "(218, 85015, 'CHAMEZA', ' ', ' ', '0'),"
            "(218, 85125, 'HATO COROZAL', ' ', ' ', '0'),"
            "(218, 85136, 'LA SALINA', ' ', ' ', '0'),"
            "(218, 85139, 'MANI', ' ', ' ', '0'),"
            "(218, 85162, 'MONTERREY', ' ', ' ', '0'),"
            "(218, 85225, 'NUNCHIA', ' ', ' ', '0'),"
            "(218, 85230, 'OROCUE', ' ', ' ', '0'),"
            "(218, 85250, 'PAZ DE ARIPORO', ' ', ' ', '0'),"
            "(218, 85263, 'PORE', ' ', ' ', '0'),"
            "(218, 85279, 'RECETOR', ' ', ' ', '0'),"
            "(218, 85300, 'SABANALARGA', ' ', ' ', '0'),"
            "(218, 85315, 'SACAMA', ' ', ' ', '0'),"
            "(218, 85325, 'SAN LUIS DE PALENQUE', ' ', ' ', '0'),"
            "(218, 85400, 'TAMARA', ' ', ' ', '0'),"
            "(218, 85410, 'TAURAMENA', ' ', ' ', '0'),"
            "(218, 85430, 'TRINIDAD', ' ', ' ', '0'),"
            "(218, 85440, 'VILLANUEVA', ' ', ' ', '0'),"
            "(218, 86001, 'MOCOA', ' ', ' ', '0'),"
            "(218, 86219, 'COLON', ' ', ' ', '0'),"
            "(218, 86320, 'ORITO', ' ', ' ', '0'),"
            "(218, 86568, 'PUERTO ASIS', ' ', ' ', '0'),"
            "(218, 86569, 'PUERTO CAICEDO', ' ', ' ', '0'),"
            "(218, 86571, 'PUERTO GUZMAN', ' ', ' ', '0'),"
            "(218, 86573, 'LEGUIZAMO', ' ', ' ', '0'),"
            "(218, 86749, 'SIBUNDOY', ' ', ' ', '0'),"
            "(218, 86755, 'SAN FRANCISCO', ' ', ' ', '0'),"
            "(218, 86757, 'SAN MIGUEL', ' ', ' ', '0'),"
            "(218, 86760, 'SANTIAGO', ' ', ' ', '0'),"
            "(218, 86865, 'VALLE DEL GUAMUEZ', ' ', ' ', '0'),"
            "(218, 86885, 'VILLAGARZON', ' ', ' ', '0'),"
            "(218, 88001, 'SAN ANDRES', ' ', ' ', '0'),"
            "(218, 88564, 'PROVIDENCIA', ' ', ' ', '0'),"
            "(218, 91001, 'LETICIA', ' ', ' ', '0'),"
            "(218, 91263, 'EL ENCANTO', ' ', ' ', '0'),"
            "(218, 91405, 'LA CHORRERA', ' ', ' ', '0'),"
            "(218, 91407, 'LA PEDRERA', ' ', ' ', '0'),"
            "(218, 91430, 'LA VICTORIA', ' ', ' ', '0'),"
            "(218, 91460, 'MIRITI - PARANA', ' ', ' ', '0'),"
            "(218, 91530, 'PUERTO ALEGRIA', ' ', ' ', '0'),"
            "(218, 91536, 'PUERTO ARICA', ' ', ' ', '0'),"
            "(218, 91540, 'PUERTO NARIÑO', ' ', ' ', '0'),"
            "(218, 91669, 'PUERTO SANTANDER', ' ', ' ', '0'),"
            "(218, 91798, 'TARAPACA', ' ', ' ', '0'),"
            "(218, 94001, 'INIRIDA', ' ', ' ', '0'),"
            "(218, 94343, 'BARRANCO MINAS', ' ', ' ', '0'),"
            "(218, 94663, 'MAPIRIPANA', ' ', ' ', '0'),"
            "(218, 94883, 'SAN FELIPE', ' ', ' ', '0'),"
            "(218, 94884, 'PUERTO COLOMBIA', ' ', ' ', '0'),"
            "(218, 94885, 'LA GUADALUPE', ' ', ' ', '0'),"
            "(218, 94886, 'CACAHUAL', ' ', ' ', '0'),"
            "(218, 94887, 'PANA PANA', ' ', ' ', '0'),"
            "(218, 94888, 'MORICHAL', ' ', ' ', '0'),"
            "(218, 95001, 'SAN JOSE DEL GUAVIARE', ' ', ' ', '0'),"
            "(218, 95015, 'CALAMAR', ' ', ' ', '0'),"
            "(218, 95025, 'EL RETORNO', ' ', ' ', '0'),"
            "(218, 95200, 'MIRAFLORES', ' ', ' ', '0'),"
            "(218, 97001, 'MITU', ' ', ' ', '0'),"
            "(218, 97161, 'CARURU', ' ', ' ', '0'),"
            "(218, 97511, 'PACOA', ' ', ' ', '0'),"
            "(218, 97666, 'TARAIRA', ' ', ' ', '0'),"
            "(218, 97777, 'PAPUNAUA', ' ', ' ', '0'),"
            "(218, 97889, 'YAVARATE', ' ', ' ', '0'),"
            "(218, 99001, 'PUERTO CARREÑO', ' ', ' ', '0'),"
            "(218, 99524, 'LA PRIMAVERA', ' ', ' ', '0'),"
            "(218, 99624, 'SANTA ROSALIA', ' ', ' ', '0'),"
            "(218, 99773, 'CUMARIBO', ' ', ' ', '0'),"
            "(218, 99999, 'Pendiente', ' ', ' ', '0')"
          );

          await db.execute(
            "insert into concepto ( concepto, descripcion, grupo, parametro, unidad, redondeo ) values "
            "( 10000, 'Póliza'                    ,17,	4,	19 ,0),"
            "( 10001, 'Periodo póliza'            ,17,	4,	19 ,0),"
            "( 10002, 'Retroactividad'            ,17,	4,	20 ,0),"
            "( 10003, 'Fecha emisión póliza'      ,17,	4,	23 ,0),"
            "( 10004, 'Hora emisión póliza'       ,17,	4,	24 ,0),"
            "( 10005, 'Minutos emisión póliza'    ,17,	4,	25 ,0),"

            "( 10010, 'Comisión póliza'           ,17,	4,	29 ,0),"
            "( 10011, 'Cupo operativo'            ,17,	4,	27 ,0),"

            "( 10020, 'Valor contrato'            ,17,	4,	30 ,0),"
            "( 10021, 'Fecha inicio contrato'     ,17,	4,	23 ,0),"
            "( 10022, 'Fecha final contrato'      ,17,	4,	23 ,0),"

            "( 10050, 'Cumplimiento'              ,18,	4,	19 ,0),"  // amparo.concepto
            "( 10051, 'Calidad'                   ,18,	4,	19 ,0),"
            "( 10052, 'Anticipo'                  ,18,	4,	19 ,0),"
            "( 10053, 'Salararios'                ,18,	4,	19 ,0),"
            "( 10054, 'Sociales e indemnizaciones',18,	4,	19 ,0),"
            "( 10055, 'Estabilidad de obra'       ,18,	4,	19 ,0),"
            "( 10056, 'Calidad del bien'          ,18,	4,	19 ,0),"
            "( 10057, 'Calidad del servicio'      ,18,	4,	19 ,0),"
            "( 10058, 'Provisión de repuestos'    ,18,	4,	19 ,0),"

            "( 10099, 'Amparo actual'             ,17,	4,	22 ,0),"
            "( 10100, 'Periodo amparo'            ,17,	4,	22 ,0),"
            "( 10101, 'Tasa amparo'               ,17, 16,	29 ,0),"
            "( 10102, 'Porcentaje asegurable'     ,17, 14,	29 ,0),"
            "( 10103, 'Tasa I.V.A'                ,17,	4,	29 ,0),"

            "( 10200, 'Fecha inicial amparo'      ,17,	5,	23 ,0),"
            "( 10201, 'Hora inicial amparo'       ,17,	4,	24 ,0),"
            "( 10202, 'Minutos inicial amparo'    ,17,	4,	25 ,0),"
            "( 10205, 'Fecha final amparo'        ,17,	6,	23 ,0),"
            "( 10206, 'Hora final amparo'         ,17,	4,	24 ,0),"
            "( 10207, 'Minutos final amparo'      ,17,	4,	25 ,0),"
            "( 10210, 'Días amparo'               ,17,	7,	20 ,0),"
            "( 10211, 'Prorrata'                  ,17,	7,	20 ,0),"
            "( 10212, 'Prima anual'               ,17,	7,	20 ,0),"

            "( 10300, 'Valor asegurado'           ,17, 15,	27 ,0),"
            "( 10301, 'Prima'                     ,17, 32,	27 ,0),"
            "( 10390 ,'Sumatoria asegurado'       ,17,  4,  27 ,0),"
            "( 10391 ,'Sumatoria prima'           ,17,  4,  27 ,0),"

            "( 10400, 'Comisión normal'           ,17,	4,	27 ,0),"
            "( 10401, 'Comisión adicional'        ,17,	4,	27 ,0),"
            "( 10402, 'Descuento'                 ,17,  4,	27 ,0),"
            "( 10403, 'Recargos'                  ,17,	4,	27 ,0),"
            "( 10404, 'Gastos de emisión'         ,17,	4,  27 ,0),"
            "( 10405, 'Gastos administración tomador',17,	4, 27,0),"
            "( 10410, 'I.V.A'                     ,17,	4,  27, 0) "
          );

          await db.execute(
            " insert into clase ( clase, descripcion, sinonimo, observacion, tipo, documento ) values "

            "( 10000, 'Poliza',		              10000,' ', 45, 0 ),"
            "( 10001, 'Fecha inicial amparo',   10001,' ', 45, 0 ),"
            "( 10002, 'Fecha final amparo',	    10002,' ', 45, 0 ),"
            "( 10003, 'Datos amparo',	          10003,' ', 45, 0 ),"
            "( 10004, 'Liquidación global',	    10004,' ', 45, 0 ),"

            "( 10090, 'Interactivo',            10090,' ', 45, 0 ),"

            "( 10100, 'Prestación de servicios',10100,' ', 46, 0 ),"//  poliza.objeto
            "( 10101, 'Suministro',             10101,' ', 46, 0 ),"
            "( 10102, 'Consultoría',            10102,' ', 46, 0 ),"
            "( 10103, 'Interventoría',          10103,' ', 46, 0 ),"
            "( 10104, 'Obra',                   10104,' ', 46, 0 ),"
            "( 10105, 'Seriedad Oferta',        10105,' ', 46, 0 ) "
          );

          await db.execute (
            "insert into formula ( clase, orden, concepto, debito, credito, contador, cantidad, sentencia, indicador ) values "

//            "( 10001 ,1 ,10200 ,'[F][000]C021-C002',' ',' ',10000 ,''  ,35 ),"
            "( 10001 ,1 ,10200 ,'[F][004]C021'    ,' ',' ' ,10000 ,'' ,35 ),"
            "( 10001 ,2 ,10201 ,'C004'            ,' ',' ' ,10000 ,'' ,35 ),"
            "( 10001 ,3 ,10202 ,'C005'	          ,' ',' ' ,10000 ,'' ,35 ),"

            "( 10002 ,1 ,10205 ,'[F][001]C200+C100',' ',' ',10000 ,'' ,35 ),"
            "( 10002 ,2 ,10206 ,'C004'	         ,' ' ,' ' ,10000 ,'' ,35 ),"
            "( 10002 ,3 ,10207 ,'C005'	         ,' ' ,' ' ,10000 ,'' ,35 ),"
            "( 10002 ,4 ,10210 ,'[F][003]C205-C200',' ',' ',10000 ,'' ,35 ),"

            "( 10003 ,1 ,10300 ,'C020*C102'	     ,' ' ,'0' ,10000 ,'' ,35 )," // valorAsegurado = valorContrato * %asegurable
            "( 10003 ,2 ,10211 ,'C210/C365'      ,' ' ,'1' ,10101 ,'' ,35 )," // prorrata       = diasAmparo/365
            "( 10003 ,3 ,10212 ,'C300*C101'	     ,' ' ,'1' ,10101 ,'' ,35 )," // primaAnual     = valorAsegurado*tasaAmpararo
            "( 10003 ,4 ,10301 ,'C211*C212'	     ,' ' ,'1' ,10101 ,'' ,35 )," // prima          = prorrata*primaAnual
            "( 10003 ,5 ,10390 ,' '              ,' ' ,'0' ,10000 ,'' ,38 ),"
            "( 10003 ,6 ,10391 ,' '              ,' ' ,'1' ,10000 ,'' ,38 ),"

            "( 10004 ,1	,10400 ,'C391*C010'      ,' ' ,' ' ,10000 ,'' ,36 ),"
            "( 10004 ,2	,10401 ,'C391*C010'      ,' ' ,' ' ,10000 ,'' ,39 ),"
            "( 10004 ,3	,10402 ,'0'              ,' ' ,' ' ,10000 ,'' ,39 ),"
            "( 10004 ,4	,10403 ,'0'              ,' ' ,' ' ,10000 ,'' ,39 ),"
            "( 10004 ,5	,10404 ,'0'              ,' ' ,' ' ,10000 ,'' ,39 ),"
            "( 10004 ,6	,10405 ,'0'              ,' ' ,' ' ,10000 ,'' ,39 ),"
            "( 10004 ,7	,10410 ,'C391*C103'      ,' ' ,' ' ,10000 ,'' ,36 ),"

            "( 10100 ,1	,10050 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10100 ,2	,10051 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10100 ,3	,10000 ,'[C]10004'            ,' ' ,' ' ,10000 ,' ',35 ),"

            "(10101, 1, 10050, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "(10101, 2, 10057, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "(10101, 3, 10054, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "(10101, 4, 10000, '[C]10004'            , ' ' ,' ',10000 ,'' ,35 ),"

            "( 10102 ,1	,10050 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10102 ,2	,10051 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10102 ,3	,10000 ,'[C]10004'            ,' ' ,' ' ,10000 ,' ',35 ),"

            "( 10103 ,1	,10050 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10103 ,2	,10051 ,'[C]10001,10002,10003',' ' ,' ' ,10102 ,'' ,36 ),"
            "( 10103 ,3	,10000 ,'[C]10004'            ,' ' ,' ' ,10000 ,' ',35 ),"

            "( 10104, 1, 10050, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10104, 2, 10052, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10104, 3, 10055, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10104, 4, 10000, '[C]10004'            , ' ' ,' ',10102 ,'' ,35 ),"

            "( 10105, 1, 10050, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10105, 2, 10053, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10105, 3, 10058, '[C]10001,10002,10003', ' ' ,' ',10102 ,'' ,36 ),"
            "( 10105, 4, 10000, '[C]10004'            , ' ' ,' ',10102 ,'' ,35 ),"

            "( 10090 ,1	,10000 ,'[C]10001,10002,10004',' ' ,' ' ,10000 ,'' ,35 ) "
          );

          await db.execute (
            "insert into valor ( clase, orden, concepto, minimo, maximo, valor ) values"

            "(10004 ,1 ,10103 ,0 ,0     ,0.19 ),"

            "(10100 ,1 ,10100 ,10050 ,0 ,1	  ),"
            "(10100 ,2 ,10101 ,10050 ,0 ,0.1  ),"
            "(10100 ,3 ,10102 ,10050 ,0 ,0.15 ),"
            "(10100 ,4 ,10100 ,10051 ,0 ,1	  ),"
            "(10100 ,5 ,10101 ,10051 ,0 ,0.1  ),"
            "(10100 ,6 ,10102 ,10051 ,0 ,0.15 ),"

            "(10101, 1, 10100, 10050 ,0 ,1	  ),"
            "(10101, 2, 10101, 10050 ,0 ,0.15 ),"
            "(10101, 3, 10102, 10050 ,0 ,0.1  ),"
            "(10101, 4, 10100, 10057 ,0 ,1	  ),"
            "(10101, 5, 10101, 10057 ,0 ,0.15 ),"
            "(10101, 6, 10102, 10057 ,0 ,0.3  ),"
            "(10101, 7, 10100, 10054 ,0 ,3	  ),"
            "(10101, 8, 10101, 10054 ,0 ,0.13 ),"
            "(10101, 9, 10102, 10054 ,0 ,0.05 ),"

            "(10102 ,1 ,10100 ,10050 ,0 ,1	  ),"
            "(10102 ,2 ,10101 ,10050 ,0 ,0.1  ),"
            "(10102 ,3 ,10102 ,10050 ,0 ,0.15 ),"
            "(10102 ,4 ,10100 ,10051 ,0 ,1	  ),"
            "(10102 ,5 ,10101 ,10051 ,0 ,0.1  ),"
            "(10102 ,6 ,10102 ,10051 ,0 ,0.15 ),"

            "(10103 ,1 ,10100 ,10050 ,0 ,1	  ),"
            "(10103 ,2 ,10101 ,10050 ,0 ,0.1  ),"
            "(10103 ,3 ,10102 ,10050 ,0 ,0.15 ),"
            "(10103 ,4 ,10100 ,10051 ,0 ,1	  ),"
            "(10103 ,5 ,10101 ,10051 ,0 ,0.1  ),"
            "(10103 ,6 ,10102 ,10051 ,0 ,0.15 ),"

            "(10104, 1, 10100, 10050 ,0 ,1	  ),"
            "(10104, 2, 10101, 10050 ,0 ,0.15 ),"
            "(10104, 3, 10102, 10050 ,0 ,0.1  ),"
            "(10104, 4, 10100, 10052 ,0 ,1	  ),"
            "(10104, 5, 10101, 10052 ,0 ,0.15 ),"
            "(10104, 6, 10102, 10052 ,0 ,0.3  ),"
            "(10104, 7, 10100, 10055 ,0 ,5	  ),"
            "(10104, 8, 10101, 10055 ,0 ,0.15 ),"
            "(10104, 9, 10102, 10055 ,0 ,0.2  ),"

            "(10105, 1, 10100, 10050 ,0 ,1	  ),"
            "(10105, 2, 10101, 10050 ,0 ,0.15 ),"
            "(10105, 3, 10102, 10050 ,0 ,0.1  ),"
            "(10105, 4, 10100, 10053 ,0 ,3	  ),"
            "(10105, 5, 10101, 10053 ,0 ,0.15 ),"
            "(10105, 6, 10102, 10053 ,0 ,0.1  ),"
            "(10105, 7, 10100, 10058 ,0 ,1	  ),"
            "(10105, 8, 10101, 10058 ,0 ,0.15 ),"
            "(10105, 9, 10102, 10058 ,0 ,0.2  ) "
          );

          await db.execute(
            "insert into g_accion ( fecha, agenda, categoria, usuario, sincronizar, interno, descripcion, titulo,subtitulo, detalle, seguimiento, procedencia, posicion ) values"

            "( '2019-02-27', 4,     23, 'ocobo',           0,       1,  'kiko','Guillermo Cárdenas','Proceso','Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     24, 'ocobo',           0,       1,  'Oki', 'Esteban Chavez'    ,'Arreglo','Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     25, 'ocobo',           0,       1,  'Asi', 'Patricia Neron'    ,'Visita', 'Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     23, 'ocobo',           0,       1,  'kiko','Pepe Cárdenas'     ,'Proceso','Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     24, 'ocobo',           0,       1,  'Oki', 'Javier Vasquez'    ,'Arreglo','Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     24, 'ocobo',           0,       1,  'Oki', 'Julian Hozi'       ,'Proceso','Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     22, 'ocobo',           0,       1,  'Oki', 'Alo Beza'          ,'Visita', 'Prueba', 16,                 0,      'xy' ),"
            "( '2019-02-27', 4,     26, 'ocobo',           0,       1,  'Asi', 'Olga Perdomo'      ,'Proceso','Prueba', 16,                 0,      'xy' ) "
          );

/*
        await db.execute(
         "insert into g_auxiliar ( clasificacion, tipo, identificacion, fecha, password, token, primerNombre, segundoNombre, primerApellido, segundoApellido, favorito, genero, foto, nacimiento, lugar, direccion, municipio, movil, fijo, correo, sincronizar) values"
         "(0, 0, 93404434,  '2019-02-27 14:45:59','1','****','José','Ricardo','Peñaloza','Franco','JOSÉ',27,'assets/person.jpg','2019-02-27 14:45:59',41,'Cerro Azul Del Vergel Casa 61',41,'3102535260','','jrpf@hotmail.com',1) "
        );

        await db.execute(
         "insert into poliza ( sede, tomador_principal, cupo_operativo, comision, numero, temporario, fecha_emision, "
         "periodo, objeto, tipo_movimiento, tipo_poliza, retroactividad, periodo_emision, fecha_hora_inicial, fecha_hora_final, "
         "numeroContrato, valor_contrato, fecha_inicial, fecha_final, sincronizar ) values"
         "( 1, 1, 200000, 10, 123, 123, '2019-02-27 14:45:00', "
         "1, 72, 65, 22, 21, 1, '2019-02-27 14:45:00', '2020-02-27 14:45:00', "
         "'1134-79OC', 72000000, '2019-02-27 14:45:00', '2022-02-27 14:45:00',0 )"
        );

        await db.execute(
         "insert into amparo ( amparo ,orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,tasa ,base ,tarifa ,valor ) values"
         "( 1, 1, 1, 10050, 356, '2019-02-27 14:45:00', '2020-02-27 14:45:00', 10, 20000000, 15, 300000 ),"
         "( 2, 2, 1, 10051, 356, '2019-02-27 14:45:00', '2020-02-27 14:45:00', 10, 20000000,  5, 100000 ),"
         "( 3, 3, 1, 10052, 712, '2019-02-27 14:45:00', '2021-02-27 14:45:00', 30, 32000000, 12, 105600 ) "
        );
*/
          print('Inserción datos...');

          await db.execute(

            "create view v_anexo as "
            "select nx.anexo, nx.categoria, nx.interno, nx.documento, cl.descripcion "
            "from anexo nx, g_registro cl "
            "where nx.categoria = cl.registro "
          );

          await db.execute(

            "create view v_amparo as "
            "select mp.amparo, mp.orden, mp.poliza, mp.concepto, mp.dias, mp.fechaInicial, mp.fechaFinal, "
            "mp.porcentaje, mp.valorAsegurado, mp.tasaAmparo, mp.prima, cn.descripcion "
            "from amparo mp, concepto cn "
            "where mp.concepto = cn.concepto "
          );

          await db.execute(
            "create view v_poliza as "
            "select pl.poliza, pl.sede, pl.fechaEmision, pl.periodo, pl.numero, pl.temporario, pl.estado, "
            "pl.intermediario, pl.comision, pl.cupoOperativo, "
            "pl.afianzado, pl.tipoPoliza, pl.clausulado, "
            "pl.periodoEmision, pl.retroactividad, pl.fechaHoraInicial, pl.fechaHoraFinal, "
            "pl.contratante, pl.objeto, pl.numeroContrato, pl.valorContrato, "
            "pl.fechaInicial, pl.fechaFinal, pl.sincronizar, "
            "xl.primerNombre||' '||xl.primerApellido as nombre, cl.descripcion as descripcion "
            "from poliza pl, g_auxiliar xl, clase cl "
            "where pl.afianzado = xl.auxiliar and pl.objeto = cl.clase "
          );
/*
         await db.execute(
             "create view v_auxiliar as "
                 "select au.auxiliar, au.clasificacion, cl.descripcion as descClasificacion, au.tipo, tp.descripcion as descTipo, au.identificacion, au.fecha, au.password, "
                 "au.token, au.primerNombre, au.segundoNombre, au.primerApellido, au.segundoApellido,"
                 "au.favorito, au.foto, au.nacimiento, au.lugar, lg.descripcion as descLugar, au.genero, ge.descripcion as descGenero, au.estadoCivil, ec.descripcion as descEstadoCivil, au.direccion,"
                 "au.municipio, mn.descripcion as descMunicipio, au.movil, au.fijo, au.correo, au.documento, au.sincronizar"
                 "from g_auxiliar au, g_registro cl, g_registro tp, g_registro ge, g_registro ec, g_registro lg, g_registro mn"
                 "where au.clasificacion = cl.registro and "
                 "au.tipo = tp.registro and"
                 "au.genero = ge.registro and"
                 "au.estadoCivil = ec.registro and"
                 "au.lugar = lg.registro and"
                 "au.municipio = mn.registro"

                 //Falta incluir la descripción de los campos parametricos

                 //"where pl.afianzado = xl.auxiliar and pl.objeto = cl.clase "
         );
*/
          print('Creación vistas...');

        });
  }

  newAuxiliar(Auxiliar registro) async {

    final db = await database;
//  auxiliar, clasificacion, tipo, fecha, password, token, primerNombre, segundoNombre, primerApellido, segundoApellido, favorito, genero,
//  foto, nacimiento, lugar, direccion, municipio, movil, fijo, correo, sincronizar
    var crud = await db.rawInsert (
      "insert into g_auxiliar ( clasificacion, tipo, identificacion, fecha, password, token, primerNombre, segundoNombre, primerApellido, "
       "segundoApellido, favorito, foto, nacimiento, lugar, genero, estadoCivil, direccion, municipio, movil, fijo, correo, documento, sincronizar) "
       "values( ?, ?, ?, julianday('now'), 'password', 'token', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )",
        [
          registro.clasificacion,
          registro.tipo,
          registro.identificacion,
          registro.primerNombre,
          registro.segundoNombre,
          registro.primerApellido,
          registro.segundoApellido,
          registro.favorito,

          registro.foto,
          registro.nacimiento,
          registro.lugar,
          registro.genero,
          registro.estadoCivil,

          registro.direccion,
          registro.municipio,
          registro.movil,
          registro.fijo,
          registro.correo,
          registro.documento,
          0
        ]
    );   // newAuxiliar.sincronizar

    var consulta = await db.rawQuery("select max(auxiliar) as id from g_auxiliar");
    int id = consulta.first["id"];
    print('Último auxiliar: '+id.toString());

    return crud;
  }

  updateAuxiliar(Auxiliar registro) async {
    final db = await database;

    Auxiliar sincronizar = Auxiliar(
        clasificacion: registro.clasificacion,
        tipo: registro.tipo,

        auxiliar : registro.auxiliar,
        identificacion: registro.identificacion,
        primerNombre: registro.primerNombre,
        segundoNombre: registro.segundoNombre,
        primerApellido: registro.primerApellido,
        segundoApellido: registro.segundoApellido,
        favorito: registro.favorito,

        foto: registro.foto,
        nacimiento: registro.nacimiento,
        lugar: registro.lugar,
        genero: registro.genero,
        estadoCivil: registro.estadoCivil,

        direccion: registro.direccion,
        municipio: registro.municipio,
        movil: registro.movil,
        fijo: registro.fijo,
        correo: registro.correo,
        documento: registro.documento
//        sincronizar: !registro.sincronizar
    );

    print('Foto 2 <-- '+registro.foto.toString() );

    var crud = await db.update("g_auxiliar", sincronizar.toMap(),
        where: "auxiliar = ?", whereArgs: [registro.auxiliar]);
    return crud;

    // Falta actualizar lo de ROL, cuando pase lo de los combos
  }

  blockOrUnblock(Auxiliar registro) async {

    final db = await database;

    String sentencia="0";
    if (!registro.sincronizar)
      sentencia="1";

    sentencia="update g_auxiliar set sincronizar="+sentencia+
      " where auxiliar = "+registro.auxiliar.toString();
    print(sentencia);

    var crud = await db.execute(sentencia);
    return crud;
  }

  deleteAuxiliar(int id) async {

    final db = await database;

    db.delete("g_auxiliar", where: "auxiliar = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from g_auxiliar");
  }

  getAuxiliar(int id) async {
    final db = await database;
    var consulta = await db.query("g_auxiliar", where: "auxiliar = ?", whereArgs: [id]);
    return consulta.isNotEmpty ? Auxiliar.fromMap(consulta.first) : null;
  }

  //TODO crear una vista de g_auxiliar para traer las descripciones
  Future<List<Auxiliar>> getAllAuxiliar() async {
    final db = await database;
    var consulta = await db.query("g_auxiliar order by tipo, auxiliar");
    List<Auxiliar> list =
    consulta.isNotEmpty ? consulta.map((c) => Auxiliar.fromMap(c)).toList() : [];
    return list;
  }

  getPassword(String id) async {

    final db = await database;

    print('Login 0: '+id);
    var consulta = await db.rawQuery( "select count(*)as id from g_auxiliar where "+id);
    resultado = consulta.first["id"];
    print('Login 1: '+resultado.toString());
    return resultado;
  }

  Future<int> getValidarAuxiliar(String id) async {

    final db = await database;
    print('Validar Auxiliar: '+id);
    var consulta = await db.rawQuery( "select count(*)as id from g_auxiliar where "+id);
    return consulta.first["id"];
  }

}

class AuxiliarBloc {
  // new separate

  AuxiliarBloc() {
    getAuxiliar();
  }

  final _auxiliarController = StreamController<List<Auxiliar>>.broadcast();
  get auxiliares => _auxiliarController.stream;

  add(Auxiliar client) {
    DBProvider.db.newAuxiliar(client);
    getAuxiliar();
  }

  update(Auxiliar client) {
    DBProvider.db.updateAuxiliar(client);
    getAuxiliar();
  }

  delete(int id) {
    DBProvider.db.deleteAuxiliar(id);
    getAuxiliar();
  }

  dispose() {
    _auxiliarController.close();
  }

  getAuxiliar() async {
    _auxiliarController.sink.add(await DBProvider.db.getAllAuxiliar());
  }

  blockUnblock(Auxiliar client) {
    DBProvider.db.blockOrUnblock(client);
    getAuxiliar();
  }

  getPassword(String id) async {

    DBProvider.db.getPassword(id);
    print('Login 2: '+resultado.toString());
    return resultado;
  }

  Future<int> getValidarAuxiliar( String id ) async {
    final int resultado = await DBProvider.db.getValidarAuxiliar(id);
    print('Resultado: '+resultado.toString() );
    return resultado;
  }

}
