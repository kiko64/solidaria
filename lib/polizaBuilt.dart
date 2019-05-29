import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';
import 'dart:convert';

//To solve the SDK problem
//flutter packages pub run build_runner build lib

part 'polizaBuilt.g.dart';

abstract class PolizaBuilt implements Built<PolizaBuilt, PolizaBuiltBuilder> {
  static Serializer<PolizaBuilt> get serializer => _$polizaBuiltSerializer;

  int get poliza;

  String get sede;

  String get fechaEmision;

  int get periodo;

  int get numero;

  int get temporario;

  String get estado;

  @nullable

  BuiltList<int> get intemediarios;

  double get comision;

  int get cupo_operativo;

  String get afianzado;

  String get tipoPoliza;

  String get clausulado;

  int get periodoEmision;

  int get retroactividad;

  String get fechaHoraInicial;

  String get fechaHoraFinal;

  String get contratante;

  String get objeto;

  String get numeroContrato;

  double get valorContrato;

  String get fechaInicial;

  String get fechaFinal;

  @nullable
  BuiltList<int> get amparos;

  int get sincronizar;

  /* Objects are defined like this:
  var login = new Login((b) => b
  ..username = 'johnsmith'
  ..password = '123456');
  */


  PolizaBuilt._();
  factory PolizaBuilt([updates(PolizaBuiltBuilder b)]) = _$PolizaBuilt;
}

//Deserialize
PolizaBuilt parsePoliza(String json){
  final parsed  = jsonDecode(json);
  PolizaBuilt poliza = standardSerializers.deserializeWith(PolizaBuilt.serializer,parsed);
  return poliza;
}
//Serialize
String polizaJson(PolizaBuilt objPoliza){
  //print(JSON.encode(serializers.serialize(login)));
  final json  = jsonEncode(standardSerializers.serialize(objPoliza));
  return json;
}
