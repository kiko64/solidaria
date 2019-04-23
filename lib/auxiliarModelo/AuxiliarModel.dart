import 'dart:convert';

Auxiliar auxiliarFromJson(String str) {
  final jsonData = json.decode(str);
  return Auxiliar.fromMap(jsonData);
}

String auxiliarToJson(Auxiliar data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Auxiliar {
  int auxiliar;
  int clasificacion;
  int tipo;
  int identificacion;
  String primerNombre;
  String segundoNombre;
  String primerApellido;
  String segundoApellido;
  String favorito;

  String foto;
  String nacimiento;
  int lugar;
  int genero;
  int estadoCivil;

  String direccion;
  int municipio;
  String movil;
  String fijo;
  String correo;

  String documento;
  bool sincronizar;

  Auxiliar({
    this.auxiliar,
    this.clasificacion,
    this.tipo,
    this.identificacion,
    this.primerNombre,
    this.segundoNombre,
    this.primerApellido,
    this.segundoApellido,
    this.favorito,

    this.foto,
    this.nacimiento,
    this.lugar,
    this.genero,
    this.estadoCivil,

    this.direccion,
    this.municipio,
    this.movil,
    this.fijo,
    this.correo,

    this.documento,
    this.sincronizar,
  });

  factory Auxiliar.fromMap(Map<String, dynamic> json) => new Auxiliar(
    auxiliar: json["auxiliar"],
    clasificacion: json["clasificacion"],
    tipo: json["tipo"],
    identificacion: json["identificacion"],
    primerNombre: json["primerNombre"],
    segundoNombre: json["segundoNombre"],
    primerApellido: json["primerApellido"],
    segundoApellido: json["segundoApellido"],
    favorito: json["favorito"],

    foto: json["foto"],
    nacimiento: json["nacimiento"],
    lugar: json["lugar"],
    genero: json["genero"],
    estadoCivil: json["estadoCivil"],

    direccion: json["direccion"],
    municipio: json["municipio"],
    movil: json["movil"],
    fijo: json["fijo"],
    correo: json["correo"],

    documento: json["documento"],
    sincronizar: json["sincronizar"]==1,
  );

  Map<String, dynamic> toMap() => {
    "clasificacion": clasificacion,
    "tipo": tipo,
    "auxiliar": auxiliar,
    "identificacion": identificacion,
    "primerNombre": primerNombre,
    "segundoNombre": segundoNombre,
    "primerApellido": primerApellido,
    "segundoApellido": segundoApellido,
    "favorito": favorito,

    "foto": foto,
    "nacimiento": nacimiento,
    "lugar": lugar,
    "genero": genero,
    "estadoCivil": estadoCivil,

    "direccion": direccion,
    "municipio":  municipio,
    "movil": movil,
    "fijo": fijo,
    "correo": correo,
    "documento": documento,
  };
}

class Genero {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;

  Genero(this._descripcion);
  Genero.withId(this._registro,this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //This function is to convert Genero Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    return map;
  }

  Genero.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
  }
}


