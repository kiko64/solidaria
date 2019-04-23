import 'dart:convert';

Accion accionFromJson(String str) {
  final jsonData = json.decode(str);
  return Accion.fromMap(jsonData);
}

String accionToJson(Accion data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Accion {
  int accion;
  String fecha;
  int agenda;
  int categoria;
  String usuario;
  int sincronizar;

  int interno;
  String descripcion;
  String titulo;
  String subtitulo;

  String detalle;
  int seguimiento;
  int procedencia;
  String posicion;

  Accion({
    this.accion,
    this.fecha,
    this.agenda,
    this.categoria,
    this.usuario,
    this.sincronizar,

    this.interno,
    this.descripcion,
    this.titulo,
    this.subtitulo,

    this.detalle,
    this.seguimiento,
    this.procedencia,
    this.posicion,
  });

  factory Accion.fromMap(Map<String, dynamic> json) => new Accion(
    accion: json["accion"],
    fecha: json["fecha"],
    agenda: json["agenda"],
    categoria: json["categoria"],
    usuario: json["usuario"],
    sincronizar: json["sincronizar"],

    interno: json["interno"],
    descripcion: json["descripcion"],
    titulo: json["titulo"],
    subtitulo: json["subtitulo"],

    detalle: json["detalle"],
    seguimiento: json["seguimiento"],
    procedencia: json["procedencia"],
    posicion: json["posicion"],
  );

  Map<String, dynamic> toMap() => {
    "accion": accion,
    "fecha": fecha,
    "agenda": agenda,
    "categoria": categoria,
    "usuario": usuario,
    "sincronizar": sincronizar,

    "interno": interno,
    "descripcion": descripcion,
    "titulo": titulo,
    "subtitulo": subtitulo,

    "detalle": detalle,
    "seguimiento": seguimiento,
    "procedencia": procedencia,
    "posicion": posicion,
  };
}

