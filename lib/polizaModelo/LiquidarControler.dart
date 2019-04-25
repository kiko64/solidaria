import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:emision/polizaModelo/DatosModel.dart';

class DBLiquidador {

  static Database _database;
  static Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initLiquidadorDB();       // if _database is null we instantiate it
    return _database;
  }

  static initLiquidadorDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Solidaria.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    );
  }

  static List<String> args       = [ '' ,'' ,'' ,'' ,'' ,'11000', '', '', '', '' ]; // Argumentos a trabajar
  static List<double> valores   =  List(999);
  static List<int>    parametros = List(999);
  static List<int>    contadores = List(10);

  static double valorDB;
  static double valorCR;

  static int orden = 1;
  static String sentencia='';
  static int conceptoPrincipal = 0;


  static quitarPunto( String cadena, String buscar ) {
    if (cadena.indexOf(buscar)!=-1)
      return cadena.substring(0, cadena.indexOf(buscar));
    else return cadena;
  }

  static String remplazar( String cadena, String buscar ) {

    String find = '&'+buscar;
    int i = 0;
    int j = 0;
    while( cadena.indexOf( find ) !=- 1 ) {
      i=cadena.indexOf( find );
      j=int.parse(cadena.substring(i+2,i+5));
      switch( buscar ) { // Sumarle o restarle dias a una fecha
        case 'V' :
          { cadena=cadena.substring(0,i) + valores[j].toString() + cadena.substring(i+5,cadena.length ); break; }
        case 'A' :
          { cadena=cadena.substring(0,i) + args[j].toString() + cadena.substring(i+5,cadena.length ); break; }
      }
    }
    return cadena;
  }

  static trace( String clase ) {
    print('Clase: ' + clase + ', i --> conceptos[i] --> valores[ conceptos[i] ]');
    for (int i=0; i<99; i++) 											// coceptos en cero
      if ( parametros[i]!=0 ) print( i.toString() + ' --> ' +parametros[i].toString() + ' --> ' + valores[ parametros[i] ].toString() );

    print('Clase: ' + clase + ', i --> valores[i]');
    for (int j=0; j<999	; j++)
      if ( valores[j] != 0 ) print( j.toString() + ' --> ' + valores[j].toString() );
  }

  static inicializarArreglo() {                            // Inicializar el array
    for (int i = 0; i < 10;  i++) { contadores[i] = 0; }   // Contadores en cero
    for (int i = 0; i < 999; i++) { parametros[i] = 0; }   // parametros en cero
    for (int i = 0; i < 999; i++) { valores[i]    = 0; }   // valores en cero
  }


  static ejecutar( int concepto, String comando ) async {
//   'amparo ,orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,tasa ,base ,tarifa ,valor ,tarifa0 ,valor0

    trace( args[6]) ;

    if ( comando.trim().length == 0 ) {
      if ( concepto >= 10050 && concepto <= 10059 ) {
        sentencia =
            'insert into amparo ( orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,porcentaje ,valorAsegurado ,tasaAmparo ,prima ) values (' +
                orden.toString() + ', ' +                                                   // orden
                args[1] + ', ' +                                                            // poliza
                concepto.toString() + ', ' +                                                // concepto
                valores[parametros[72]].toString() + ', ' +                                 // dias

                "'" + valores[parametros[70]].toString().substring(0 , 4) +                 // Año
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0') +  // Mes
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +  // Día
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0')+ ':' +      // Horas
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0')+ ':00' +          // Minutos
                "', " +                                                                     // => fechaInicial
                "'" + valores[parametros[71]].toString().substring(0 , 4) +                 // Año
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0') +  // Mes
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +  // Día
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0')+ ':' +      // Horas
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0')+ ':00' +          // Minutos y segundos
                "', " +                                                                     // => fechaFinal

                valores[parametros[79]].toString() + ', ' +                                 // pordentajeAsegurado
                valores[parametros[80]].round().toString() + ', ' +                         // valorAsegurable
                valores[parametros[81]].toString() + ', ' +                                 // tasaAmparo
                valores[parametros[82]].round().toString() + ' )';                          // prima , 0, 0
      }
      else
      if ( concepto >= 10400 && concepto <= 10408 ) {
        sentencia =
            'insert into amparo ( orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,porcentaje ,valorAsegurado ,tasaAmparo ,prima ) values (' +
                orden.toString() + ', ' +                                                   // orden
                args[1] + ', ' +                                                            // poliza
                concepto.toString() + ', ' +                                                // concepto
                valores[parametros[72]].toString() + ', ' + // dias
                "'" + valores[parametros[70]].toString().substring(0 , 4) +
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0') +
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0') + ':' +
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0') + ':00' +
                "', " +                                                                     // fechaInicial
                "'" + valores[parametros[71]].toString().substring(0 , 4) +
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0')+
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0') + ':' +
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0') + ':00' +
                "', " +                                                                     // fechaFinal
                '0, ' +                                                                     // tasa
                '0, ' +                                                                     // base
                valores[10].toString() + ', ' +                                             // tarifa
                valores[400].round().toString() + ' )';                                     // valor , 0, 0

      }
      else {
        sentencia =
            'insert into amparo ( orden ,poliza ,concepto ,dias ,fechaInicial ,fechaFinal ,porcentaje ,valorAsegurado ,tasaAmparo ,prima ) values (' +

                orden.toString() + ', ' +                                                   // orden
                args[1] + ', ' +                                                            // poliza
                concepto.toString() + ', ' +                                                // concepto
                valores[parametros[72]].toString() + ', ' +                                 // dias
                "'" + valores[parametros[70]].toString().substring(0 , 4) +
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0') +
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0') + ':' +
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0') + ':00' +
                "', " +                                                                   // fechaInicial
                "'" + valores[parametros[71]].toString().substring(0 , 4) +
                '-' + valores[parametros[71]].toString().substring(4 , 6).padLeft(2,'0') +
                '-' + valores[parametros[71]].toString().substring(6 , 8).padLeft(2,'0') +
                ' ' + quitarPunto(valores[201].toString() , '.').padLeft(2,'0') + ':' +
                quitarPunto(valores[202].toString() , '.').padLeft(2,'0') + ':00' +
                "', " +                                                                   // fechaFinal
                '19, ' +                                                                  // porcentaje
                '0, ' +                                                                   // valorAsegurado
                '0, ' +                                                                   // tasaAmparo
                valores[410].round().toString() + ' )';                                   // prima , 0, 0
      }

    }
    else {
      sentencia = remplazar ( comando,   'A' );
      sentencia = remplazar ( sentencia, 'V' );
    }

    print('insertar: ' + sentencia);

    final db = await database;
    var crud = await db.execute(sentencia);

    orden++;
    args[6] = orden.toString();
  }


  static cargarParametros(String sentencia) async {

//    print ('cargarParametros: '+sentencia);  // trace

    final db = await database;
    var consultaP = await db.rawQuery(sentencia);                // Crear Cursor para sacar los Datos básicos
    try {
      for (int i = 0; i < consultaP.length; i++) {
        Parametro rs = Parametro.map(consultaP[i]);
        int indice = rs.concepto - int.parse(args[5]);          // Concepto 11003 --> 003 --> 3
        parametros[int.parse(rs.parametro)] = indice;
      }
    } on DatabaseException catch (e) { print('native_error: $e'); }
  }

  static cargarContadores( String sentencia ) async {

//    print ('cargarContadores: '+sentencia);  // trace

    final db = await database;
    var consultaC = await db.rawQuery( sentencia );            // Crear Cursor para Grabar los Datos básicos
    try {
      for (int i = 0; i < consultaC.length; i++) {
        Contador rs = Contador.map(consultaC[i]);
        int indice = rs.concepto - int.parse(args[5]);        // Concepto 10003 --> 003 --> 3
        contadores[int.parse(rs.contador)]=indice;
      }
    } on DatabaseException catch (e) { print('native_error: $e'); }
  }

  static cargarValores(String sentencia) async {

//    print ('cargarValores: '+sentencia);  // trace

    final db = await database;
    var consultaV = await db.rawQuery(sentencia);
    try {
      for (int i = 0; i < consultaV.length; i++) {
        Valor rs = Valor.map(consultaV[i]);

        int indice = rs.concepto - int.parse(args[5]);
//        String --> valores[indice]=double.parse(rs.valor);                 // Carga Valor PARTIDA SIMPLE
//        int --> valores[indice]=rs.valor.toDouble();
//        double --> valores[indice]=rs.valor;
        valores[indice]=rs.valor;
      }
    } on DatabaseException catch (e) { print('native_error: $e') ; }
  }

  static double operacion(String formula, String clase ) {                       // Resolver_operación_aritmetica simple
    int i = 0;
    int j = 0;
    String n1;
    String n2;
    String simbolo;

    while( formula.indexOf('C') !=- 1 ) {                  // ejemplo.Formula.this.datos[j] OJO OJO
      i=formula.indexOf('C');
      j=int.parse(formula.substring(i+1,i+4));

      formula=formula.substring(0,i) + valores[j].toString() + formula.substring(i+4,formula.length );
    }

    print(clase+' operación: '+ formula+' ==>> ');

    if ( i <= 0 )
      return double.parse(formula);                       // Solo viene el valor
    else
    if ( simbolo == '/' && n2 == '0' ) return 0;          // División por cero

    n1 = formula.substring(0 , i - 1);
    simbolo = formula.substring(i - 1 , i);
    n2 = formula.substring(i , formula.length);

    switch( simbolo) {
      case '/' : { return double.parse(n1)/double.parse(n2); }
      case '*' : { return double.parse(n1)*double.parse(n2); }
      case '+' : { return double.parse(n1)+double.parse(n2); }
      case '-' : { return double.parse(n1)-double.parse(n2); }
//    case '^' : { return Math.pow(double.parse(n1),double.parse(n2)) ;}
      default  : { return  0 ;}
    }
  }

  static double funcion( String formula, String clase, int concepto ) {   // Resolver_funciones de fechas simple
    int i = 0;
    int j = 0;
    String n1;
    String n2;
    String simbolo;

    String funcion = formula.substring(1,4);                // 000 <- [000]C002-C049
    formula = formula.substring(5,formula.length );         // C002-C049

    while( formula.indexOf('C') !=- 1 ) {                   // 20190429-21
      i=formula.indexOf('C');
      j=int.parse(formula.substring(i+1,i+4));

      formula=formula.substring(0,i) + valores[j].toString() + formula.substring(i+4,formula.length );
    }

    if ( i!=0 ) {                                                   // Dos parametros
      n1 = quitarPunto(formula.substring(0 , i - 1) , '.');         // 20190429
      simbolo = quitarPunto(formula.substring(i - 1 , i) , '.');    // -
      n2 = quitarPunto(formula.substring(i , formula.length) , '.');// 21
    }
    else {                                                          // Un solo parametro
      n1 = quitarPunto(formula , '.');                              // 20190429
      simbolo = '+'; // -
      n2 = '0'; // 21
    }
    switch( funcion ) {                                                     // Sumarle o restarle dias a una fecha
      case '000' : {
        var fecha     = DateTime.parse(n1.substring(0,8)+' 00:00:00Z');     // fecha <-- 20190429
        var resultado = fecha.add(Duration(days: int.parse(n2) ) );         // Sumarle o restarle los días a la fecha
        String fechaInt ="${resultado.year.toString()}${resultado.month.toString().padLeft(2,'0')}${resultado.day.toString().padLeft(2,'0')}";

        print(clase+' función: ['+funcion+']'+formula+') ==>> '+fechaInt.toString() );
        return double.parse(fechaInt);
      }
      case '001' : {                                                        // fechaFinalAmparo = Sumarle años a una fecha
        double valor;
        if ( valores[100]==1 ) {                                            // Maroma: Si el periodo=1 retorna la fechaFinalContrato
          valor = valores[22];
          print(clase+' función: ['+funcion+']'+formula+') ==>> '+valor.toString() );
        }
        else {
          int ano =int.parse(n1.substring(0,4)) + int.parse(n2);            // ano <-- 2019+1
          print(clase+' función: ['+funcion+']'+formula+') ==>> '+double.parse(ano.toString()+n1.substring(4,n1.length)).toString() );
          valor= double.parse(ano.toString()+n1.substring(4,n1.length));    // 20200429 <-- ano+0429
        }
        return valor;
      }
      case '002' : {                                                        // Restarle años a una fecha
        int ano =int.parse(n1.substring(0,4))-int.parse(n2);                // ano <-- 2019+1

        print(clase+' función: ['+funcion+']'+formula+') ==>> '+double.parse(ano.toString()+n1.substring(4,n1.length)).toString() );
        return double.parse(ano.toString()+n1.substring(4,n1.length));      // 20200429 <-- ano+0429
      }
      case '003' : {                                                        // Diferencia de días entre fechas
        print(clase+' función: ['+funcion+']'+formula+') ==>> '+n1.toString() +', '+n2.toString());
        var inicio    = DateTime.parse(n1.substring(0,8)+' 00:00:00Z');     // fecha <-- 20190429
        var fin       = DateTime.parse(n2.substring(0,8)+' 00:00:00Z');     // fecha <-- 20190429
        var diff = inicio.difference(fin);                                  // Días de diferencia

        print(clase+' función: ['+funcion+']'+formula+') ==>> '+diff.toString() );
        return diff.inDays.toDouble();                                      // => 7416 - log these out with print(diff.inDays);
//        diff.inHours; // => 177987
//        diff.inMinutes; // => 10679261
      }
      case '004' : {                                                        // fechaInicialAmparo = dependiendo del amparo
        double valor = valores[21];                                         // <- fechaInicialContrato
//        if ( concepto == 10053 ) {                                        // Estabilidad de la obra
//          valor = valores[22];
//          print(clase+' función: ['+funcion+']'+formula+') ==>> '+valor.toString() );
//        }
//        else
          if ( conceptoPrincipal == 10055 ) {                               // Seriedad de la oferta
            var fecha     = DateTime.parse(valores[22].toString().substring(0,8)+' 00:00:00Z');     // fechaFinalContrato <-- 20190429
            var resultado = fecha.add(Duration(days: 1 ) );                 // Sumarle o restarle los días a la fecha
            String fechaInt ="${resultado.year.toString()}${resultado.month.toString().padLeft(2,'0')}${resultado.day.toString().padLeft(2,'0')}";
            valor = double.parse(fechaInt);
          }
        return valor;
      }

      default  : { return  0 ;}
    }
  }

  static calcular( int concepto, String debito, String credito, int redondeo, String clase ) async {

    valorDB=0;
    valorCR=0;
    int indice= concepto - int.parse(args[5]);			       // Concepto 11003 --> 003 --> 3
    String simbolo ="[N]";
    if ( debito.length >=3 )
      simbolo = debito.substring( 0,3 );

    if( debito.length > 0 ) {
      switch ( simbolo ) {
        case '[F]' : {
          valorDB = funcion( debito.substring( 3 , debito.length), '['+clase+']'+'['+concepto.toString()+']', concepto );
          break;
        }
        case '[C]' : {
          conceptoPrincipal = concepto;
          List lista = debito.substring( 3 , debito.length).split(",");
          for (int i=0; i<lista.length; i++) {
            await recorrer( lista[i] );
          }
          break;
        }
        default : {
          valorDB = operacion( debito, '['+clase+']'+'['+concepto.toString()+']' );
          break;
        }
      }
      valores[indice] = valorDB;
    }

    if( credito.length > 0 ) {
      switch ( simbolo ) {
        case '[F]' : {
          valorCR = funcion( credito.substring( 3 , credito.length), '['+clase+']'+'['+credito.toString()+']', concepto );
          break;
        }
        case '[C]' : {
          List lista = credito.substring( 3 , credito.length).split(",");
          for (int i=0; i<lista.length; i++) {
            await recorrer( lista[i] );
          }
          break;
        }
        default : {
          valorCR = operacion( credito, clase );
          break;
        }
      }
      valores[indice] = valorCR;
    }
  }

  static recorrer( String clase ) async {

    print(' E M P I E Z A > > > > > > > > > > > > > > > > > > > > > '+ clase );
    final db = await database;
    bool entro=true;

    sentencia =
      'SELECT concepto, valor FROM valor '+
      'WHERE clase = '+clase+' GROUP BY concepto HAVING COUNT(*) = 1';
    await cargarValores( sentencia );                               // Subir valor General por clase

    sentencia =
      'select fr.concepto, fr.debito, fr.credito, fr.contador, fr.cantidad, fr.indicador, fr.sentencia, cn.redondeo '+
      'from formula fr, concepto cn where fr.concepto = cn.concepto and fr.clase = '+clase+' '+
      'AND fr.indicador != 38 and fr.indicador != 39 order by fr.clase ,fr.orden ';
    print ('formula: '+sentencia );

    var consultaF = await db.rawQuery( sentencia );               // Crear Cursor para Grabar los Datos básicos
    try {
      for (int j = 0; j < consultaF.length; j++) {
        Formula rs = Formula.map(consultaF[j]);

        if ( args[7].length != 0 && orden ==1 )                   // Para el primero para cambiarle el concepto por defecto
          sentencia = 'SELECT '+args[7]+' as concepto, valor FROM valor WHERE clase = '+clase+' AND minimo = '+rs.concepto.toString();
        else
          sentencia = 'SELECT concepto, valor FROM valor WHERE clase = '+clase+' AND minimo = '+rs.concepto.toString();
        await cargarValores( sentencia );

        if ( entro ) {
          entro=false;
//          trace(clase);
        }

        switch( rs.indicador ) {
          case 34	: { break;  }										            // Cargar SQL
          case 35	: {                                         // Calcular
            await calcular( rs.concepto, rs.debito.trim(), rs.credito.trim(), rs.redondeo, clase );
            break;
          }
          case 36	: {                                         // Liquidar (Calcular e Insertar)
            await calcular( rs.concepto, rs.debito.trim(), rs.credito.trim(), rs.redondeo, clase );
            await ejecutar( rs.concepto, rs.sentencia );      // Ejecutar SQL, puede ser insert, delete o update
            break;
          }
          case 37	: { ; }
        }

        int indice = rs.concepto - int.parse(args[5]);        // Concepto 11003 --> 003 --> 3
        int i=0;													                    // ACUMULAR EN CADA CONTADOR
        while ( rs.contador.trim().length > i && ( valorDB != 0 || valorCR != 0 ) && valores[indice] != 0 ) {
          int j = int.parse( rs.contador.substring(i) );
          valores[ contadores[j] ] = valores[ contadores[j] ] + valores[ indice ];
          i++;
        }
      }
    } on DatabaseException catch (e) { print('native_error: $e'); }
//    db.close();
  }

  static void nuevoAmparos( String id, String clase, String crud, String auxiliar, String comodin )  async {    // C A R G A R   C L A S E <<<<<

    final db = await database;

    inicializarArreglo();

    valores[365]=365;

    args[1] = id;                                               // id Principal en este caso de la póliza
    args[2] = clase;                                            // Clase
    args[3] = crud;                                             // Crud
    args[4] = auxiliar;                                         // id Auxiliar
    args[5] = '10000';                                          // 10000
    args[6] = '1';                                              // orden
    args[7] = comodin;                                          // orden

    sentencia=
      'SELECT cn.concepto, rg.parametro0 AS parametro '
      'FROM concepto cn, g_registro rg '+
      'WHERE cn.parametro = rg.registro AND cn.concepto BETWEEN '+args[5]+' AND '+args[5].substring(0, 2)+'999 AND cn.parametro != 4';
    await cargarParametros( sentencia );                              // Subir parametros de conceptos

    sentencia =
      'select distinct concepto, contador FROM formula '+
      'WHERE indicador = 38 AND concepto BETWEEN '+args[5]+' AND '+args[5].substring(0, 2)+'999';
    await cargarContadores( sentencia );                              // Subir contadores de Conceptos

    sentencia=
      'select 10001 as concepto, periodo*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10002 as concepto, retroactividad*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10003 as concepto, cast(substr(fechaEmision,1,4)||substr(fechaEmision,6,2)||substr(fechaEmision,9,2) as decimal)*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10004 as concepto, cast(substr(fechaEmision,12,2) as decimal)*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10005 as concepto, cast(substr(fechaEmision,15,2)as decimal)*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1];

    await cargarValores( sentencia );                                 // Subir póliza

    sentencia=
      'select 10010 as concepto, comision/100.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10011 as concepto, cupoOperativo*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10020 as concepto, valorContrato*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10021 as concepto, cast(substr(fechaInicial,1,4)||substr(fechaInicial,6,2)||substr(fechaInicial,9,2) as decimal)*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1]+
      ' union '+

      'select 10022 as concepto, cast(substr(fechaFinal,1,4)||substr(fechaFinal,6,2)||substr(fechaFinal,9,2)as decimal)*1.0 as valor '+
      'from  poliza '+
      'where poliza = '+args[1];

    await cargarValores( sentencia );                                 // Cargar datos

    sentencia = "delete from amparo where concepto between 10400 and 10410 and poliza = "+args[1];
    await db.execute(sentencia);

    sentencia =
    "select 10390 as concepto, ifnull(sum(prima),0)*1.0  as valor from amparo where poliza = "+args[1]+ " union "
    "select 10391 as concepto, ifnull(sum(prima),0)*1.0  as valor from amparo where poliza = "+args[1];
    await cargarValores( sentencia );                                 // Cargar datos

    orden = 1;
    var consulta = await db.rawQuery("select ifnull(max(orden)+1,1) as id from amparo where poliza = "+args[1] );
    orden = consulta.first["id"];
    print ('id: '+orden.toString());  // trace

    try { await recorrer( args[2] ); }
    on DatabaseException catch (e) { print('native_error: $e'); }
  }
}
