import 'dart:convert';

Poliza polizaFromJson(String str) {
  final jsonData = json.decode(str);
  return Poliza.fromMap(jsonData);
}

String polizaToJson(Poliza data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Poliza {
  int poliza;
  int sede;
  String fechaEmision;
  int periodo;
  int numero;
  int temporario;
  int estado;

  int intermediario;
  double comision;
  int cupoOperativo;

  int afianzado;
  int tipoPoliza;
  String clausulado;

  int periodoEmision;
  int retroactividad;
  String fechaHoraInicial;
  String fechaHoraFinal;

  int contratante;
  int objeto;
  String numeroContrato;
  double valorContrato;
  String fechaInicial;
  String fechaFinal;
  int sincronizar;

  String nombre;
  String descripcion;

  Poliza ( {
    this.poliza,
    this.sede,
    this.fechaEmision,
    this.periodo,
    this.numero,
    this.temporario,
    this.estado,

    this.intermediario,
    this.comision,
    this.cupoOperativo,

    this.afianzado,
    this.tipoPoliza,
    this.clausulado,

    this.periodoEmision,
    this.retroactividad,
    this.fechaHoraInicial,
    this.fechaHoraFinal,

    this.contratante,
    this.objeto,
    this.numeroContrato,
    this.valorContrato,
    this.fechaInicial,
    this.fechaFinal,
    this.sincronizar,

    this.nombre,
    this.descripcion,
  });

  factory Poliza.fromMap(Map<String, dynamic> json) => new Poliza(
    poliza: json["poliza"],
    sede: json["sede"],
    fechaEmision: json["fechaEmision"],
    periodo: json["periodo"],
    numero: json["numero"],
    temporario: json["temporario"],
    estado: json["estado"],

    intermediario: json["intermediario"],
    comision: json["comision"],
    cupoOperativo: json["cupoOperativo"],

    afianzado: json["afianzado"],
    tipoPoliza: json["tipoPoliza"],
    clausulado: json["clausulado"],

    periodoEmision: json["periodoEmision"],
    retroactividad: json["retroactividad"],
    fechaHoraInicial: json["fechaHoraInicial"],
    fechaHoraFinal: json["fechaHoraFinal"],

    contratante: json["contratante"],
    objeto: json["objeto"],
    numeroContrato: json["numeroContrato"],
    valorContrato: json["valorContrato"],
    fechaInicial: json["fechaInicial"],
    fechaFinal: json["fechaFinal"],
    sincronizar: json["sincronizar"],

    nombre: json["nombre"],
    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "sede": sede,
    "fechaEmision": fechaEmision,
    "periodo": periodo,
    "numero": numero,
    "temporario": temporario,
    "estado": estado,

    "intermediario": intermediario,
    "comision": comision,
    "cupoOperativo": cupoOperativo,

    "afianzado": afianzado,
    "tipoPoliza": tipoPoliza,
    "clausulado": clausulado,

    "periodoEmision": periodoEmision,
    "retroactividad": retroactividad,
    "fechaHoraInicial": fechaHoraInicial,
    "fechaHoraFinal": fechaHoraFinal,

    "contratante": contratante,
    "objeto": objeto,
    "numeroContrato": numeroContrato,
    "valorContrato": valorContrato,
    "fechaInicial": fechaInicial,
    "fechaFinal": fechaFinal
  };
}

class Objeto {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;

  Objeto(this._descripcion);
  Objeto.withId(this._registro,this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //This function is to convert Objeto Object to Map Object for datavalorAsegurado
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    return map;
  }

  Objeto.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
  }
}
