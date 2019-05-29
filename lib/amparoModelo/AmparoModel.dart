import 'dart:convert';

Amparo amparoFromJson(String str) {                                             // DesSerialización 	--> 	Recuperar Datos

  final jsonData = json.decode(str);
  return Amparo.fromMap(jsonData);
}

String amparoToJson(Amparo data) {                                              // Serialización 		--> 	Escribir Datos
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Amparo {
  int amparo;
  int orden;
  int poliza;

  int concepto;
  int dias;
  String fechaInicial;
  String fechaFinal;

  double porcentaje;
  double valorAsegurado;
  double tasaAmparo;
  double prima;

  String descripcion;

  Amparo({
    this.amparo,
    this.orden,
    this.poliza,

    this.concepto,
    this.dias,
    this.fechaInicial,
    this.fechaFinal,

    this.porcentaje,
    this.valorAsegurado,
    this.tasaAmparo,
    this.prima,

    this.descripcion,
  });

  factory Amparo.fromMap(Map<String, dynamic> json) => new Amparo(
    amparo: json["amparo"],
    orden: json["orden"],
    poliza: json["poliza"],

    concepto: json["concepto"],
    dias: json["dias"],
    fechaInicial: json["fechaInicial"],
    fechaFinal: json["fechaFinal"],

    porcentaje: json["porcentaje"],
    valorAsegurado: json["valorAsegurado"],
    tasaAmparo: json["tasaAmparo"],
    prima: json["prima"],

    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "dias": dias,
    "fechaInicial": fechaInicial,
    "fechaFinal": fechaFinal,

    "porcentaje": porcentaje,
    "valorAsegurado": valorAsegurado,
    "tasaAmparo": tasaAmparo,
    "prima": prima,
  };
}

class Concepto {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;

  Concepto(this._descripcion);
  Concepto.withId(this._registro,this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //This function is to convert Concepto Object to Map Object for datavalorAsegurado
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    return map;
  }

  Concepto.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
  }
}
