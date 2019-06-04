import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auxiliarModelo/AuxiliarModel.dart';
import 'auxiliarModelo/fireDatabase.dart';

class ventanaCrud extends StatefulWidget {
  @override
  _ventanaCrudState createState() => _ventanaCrudState();
}

class _ventanaCrudState extends State<ventanaCrud> {
  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference pruebaRef;
  DatabaseReference rootRef;

  FirebaseDatabase objetoCrud;

  final bloc = firebaseBloc();

  @override
  void initState() {
    rootRef = database.reference();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Prueba CRUD"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => create()),
              RaisedButton(
                  color: Colors.orangeAccent,
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => update()),
              RaisedButton(
                  color: Colors.redAccent,
                  child: Text(
                    "Remove",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => firebaseDatabase.fnDelete("pruebaDomingo")),
              RaisedButton(
                  color: Colors.green,
                  child: Text(
                    "Read",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => readAuxiliar()),
              Expanded(
                child: StreamBuilder<Auxiliar>(  //new separate
                  stream: bloc.auxiliar, //new separate

                  //body: FutureBuilder<List<Auxiliar>>(  //new separate
                  //future: DBProvider.db.getAllAuxiliar(), //new separate

                  builder: (BuildContext context, AsyncSnapshot<Auxiliar> snapshot) {

                    if (snapshot.hasData) {
                      //          return ListView.builder(
                      return Text("Estado civil en auxiliar: ${snapshot.data}");
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}

void update() {
  var path = "pruebaDomingo";
  var body = {"nombre": "Andy", "edad": 38};
  firebaseDatabase.fnUpdate(path, body);
}

void create() {
  var path = "pruebaDomingo";
  var body = {"nombre": "majo", "edad": 31};
  firebaseDatabase.fnCreate(path, body);
}

void readAuxiliar() {
  var objFB = firebaseDatabase();
  Auxiliar nuevoAux = Auxiliar();
  var nuevo = objFB.fnRead("PruebaDomingo");
  //print("Objeto en FB ${nuevo.estadoCivil}");
  if(
  nuevoAux!=null){
    print("Objeto Auxiliar ${nuevoAux.estadoCivil}");
  }
}
