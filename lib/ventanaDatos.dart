import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emision/auxiliarModelo/Database.dart';
import 'package:emision/datosModelo/DatosModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:emision/utils/ui_utils.dart';

class VentanaGRegistro extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  final FocusNode _tabla   = FocusNode();
  final FocusNode _descrip = FocusNode();
  final FocusNode _param0  = FocusNode();


  VentanaGRegistro actual;

  VentanaGRegistro({Key key, @required this.actual})
      : super(key: key); // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _VentanaGRegistroState createState() => _VentanaGRegistroState();
}

class _VentanaGRegistroState extends State<VentanaGRegistro> {
  final GlobalKey<FormState> formKey = GlobalKey();
  GRegistro gRegistro = GRegistro.init();
  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference gRegRef;
  DatabaseReference rootRef;

  int tabla;
  String descripcion;
  int parametro0;

  var _tabla = TextEditingController();
  var _descripcion = TextEditingController();
  var _parametro0 = TextEditingController();

  final FocusNode _tablaFocus = FocusNode();
  final FocusNode _descripcionFocus = FocusNode();
  final FocusNode _parametroFocus = FocusNode();

  final bloc = AuxiliarBloc(); // Manejo DB

  bool editable = false;

  @override
  void initState() {

    gRegRef = database.reference().child("GRegistro");

    //Root ref
    rootRef = database.reference();

    super.initState();
  }

  submit(){
    //Definir una clave automatica de ingreso
    String newKey = gRegRef.push().key;

    gRegRef.child('124').set(GRegistro(tabla: 233,descripcion: "SemanaSanta4",parametro_0: 1).toJson());   //
    //gRegRef.child('124').set(priority);
    debugPrint("Ultima clave es: $newKey");
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget datosIdentificacion = Container(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Tabla',
            ),
            focusNode: _tablaFocus,
            textInputAction: TextInputAction.next,
            onSaved: (val) => gRegistro.tabla = int.parse(val),
            onFieldSubmitted: (term) {
              _tablaFocus.unfocus();
              FocusScope.of(context).requestFocus(_descripcionFocus);
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Descripción',
            ),
            focusNode: _descripcionFocus,
            textInputAction: TextInputAction.next,
            onSaved: (val)=> gRegistro.descripcion = val,
            onFieldSubmitted: (term) {
              _descripcionFocus.unfocus();
              FocusScope.of(context).requestFocus(_parametroFocus);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Parametro 0',
              icon: const Icon(Icons.person),
            ),
            focusNode: _parametroFocus,
            textInputAction: TextInputAction.next,
            onSaved: (val)=> gRegistro.parametro_0 = int.parse(val),
            onFieldSubmitted: (term) {
              _parametroFocus.unfocus();
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Tabla GRegistro")),
      body: Container(
        // Antes SafeArea
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            children: <Widget>[
              SizedBox(height: 12.0),
              datosIdentificacion,
              SizedBox(height: 18.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: amarilloSolidaria1,
            child: Icon(
              Icons.add,
              size: 30,
              color: azulSolidaria1,
            ),

            onPressed: (){
              final FormState form = formKey.currentState;
              //if (form.validate()) {
              form.save();
              form.reset();
              submit();
              //}
            },
            tooltip: 'Guardar Tabla GRegistro',
          ), // Manejo DB Refrescar
        ],
      ),
    );
  }
}

