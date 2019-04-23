
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

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:emision/amparoModelo/AmparoModel.dart';
import 'package:emision/amparoModelo/AmparoControler.dart';
import 'package:sqflite/sqflite.dart';          // fixCombo (16 feb 2019): new variable

class AmparoPage extends StatefulWidget {

  Amparo actual;
  int polizaActual;
  AmparoPage({@required this.actual, @required this.polizaActual }); // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AmparoPageState createState() => _AmparoPageState();
}

  class _AmparoPageState extends State<AmparoPage> {

  get polizaActual => null;
  //   'amparo ,orden ,poliza
  //   concepto ,fechaInicial ,fechaFinal, dias
  //   porcentaje ,valorAsegurado ,tasaAmparo ,prima

  DBAmparo dbAmparo = DBAmparo();               // fixCombo (16 feb 2019): new variable
  List<Concepto> conceptos;                     // fixCombo (16 feb 2019): new variable
  var _concepto = null;                         // fixCombo (16 feb 2019): new variable

  int _amparo;
  int _orden;
  var _poliza           = TextEditingController();

  DateTime fechaInicial = DateTime.now();
  DateTime fechaFinal   = DateTime.now();
  var _dias             = TextEditingController();

  var _porcentaje       = TextEditingController();
  var _valorAsegurado   = TextEditingController();
  var _tasaAmparo       = TextEditingController();
  var _prima            = TextEditingController();

  final FocusNode _diasFocus          = FocusNode();
  final FocusNode _porcentajeFocus    = FocusNode();
  final FocusNode _valorAseguradoFocus= FocusNode();
  final FocusNode _tasaAmparoFocus    = FocusNode();
  final FocusNode _primaFocus         = FocusNode();

  final bloc = AmparoBloc( 0 );                 // Manejo DB - llamado con el parametro de Póliza

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  bool editable = false;

  @override
  void initState() {
    if (widget.actual == null) {                // Manejo DB es Insertar
      print('I N S E R T ...');

      _amparo = 0;
      _orden  = 1;


      print('aqu es :' + this.widget.polizaActual.toString());
      _poliza.text = this.widget.polizaActual.toString();

      fechaInicial = DateTime.now();
      fechaFinal = DateTime.now();
      _dias.text = '1';

      _porcentaje.text   = '10.00';
      _valorAsegurado.text   = '20000000';
      _tasaAmparo.text = '12.50';
      _prima.text  = '10000000';
    }
    else { // Manejo DB es Actualizar
      print('U P D A T E ...');

      _amparo = widget.actual.amparo;
      _orden  = widget.actual.orden;
      _poliza.text = widget.actual.poliza.toString();

      _concepto    = widget.actual.concepto.toString();             // fixCombo (16 feb 2019): load list
      fechaInicial = DateTime.parse( widget.actual.fechaInicial);   // String -> DateTime
      fechaFinal   = DateTime.parse(widget.actual.fechaFinal);      // String -> DateTime
      _dias.text   = widget.actual.dias.toString();

      _porcentaje.text     = widget.actual.porcentaje.toString();
      _valorAsegurado.text = widget.actual.valorAsegurado.toString();
      _tasaAmparo.text     = widget.actual.tasaAmparo.toString();
      _prima.text          = widget.actual.prima.toString();
    }
  }

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;
    if(conceptos == null) {                               // fixCombo (16 feb 2019): new variable
      conceptos = List<Concepto>();
      updateListView();
    }

    Widget datosIdentificacion = ExpansionTile(

      initiallyExpanded: true,
      title: Text(
        "Identificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[

        TextField(
          enabled: false,
          controller: _poliza,
          decoration: const InputDecoration(
            icon: const Icon(Icons.list ),
            hintText: 'Número de póliza',
            labelText: 'Número de póliza',
          ),
        ),

      ],
    );

    Widget datosPeriodo = ExpansionTile(
      initiallyExpanded: true,

      title: Text(
        "Periodo",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      children: <Widget>[

        ListTile (                              // fixCombo (16 feb 2019): new variable
          leading: Icon(Icons.security),
          title: DropdownButton<String> (
            items: conceptos.map((dynamic item){
              return DropdownMenuItem<String>(
                value: item.registro.toString(),
                child: Text(item.descripcion),
              );
            }).toList(),
            value: _concepto,
            hint: new Text("Seleccione un amparo"),
            onChanged: (String newValueSelected) {
              print(newValueSelected);
              _onDropDownItemSelected(newValueSelected);
            },
          ),
        ),

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaInicial,
          decoration: InputDecoration(
              icon: const Icon(Icons.date_range ),
              labelText: 'Fecha inicial'
          ),
          onChanged: (dt) => setState(() => fechaInicial = dt),

        ),

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaFinal,
          decoration: InputDecoration(
              icon: const Icon(Icons.date_range ),
              labelText: 'Fecha final'),
          onChanged: (dt) => setState(() => fechaFinal = dt),

        ),

        TextFormField(
          controller: _dias,
          decoration: const InputDecoration(
            hintText: 'Ingrese días',
            labelText: 'Días de periodo',
          ),
          focusNode: _diasFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _porcentajeFocus.unfocus();
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

      ],
    );

    Widget datosValor = ExpansionTile(
      initiallyExpanded: true,

      title: Text(
        "Liquidación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[

        TextFormField(
          controller: _porcentaje,
          decoration: const InputDecoration(
            icon: const Icon(Icons.details),
            hintText: 'Porcentaje asegurable %',
            labelText: 'Porcentaje asegurable %',
          ),
          focusNode: _porcentajeFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _porcentajeFocus.unfocus();
            FocusScope.of(context).requestFocus(_valorAseguradoFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

        TextFormField(
          controller: _valorAsegurado,
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money ),
            hintText: 'Valor asegurado',
            labelText: 'Valor asegurado',
          ),
          focusNode: _valorAseguradoFocus,
          onFieldSubmitted: (term) {
            _valorAseguradoFocus.unfocus();
            FocusScope.of(context).requestFocus(_tasaAmparoFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

        TextFormField(
          controller: _tasaAmparo,
          decoration: const InputDecoration(
            icon: const Icon(Icons.details ),
            hintText: 'Tasa amparo %',
            labelText: 'Tasa amparo %',
          ),
          focusNode: _tasaAmparoFocus,
          onFieldSubmitted: (term) {
            _tasaAmparoFocus.unfocus();
            FocusScope.of(context).requestFocus(_primaFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

        TextFormField(
          controller: _prima,
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money ),
            hintText: 'Valor de la prima',
            labelText: 'Prima',
          ),
          focusNode: _primaFocus,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

      ],
    );

    // TODO: implement build
    return Scaffold (
      appBar: AppBar( title: Text("Amparo"), ),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[

            SizedBox(height: 12.0),
            datosIdentificacion,

            SizedBox(height: 22.0),
            datosPeriodo,

            SizedBox(height: 22.0),
            datosValor,

            SizedBox(height: 74.0),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update,color: Colors.white,),
        onPressed: () async {

          Amparo ctv = Amparo(
            amparo: _amparo,
            orden:  _orden,
            poliza: int.parse(_poliza.text ),

            concepto: int.parse(_concepto.toString()),      // fixCombo (16 feb 2019): new variable
            dias: int.parse(_dias.text ),
            fechaInicial: fechaInicial.toString(),
            fechaFinal: fechaFinal.toString(),

            porcentaje:   double.parse(_porcentaje.text),
            valorAsegurado:   double.parse(_valorAsegurado.text),
            tasaAmparo: double.parse(_tasaAmparo.text),
            prima:  double.parse(_prima.text),

          );

          if (widget.actual == null) {  // Manejo DB Insertar
            bloc.add( ctv );
          }
          else {                        // Manejo DB Actualizar
            bloc.update( ctv );
          }

          Navigator.pop(context);                 // Regresa a la pantalla inicial

          setState(() {});              // Manejo DB Refrescar
        },
      ),


    );
  }

  void updateInputType({bool date, bool time}) {
//    date = date ?? inputType != InputType.time;
//    time = time ?? inputType != InputType.date;
//    setState(() => inputType =
//    date ? time ? InputType.both : InputType.date : InputType.time);
    }

  void _onDropDownItemSelected(String newValueSelected) {   // fixCombo (16 feb 2019): new function
    setState(() {
      this._concepto = newValueSelected;
    });
  }

  updateListView() async {                                 // fixCombo (16 feb 2019): new function
   final Future<Database> db = dbAmparo.initDB();
   db.then((database) {
     Future<List<Concepto>> conceptoListFuture = dbAmparo.getConceptoList();
     conceptoListFuture.then((conceptoList){
       setState(() {
         this.conceptos = conceptoList;
       });
     });
   }
  );
 }

}