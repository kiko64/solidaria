import 'package:flutter/material.dart';

class GRegistro{
  int registro;
  int tabla;
  String descripcion;
  int parametro_0;
  String parametro_1;
  String parametro_2;
  String parametro_3;
  String parametro_4;


  GRegistro({this.registro, this.tabla, this.descripcion, this.parametro_0,
    this.parametro_1, this.parametro_2, this.parametro_3, this.parametro_4});

  GRegistro.init();

  toJson(){
    return {
      "registro":registro,
      "tabla":tabla,
      "descripcion":descripcion,
      "parametro_0":parametro_0,
      "parametro_1":parametro_1,
      "parametro_2":parametro_2,
      "parametro_3":parametro_3,
      "parametro_4":parametro_4,
    };
  }

  factory GRegistro.fromMap(Map<String, dynamic> map){
    return GRegistro(
      registro : map["registro"],
      tabla : map["tabla"],
      descripcion : map["descripcion"],
      parametro_0 : map["parametro_0"],
      parametro_1 : map["parametro_1"],
      parametro_2 : map["parametro_2"],
      parametro_3 : map["paramtero_3"],
      parametro_4 : map["parametro_4"],
    );
  }

}

/*
CREATE TABLE clase ( "
          "clase integer NOT NULL,"
          "descripcion text NOT NULL,"
          "sinonimo integer NOT NULL,"
          "observacion integer NOT NULL,"
          "tipo integer NOT NULL,"
          "documento integer NOT NULL,"

          "FOREIGN KEY (tipo)    REFERENCES g_registro(registro)ON DELETE CASCADE ON UPDATE NO ACTION )"

insert into clase ( clase, descripcion, sinonimo, observacion, tipo, documento ) values "
"( 10000	 ,'Poliza',		 10000	 ,' ', 31, 0 ),"
"( 10001	 ,'Fecha inicial amparo',10001	 ,' ', 31, 0 ),"
"( 10002	 ,'Fecha final amparo',	 10002	 ,' ', 31, 0 ),"
"( 10003	 ,'Datos amparo',	 10003	 ,' ', 31, 0 ),"
"( 10004	 ,'Liquidación global',	 10004	 ,' ', 31, 0 ),"
"( 10100	 ,'Prestación de servicios',10100,' ', 31, 0 ),"
"( 10101	 ,'Suministro',10101,' ', 31, 0 ),"
"( 10102	 ,'Consultoría',10102,' ', 31, 0 ),"
"( 10103	 ,'Interventoría',10103,' ', 31, 0 ),"
"( 10104	 ,'Obra',10104,' ', 31, 0 ),"
"( 10105	 ,'Seriedad Oferta',10105,' ', 31, 0 ) "

*/


/*
"insert into concepto ( concepto, descripcion, grupo, parametro, unidad, redondeo ) values "
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

          "( 10050, 'Cumplimiento'              ,18,	4,	19 ,0),"
          "( 10051, 'Calidad'                   ,18,	4,	19 ,0),"
          "( 10052, 'Anticipo'                  ,18,	4,	19 ,0),"
          "( 10053, 'Salararios'                ,18,	4,	19 ,0),"
          "( 10054, 'Prestaciones sociales e indemnizaciones',18,	4,	19 ,0),"
          "( 10055, 'Estabilidad de obra'       ,18,	4,	19 ,0),"
          "( 10056, 'Calidad del bien'          ,18,	4,	19 ,0),"
          "( 10057, 'Calidad del servicio'      ,18,	4,	19 ,0),"
          "( 10058, 'Provision de repuestos'    ,18,	4,	19 ,0),"

          "( 10100, 'Periodo amparo'            ,17,	4,	22 ,0),"
          "( 10101, 'Tarifa amparo'             ,17, 16,	29 ,0),"
          "( 10102, 'Tasa asegurado'            ,17, 14,	29 ,0),"
          "( 10103, 'Tasa I.V.A'                ,17,	4,	29 ,0),"

          "( 10200, 'Fecha inicial amparo'      ,17,	5,	23 ,0),"
          "( 10201, 'Hora inicial amparo'       ,17,	4,	24 ,0),"
          "( 10202, 'Minutos inicial amparo'    ,17,	4,	25 ,0),"
          "( 10205, 'Fecha final amparo'        ,17,	6,	23 ,0),"
          "( 10206, 'Hora final amparo'         ,17,	4,	24 ,0),"
          "( 10207, 'Minutos final amparo'      ,17,	4,	25 ,0),"
          "( 10210, 'Días amparo'               ,17,	7,	20 ,0),"
          "( 10300, 'Valor asegurado'           ,17, 15,	27 ,0),"
          "( 10301, 'Prima'                     ,17, 32,	27 ,0),"
          "( 10390 ,'Sumatoria asegurado'       ,17,  4,  27 ,0),"
          "( 10391 ,'Sumatoria prima'           ,17,  4,  27 ,0),"

          "( 10400, 'Comisión normal'           ,17,	4,	27 ,0),"
          "( 10401, 'Comisión adicional'        ,17,	4,	27 ,0),"
          "( 10402, 'Descuento'                 ,17,  4,	27 ,0),"
          "( 10403, 'Recargos'                  ,17,	4,	27 ,0),"
          "( 10404, 'Gastos de emisión'         ,17,	4,  27 ,0),"
          "( 10405, 'Gastos administración tomador',17,	4, 27 ,0),"
          "( 10410, 'I.V.A'                     ,17,	4,  27, 0) "
        );
 */