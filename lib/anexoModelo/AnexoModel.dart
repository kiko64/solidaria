import 'dart:convert';

Anexo anexoFromJson(String str) {
  final jsonData = json.decode(str);
  return Anexo.fromMap(jsonData);
}

String anexoToJson(Anexo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Anexo {
  int anexo;
  int interno;
  int categoria;
  String documento;

  String descripcion;

  Anexo({
    this.anexo,
    this.interno,
    this.categoria,
    this.documento,

    this.descripcion,
  });

  factory Anexo.fromMap(Map<String, dynamic> json) => new Anexo(
    anexo: json["anexo"],
    interno: json["interno"],
    categoria: json["categoria"],
    documento: json["documento"],

    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "interno": interno,
    "categoria": categoria,
    "documento": documento,
  };
}

class Categoria {                  // fixCombo (16 feb 2019): Nueva clase para el combo

  int    _registro;
  String _descripcion;

  Categoria(this._descripcion);
  Categoria.withId(this._registro,this._descripcion);

  int    get registro =>    _registro;
  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //This function is to convert Registro Object to Map Object for datavalorAsegurado
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    return map;
  }

  Categoria.fromMapObject(Map<String, dynamic> map){
    this._registro    = map['registro'];
    this._descripcion = map['descripcion'];
  }
}
