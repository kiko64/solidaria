// Copyright 2020-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:emision/anexoModelo/AnexoModel.dart';
import 'package:emision/anexoModelo/AnexoControler.dart';
import 'package:sqflite/sqflite.dart';          // fixCombo (16 feb 2019): new variable
import 'package:image_picker/image_picker.dart';

class AnexoPage extends StatefulWidget {

  Anexo actual;
  AnexoPage({Key key, @required this.actual}) : super(key: key);   // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AnexoPageState createState() => _AnexoPageState();
}

class _AnexoPageState extends State<AnexoPage> {

  DBAnexo dbAmparo = DBAnexo();               // fixCombo (16 feb 2019): new variable
  List<Categoria> categorias;
  var _categoria = null;

  int _anexo;
  var _interno    = TextEditingController();
  File _documento = null;                          // FOTO: Variable

  final bloc = AnexoBloc('');  // Manejo DB

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  bool editable = false;
  DateTime fecha = new DateTime.now();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _documento = image;          // FOTO: Pasa la imagen a la variable
      print('Camara <-- '+_documento.path.toString() );
    }
    );
  }

  @override
  void initState() {
    if(widget.actual==null) {                             // Manejo DB es Insertar
      print('I N S E R T ...');
      _anexo          = 0;
      _interno.text   = '0';
    }
    else {                                                // Manejo DB es Actualizar
      print('U P D A T E ...');
      _anexo          = widget.actual.anexo;
      _categoria      = widget.actual.categoria.toString();
      _interno.text   = widget.actual.interno.toString();

      if (widget.actual.documento.toString() != 'assets/person.jpg') {
        print('Recuperación '+widget.actual.documento.toString() );
        _documento = File(widget.actual.documento.toString());              // FOTO: Pasa la imagen a la variable
      }
      else _documento = null;

    }
  }


  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;        // fixCombo (16 feb 2019): load list
    if(categorias == null) {
      categorias = List<Categoria>();
      updateListView();
    }

    return new Scaffold(

      appBar: new AppBar(title: new Text('Anexo')),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[

              SizedBox(height: 12.0),

              new TextFormField(
                controller: _interno,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.list),
                  hintText: 'Número de póliza:',
                  labelText: 'Póliza',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),// póliza

              SizedBox(height: 12.0),

              ListTile (                              // fixCombo (16 feb 2019): new variable
                leading: Icon(Icons.attach_file),
                title: DropdownButton<String> (
                  items: categorias.map((dynamic item){
                    return DropdownMenuItem<String>(
                      value: item.registro.toString(),
                      child: Text(item.descripcion),
                    );
                  }).toList(),

                  value: _categoria,
                  hint: new Text("Tipo de archivo"),
                  onChanged: (String newValueSelected) {
                    print(newValueSelected);
                    _onDropDownItemSelected(newValueSelected);
                  },
                ),
              ),// combo

              SizedBox(height: 12.0),

              Container (
                child: _documento == null
                    ? new Stack (
                  children: <Widget>[
                    Padding (
                      child: new Image.asset("assets/prueba.png"),
                      padding: EdgeInsets.all(12.0),
                    ),
                  ],
                )
                : new CircleAvatar(backgroundImage: new FileImage(_documento), radius: 140.0,),  // FOTO: Presenta la documento
//              : new Padding (
//                child: Image.asset( FileImage(_documento).toString(),width:100,height:100 ),
//                padding: EdgeInsets.only(bottom: 10.0),
//              ),
              )// imagen

            ],
        ),
        ),
      ),

      floatingActionButton:Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          FloatingActionButton (
            heroTag: null,
            child: Icon(Icons.add_a_photo, color: Colors.white,),
            backgroundColor: Colors.black38,
            onPressed: getImage,              // FOTO: llama la camara
            tooltip: 'Tomar foto',
          ),

          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.apps, color: Colors.white,),
            onPressed: () async {
            },
            tooltip: 'Subir de la galería',
          ),

          FloatingActionButton (
            heroTag: null,
            child: Icon(Icons.update,color: Colors.white,),
            onPressed: () async {

              String documentoOk='assets/person.jpg';
              if (_documento!=null) {
                documentoOk = _documento.path.toString();
              }
              print('Upadate <-- '+documentoOk );    // FOTO: Pasa el nombre del archivo a la DB

              Anexo ctv = Anexo (
                anexo:     _anexo,
                categoria: int.parse( _categoria.toString() ),     // fixCombo (16 feb 2019): new variable
                interno:   int.parse(_interno.text),

                documento: documentoOk,

              );
              if(widget.actual==null) {
                bloc.add(ctv);                            // Manejo DB Insertar
              }
              else {
                bloc.update(ctv);                         // Manejo DB Actualizar
              }
              Navigator.pop(context);                     // Regresa a la pantalla inicial
            },
          ),

        ],
      ),


    );

  } // Widget build

  void _onDropDownItemSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._categoria = newValueSelected;
    });
  }

  updateListView() async {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbAmparo.initDB();
    db.then((database) {
      Future<List<Categoria>> categoriaListFuture = dbAmparo.getCategoriaList();
      categoriaListFuture.then((categoriaList){
        setState(() {
          this.categorias = categoriaList;
        });
      });
    }
    );
  }

  void updateInputType({bool date, bool time}) {
//    date = date ?? inputType != InputType.time;
//    time = time ?? inputType != InputType.date;
//    setState(() => inputType =
//    date ? time ? InputType.both : InputType.date : InputType.time);
  }

}
// TODO: Add AccentColorOverride (103)
