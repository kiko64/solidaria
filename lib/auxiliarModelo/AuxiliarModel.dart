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
  String _parametro0;

  Genero.withId(this._registro,this._descripcion);
  Genero(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert Genero Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  Genero.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}

class EstadoCivil {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;
  String _parametro0;

  EstadoCivil.withId(this._registro,this._descripcion);
  EstadoCivil(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert EstadoCivil Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  EstadoCivil.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}

class Tipo {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;
  String _parametro0;

  Tipo.withId(this._registro,this._descripcion);
  Tipo(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert Tipo Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  Tipo.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}

class Clasificacion {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;
  String _parametro0;

  Clasificacion.withId(this._registro,this._descripcion);
  Clasificacion(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert Clasificacion Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  Clasificacion.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}

class Lugar {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;
  String _parametro0;

  Lugar.withId(this._registro,this._descripcion);
  Lugar(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert Lugar Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  Lugar.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}


class Municipio {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;
  String _parametro0;

  Municipio.withId(this._registro,this._descripcion);
  Municipio(this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;
  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }
  //This function is to convert Municipio Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] =  _parametro0;
    return map;
  }

  Municipio.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0  = map['parametro0'];
  }
}


