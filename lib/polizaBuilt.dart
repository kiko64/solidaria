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

  @nullable
  int get poliza;

  @nullable
  String get sede;

  @nullable
  String get fechaEmision;

  @nullable
  int get periodo;

  @nullable
  int get numero;

  @nullable
  int get temporario;

  @nullable
  String get estado;

  @nullable
  BuiltList<int> get intemediarios;

  @nullable
  double get comision;

  @nullable
  int get cupo_operativo;

  @nullable
  String get afianzado;

  @nullable
  String get tipoPoliza;

  @nullable
  String get clausulado;

  @nullable
  int get periodoEmision;

  @nullable
  int get retroactividad;

  @nullable
  String get fechaHoraInicial;

  @nullable
  String get fechaHoraFinal;

  @nullable
  String get contratante;

  @nullable
  String get objeto;

  @nullable
  String get numeroContrato;

  @nullable
  double get valorContrato;

  @nullable
  String get fechaInicial;

  @nullable
  String get fechaFinal;

  @nullable
  BuiltList<int> get amparos;

  @nullable
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


