import 'dart:convert';

Registro registroFromJson(String str) {
  final jsonData = json.decode(str);
  return Registro.fromMap(jsonData);
}

String registroToJson(Registro data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Registro {
  int registro;
  String descripcion;

  bool sincronizar;

  Registro({
    this.registro,
    this.descripcion,
  });

  factory Registro.fromMap(Map<String, dynamic> json) => new Registro(
    registro: json["registro"],
    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "registro": registro,
    "descripcion": descripcion,
  };
}
