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

import 'package:emision/accionModelo/AccionModel.dart';
import 'package:emision/accionModelo/AccionControler.dart';


class Agenda {
  const Agenda(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

class Seguimiento {
  const Seguimiento(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

Agenda agenda;
List<Agenda> agendas = <Agenda>[const Agenda(4, 'Proceso'), const Agenda(5, 'Seguimiento')];

Seguimiento seguimiento;
List<Seguimiento> seguimientos = <Seguimiento>[const Seguimiento(16, 'Elaborado'), const Seguimiento(19, 'Cancelada')];


class AccionPage extends StatefulWidget {

  Accion actual;
  AccionPage({Key key, @required this.actual}) : super(key: key);   // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AccionPageState createState() => _AccionPageState();
}

class _AccionPageState extends State<AccionPage> {

  int _accion;

  final _detalle    = TextEditingController();

  final bloc = AccionBloc('');  // Manejo DB

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  bool editable = false;
  DateTime fecha = new DateTime.now();

  @override
  void initState() {
    if(widget.actual==null) {                             // Manejo DB es Insertar
      print('I N S E R T ...');

      _accion = 0;
      fecha   = new DateTime.now();

      agenda=agendas[0];
      seguimiento= seguimientos[0];
    }
    else {                                                // Manejo DB es Actualizar
      print('U P D A T E - T R A M I T E ...');

      _accion    = 0;
      print('<-fecha: '+widget.actual.fecha.toString());
      fecha      = DateTime.parse(widget.actual.fecha);   // String -> DateTime
      print('->fecha: '+fecha.toString());

      // String algo     = nacimiento.toString();         // DateTime --> String
      // DateTime todayDate = DateTime.parse(String);

      _detalle.text = widget.actual.detalle.toString();

      agenda     = agendas[1];
      seguimiento= seguimientos[1];

    }
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: Text("Gestionar")),
      body: new SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[

            SizedBox(height: 12.0),

            new Text(
              "Registro",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            new FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
//                    labelText: 'Agenda',
                    icon: const Icon(Icons.notifications_active),
                  ),

                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<Agenda>(
                      value: agenda,
                      onChanged: (Agenda newValue) {
                        setState(() {
                          agenda = newValue;
                        });
                      },

                      items: agendas.map((Agenda user) {
                        return new DropdownMenuItem<Agenda>(
                          value: user,
                          child: new Text(
                            user.descripcion,
                          ),
                        );
                      }).toList(),
                    ),

                  ),
                );
              },
            ),// FormField

            DateTimePickerFormField(
              inputType: inputType,
              format: formats[inputType],
              editable: editable,
              initialValue: fecha,

              decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText: 'Fecha'),
              onChanged: (dt) => setState(() => fecha = dt),

            ),


            new TextFormField(
              controller: _detalle,
              decoration: const InputDecoration(
                icon: const Icon(Icons.view_headline),
                hintText: 'Observación adicional',
                labelText: 'Comentario',
              ),
              keyboardType: TextInputType.text,
            ),


            new FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
//                    labelText: 'Seguimiento',
                    icon: const Icon(Icons.check),
                  ),

                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<Seguimiento>(
                      value: seguimiento,
                      onChanged: (Seguimiento newValue) {
                        setState(() {
                          seguimiento = newValue;
                        });
                      },

                      items: seguimientos.map((Seguimiento user) {
                        return new DropdownMenuItem<Seguimiento>(
                          value: user,
                          child: new Text(
                            user.descripcion,
                          ),
                        );
                      }).toList(),
                    ),

                  ),
                );
              },
            ),


            SizedBox(height: 22.0),

//            new Container(
//                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
//                child: new RaisedButton(
//                  child: const Text('Grabar'),
//                  onPressed: null,
//                )),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update,color: Colors.white,),
        onPressed: () async {

          Accion ctv = Accion (

            accion:      _accion,
            fecha:       fecha.toString(),

            agenda:      5,           // Seguimiento agenda.registro,

            categoria:   26,          // Tramite o Consulta
            usuario:     widget.actual.usuario,
            sincronizar: 0,

            interno:     widget.actual.interno,
            descripcion: widget.actual.descripcion,
            titulo     : widget.actual.titulo,
            subtitulo  : widget.actual.subtitulo,

            detalle:     _detalle.text.trim(),
            seguimiento: seguimiento.registro,
            procedencia: widget.actual.accion,
            posicion:    ''

          );

          if(widget.actual==null) {
            bloc.update(ctv);                         // Manejo DB Actualizar
          }
          else {
            bloc.add(ctv);                            // Manejo DB Insertar
          }

          Navigator.pop(context);                     // Regresa a la pantalla inicial
        },
      ),

    );

  } // Widget build

  void updateInputType({bool date, bool time}) {
//    date = date ?? inputType != InputType.time;
//    time = time ?? inputType != InputType.date;
//    setState(() => inputType =
//    date ? time ? InputType.both : InputType.date : InputType.time);
  }

}
// TODO: Add AccentColorOverride (103)
