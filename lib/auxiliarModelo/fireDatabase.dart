import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'AuxiliarModel.dart';


class firebaseDatabase extends StatelessWidget{

  Auxiliar nuevoAux;

  firebaseDatabase({this.nuevoAux});

  DatabaseReference rootRef = FirebaseDatabase.instance.reference();

  firebaseDatabase.fnCreate(String path, Map<String, dynamic> body) {
    if (path == null || body == null) return;
    rootRef.child(path).set(body);
  }

  Auxiliar fnRead(String path) {
    if (path == null) return null;
    void successFn(DataSnapshot data){
      if(data!=null && data.value != null){
        print("Datos en base de datos ${data.value.toString()}");
        var map = Map<String,dynamic>.from(data.value);
        var aux = Auxiliar.fromMap(map);
        print(aux.estadoCivil.toString());
        this.nuevoAux = aux;
      }else{
        print("No hay datos");
      }
    }
    rootRef.child(path).once().then(successFn);
    return this.nuevoAux;
  }

  firebaseDatabase.fnUpdate(String path, Map<String, dynamic> body) {
    if (path == null || body == null) return;
    rootRef.child(path).update(body);
  }

  firebaseDatabase.fnDelete(String path) {
    if (path == null) return;
    rootRef.child(path).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class firebaseBloc {
  // new separate

  firebaseBloc() {
    getFB();
  }

  final _auxController = StreamController<Auxiliar>.broadcast();
  get auxiliar => _auxController.stream;


  dispose() {
    _auxController.close();
  }

  getFB() async {
    var objFB = firebaseDatabase();
    _auxController.sink.add(await objFB.fnRead("PruebaDomingo"));
  }


}




