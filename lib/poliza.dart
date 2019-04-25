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
import 'package:emision/polizaModelo/PolizaModel.dart';
import 'package:emision/polizaModelo/PolizaControler.dart';
import 'amparos.dart';                                     // (Verificar)
import 'package:sqflite/sqflite.dart';          // fixCombo (16 feb 2019): new variable

class Sede {
  const Sede(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

class Estado {
  const Estado(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

class Intermediario {
  const Intermediario(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

class Afianzado {
  const Afianzado(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}


class TipoPoliza {
  const TipoPoliza(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

class Contratante {
  const Contratante(this.registro,this.descripcion);
  final int    registro;
  final String descripcion;
}

Sede sede;
List<Sede> sedes = <Sede>[const Sede(16, 'Bogota norte'), const Sede(19, 'Bogota sur')];

Estado estado;
List<Estado> estados = <Estado>[const Estado(40, 'Nueva'), const Estado(41, 'Tramite'), const Estado(42, 'Expedida')];

Intermediario intermediario;
List<Intermediario> intermediarios = <Intermediario>[const Intermediario(16, 'Juan Camilo'), const Intermediario(19, 'Andrea')];

Afianzado afianzado;
List<Afianzado> afianzados = <Afianzado>[const Afianzado(1, 'Luis enrrique'), const Afianzado(2, 'Juan Carlos')];

TipoPoliza tipoPoliza;
List<TipoPoliza> tipoPolizas = <TipoPoliza>[const TipoPoliza(16, 'Particular'), const TipoPoliza(19, 'Estatal')];

Contratante contratante;
List<Contratante> contratantes = <Contratante>[const Contratante(1, 'Luis enrrique'), const Contratante(2, 'Juan Carlos')];

class PolizaPage extends StatefulWidget {

  Poliza actual;
  PolizaPage({Key key, @required this.actual}) : super(key: key);   // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _PolizaPageState createState() => _PolizaPageState();
}

class _PolizaPageState extends State<PolizaPage> {

  DBPoliza dbPoliza = DBPoliza();               // fixCombo (16 feb 2019): new variable
  List<Objeto> objetos;
  var _objeto = null;

  File _foto = null;                                        // FOTO: Variable

  int _poliza;
  //sede
  DateTime fechaEmision  = new DateTime.now();
  var _periodo           = TextEditingController();
  var _numero            = TextEditingController();
  var _temporario        = TextEditingController();
  // estado

  // intermediario
  var _comision          = TextEditingController();
  var _cupoOperativo     = TextEditingController();

  // afianzado NEW
  // tipoPoliza
  var _clausulado        = TextEditingController(); // new

  var _periodoEmision    = TextEditingController();
  var _retroactividad    = TextEditingController();
  DateTime fechaHoraInicial = DateTime.now();
  DateTime fechaHoraFinal   = DateTime.now();

  // contratante NEW
  // objeto
  var _numeroContrato   = TextEditingController();
  var _valorContrato    = TextEditingController();
  DateTime fechaInicial = new DateTime.now();
  DateTime fechaFinal   = new DateTime.now();

  final FocusNode _cupoOperativoFocus  = FocusNode();
  final FocusNode _comisionFocus       = FocusNode();
  final FocusNode _numeroFocus         = FocusNode();
  final FocusNode _temporarioFocus     = FocusNode();
  final FocusNode _clausuladoFocus     = FocusNode();
  final FocusNode _periodoFocus        = FocusNode();

  final FocusNode _retroactividadFocus = FocusNode();
  final FocusNode _periodoEmisionFocus = FocusNode();

  final FocusNode _numeroContratoFocus = FocusNode();
  final FocusNode _valorContratoFocus  = FocusNode();

  final bloc = PolizaBloc();  // Manejo DB

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  bool editable = false;

  void _actualizarFecha() {

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      int ano = fechaInicial.year;
      ano = ano +  int.parse(_periodo.text);

//

      fechaFinal = DateTime.parse(
        ano.toString()+'-'+
        fechaInicial.month.toString().padLeft(2,'0')+'-'+
        fechaInicial.day.toString().padLeft(2,'0')+' 00:00:00.000');
    });
  }

  @override
  void initState() {
    if(widget.actual==null) {                                 // Manejo DB es Insertar
      print('I N S E R T ...');

      _poliza = 0;
      fechaEmision          = new DateTime.now();
      _periodo.text         = '1';
      _numero.text          = '0';
      _temporario.text      = '0';

      _comision.text        = '10.00';
      _cupoOperativo.text   = '0';
      _clausulado.text       = 'Observación';

      _periodoEmision.text  = '1';
      _retroactividad.text  = '21';
      fechaHoraInicial      = new DateTime.now();
      fechaHoraFinal        = new DateTime.now();

      _numeroContrato.text = '0AZXXX999';
      _valorContrato.text  = '2000000.00';
      fechaInicial         = new DateTime.now();
      fechaFinal           = new DateTime.now();

      sede=sedes[0];
      estado=estados[0];

      intermediario=intermediarios[0];

      afianzado=afianzados[0];
      tipoPoliza=tipoPolizas[0];
      contratante=contratantes[0];
    }
    else {                                                    // Manejo DB es Actualizar
      print('U P D A T E ...');

      _poliza             = widget.actual.poliza;
      fechaEmision        = DateTime.parse(widget.actual.fechaEmision); // String -> DateTime
      _periodo.text       = widget.actual.periodo.toString();
      _numero.text        = widget.actual.numero.toString();
      _temporario.text    = widget.actual.temporario.toString();

      _comision.text      = widget.actual.comision.toString();
      _cupoOperativo.text = widget.actual.cupoOperativo.toString();

      _clausulado.text    = widget.actual.clausulado.toString();

      _objeto             = widget.actual.objeto.toString();             // fixCombo (16 feb 2019): load list

//        String algo     = nacimiento.toString();            // DateTime --> String
//        DateTime todayDate = DateTime.parse(String);

      _periodoEmision.text = widget.actual.periodoEmision.toString();
      _retroactividad.text  = widget.actual.retroactividad.toString();
      fechaHoraInicial            = DateTime.parse(widget.actual.fechaHoraInicial); // String -> DateTime
      fechaHoraFinal              = DateTime.parse(widget.actual.fechaHoraFinal);   // String -> DateTime

      _numeroContrato.text = widget.actual.numeroContrato.toString();
      _valorContrato.text  = widget.actual.valorContrato.toString();
      fechaInicial         = DateTime.parse(widget.actual.fechaInicial);      // String -> DateTime
      fechaFinal           = DateTime.parse(widget.actual.fechaFinal);        // String -> DateTime

      sede=sedes[0];
      estado=estados[0];

      intermediario=intermediarios[0];

      afianzado=afianzados[0];
      tipoPoliza=tipoPolizas[0];

      contratante=contratantes[0];

//      if (widget.actual.foto.toString() != 'assets/person.jpg') {
//        print('Recuperación '+widget.actual.foto.toString() );
//        _foto = File(widget.actual.foto.toString());          // FOTO: Pasa la imagen a la variable
//      }
//      else _foto = null;
    }
  }


  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;
    if(objetos == null) {                               // fixCombo (16 feb 2019): new variable
      objetos = List<Objeto>();
      updateListView();
    }

    Widget datosIdentificacion = ExpansionTile (
      initiallyExpanded: true,
      title: Text(
        "Identificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.home),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Sede>(
                  value: sede,
                  onChanged: (Sede newValue) {
                    setState(() {
                      sede = newValue;
                    });
                  },
                  items: sedes.map((Sede user) {
                    return new DropdownMenuItem<Sede>(
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
        ), // Sede

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaEmision,

          decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: 'Fecha emisión'),
          onChanged: (dt) => setState(() => fechaEmision = dt),
        ),// FechaEmisión

        new TextFormField(
          controller: _numero,
          decoration: const InputDecoration(
            hintText: 'Entre el número de la poliza',
            labelText: 'Número poliza',
          ),
          focusNode: _numeroFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _numeroFocus.unfocus();
            FocusScope.of(context).requestFocus(_temporarioFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// númeroPóliza

        new TextFormField(
          controller: _temporario,
          decoration: const InputDecoration(
            hintText: 'Entre el número temporario',
            labelText: 'Número temporario',
          ),
          focusNode: _temporarioFocus,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// temporario

        new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.check),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Estado>(
                  value: estado,
                  onChanged: (Estado newValue) {
                    setState(() {
                      estado = newValue;
                    });
                  },
                  items: estados.map((Estado user) {
                    return new DropdownMenuItem<Estado>(
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
        ),// estado

        new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
//                labelText: 'Objeto',
                icon: const Icon(Icons.person),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Intermediario>(
                  value: intermediario,
                  onChanged: (Intermediario newValue) {
                    setState(() {
                      intermediario = newValue;
                    });
                  },
                  items: intermediarios.map((Intermediario user) {
                    return new DropdownMenuItem<Intermediario>(
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
        ),// intermediario

        new TextFormField(
          controller: _comision,
          decoration: const InputDecoration(
            icon: const Icon(Icons.content_cut),
            hintText: 'Comisión',
            labelText: 'Comisión',
          ),
          focusNode: _comisionFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _comisionFocus.unfocus();
            FocusScope.of(context).requestFocus(_cupoOperativoFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// comisión

        new TextFormField(
          controller: _cupoOperativo,
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money),
            hintText: 'Cupo operativo',
            labelText: 'Cupo operativo',
          ),
          focusNode: _cupoOperativoFocus,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// cupoOperativo
      ],
    );

    Widget datosClasificacion = ExpansionTile (
      initiallyExpanded: true,
      title:  Text(
        "Clasificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [

        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Afianzado>(
                  value: afianzado,
                  onChanged: (Afianzado newValue) {
                    setState(() {
                      afianzado = newValue;
                    });
                  },
                  items: afianzados.map((Afianzado user) {
                    return new DropdownMenuItem<Afianzado>(
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
        ),// afianzado

        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
//                labelText: 'Objeto',
                icon: const Icon(Icons.public),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<TipoPoliza>(
                  value: tipoPoliza,
                  onChanged: (TipoPoliza newValue) {
                    setState(() {
                      tipoPoliza = newValue;
                    });
                  },
                  items: tipoPolizas.map((TipoPoliza user) {
                    return new DropdownMenuItem<TipoPoliza>(
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
        ),// tipoPóliza

        TextFormField(
          controller: _clausulado,
          decoration: const InputDecoration(
            icon: const Icon(Icons.format_list_bulleted),
            hintText: 'Modifique el clausulado',
            labelText: 'Detalle clausulado',
          ),

          focusNode: _clausuladoFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _retroactividadFocus.unfocus();
            FocusScope.of(context).requestFocus(_periodoEmisionFocus);
          },
          keyboardType: TextInputType.text,
        ),// clausulado

      ],
    );

    Widget datosPeriodo = ExpansionTile (
      initiallyExpanded: true,
      title: Text(
        "Vigencia",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [

        TextFormField(
          controller: _periodoEmision,
          decoration: const InputDecoration(
            hintText: 'Entre periodo de emisión',
            labelText: 'Periodo de emisión',
          ),
          focusNode: _periodoEmisionFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _periodoEmisionFocus.unfocus();
            FocusScope.of(context).requestFocus(_retroactividadFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// periodoEmisión

        TextFormField(
          controller: _retroactividad,
          decoration: const InputDecoration(
            hintText: 'Entre retroactividad',
            labelText: 'Retroactividad',
          ),
          focusNode: _retroactividadFocus,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// retroactividad

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaHoraInicial,
          decoration: InputDecoration(
              icon: const Icon(Icons.date_range),
              labelText: 'Fecha hora inicial'),
          onChanged: (dt) => setState(() => fechaHoraInicial = dt),

        ),

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaHoraFinal,
          decoration: InputDecoration(
              icon: const Icon(Icons.date_range),
              labelText: 'Fecha hora final'),
          onChanged: (dt) => setState(() => fechaHoraFinal = dt),

        ),

      ],
    );

    Widget datosContrato = ExpansionTile  (
      initiallyExpanded: true,
      title: Text(
        "Datos contrato",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [

        FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
//                labelText: 'Contratante',
                icon: const Icon(Icons.person),
              ),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Contratante>(
                  value: contratante,
                  onChanged: (Contratante newValue) {
                    setState(() {
                      contratante = newValue;
                    });
                  },
                  items: contratantes.map((Contratante user) {
                    return new DropdownMenuItem<Contratante>(
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
        ),// contratante

        ListTile (                              // fixCombo (16 feb 2019): new variable
          leading: Icon(Icons.location_city),
          title: DropdownButton<String> (
            items: objetos.map((dynamic item){
              return DropdownMenuItem<String>(
                value: item.registro.toString(),
                child: Text(item.descripcion),
              );
            }).toList(),
            value: _objeto,
            hint: new Text("Seleccione el objeto"),
            onChanged: (String newValueSelected) {
              print(newValueSelected);
              _onDropDownItemSelected(newValueSelected);
            },
          ),
        ),// objeto

        TextFormField(
          controller: _numeroContrato,
          decoration: const InputDecoration(
            icon: const Icon(Icons.work),
            hintText: 'Número del contrato',
            labelText: 'Número contrato',
          ),

          focusNode: _numeroFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _retroactividadFocus.unfocus();
            FocusScope.of(context).requestFocus(_valorContratoFocus);
          },
          keyboardType: TextInputType.text,
        ),// nùmeroContrato

        TextFormField(
          controller: _valorContrato,
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money),
            hintText: 'Valor del contrato',
            labelText: 'Valor contrato',
          ),
          focusNode: _valorContratoFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _retroactividadFocus.unfocus();
            FocusScope.of(context).requestFocus(_periodoFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// valorContrato

        new TextFormField(
          controller: _periodo,
          decoration: const InputDecoration(
            icon: const Icon(Icons.build),
            hintText: 'Entre el periodo',
            labelText: 'Periodo',
          ),
          focusNode: _periodoFocus,
          onFieldSubmitted: (_) {
            _periodoFocus.unfocus();
            _actualizarFecha();
          },

          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),// Periodo

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaInicial,
          decoration: InputDecoration(
              icon: const Icon(Icons.date_range),
              labelText: 'Fecha inicial'),
          onChanged: (dt) => setState(() => fechaInicial = dt),
        ),

        DateTimePickerFormField(
          inputType: inputType,
          format: formats[inputType],
          editable: editable,
          initialValue: fechaFinal,
          decoration: InputDecoration(
            icon: const Icon(Icons.date_range),
            labelText: 'Fecha final'),
          onChanged: (dt) => setState(() => fechaFinal = dt),
        ),

        Text(
          '$fechaFinal',
          style: Theme.of(context).textTheme.display1,
        ),

      ],
    );

    return new Scaffold(
        appBar: new AppBar(title: Text("Poliza")),
        body: new SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            children: <Widget>[

              SizedBox(height: 12.0),
              datosIdentificacion,

              SizedBox(height: 22.0),
              datosClasificacion,

              SizedBox(height: 22.0),
              datosPeriodo,

              SizedBox(height: 22.0),
              datosContrato,

              SizedBox(height: 74.0),

//            new Container(
//                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
//                child: new RaisedButton(
//                  child: const Text('Grabar'),
//                  onPressed: null,
//                )),

            ],
          ),
        ),

        floatingActionButton:Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.update, color: Colors.white,),
//                backgroundColor: Colors.black38,

                onPressed: () async {
                  String fotoOk='assets/person.jpg';
                  if (_foto!=null) {
                    fotoOk = _foto.path.toString();
                  }
                  print('Upadate <-- '+fotoOk );              // FOTO: Pasa el nombre del archivo a la DB

                  Poliza ctv = Poliza (
                      poliza:           _poliza,
                      sede:             sede.registro,
                      fechaEmision:     fechaEmision.toString(),
                      periodo:          int.parse(_periodo.text),
                      numero:           int.parse(_numero.text),
                      temporario:       int.parse(_temporario.text),
                      estado:           estado.registro,

                      intermediario:    intermediario.registro,
                      comision:         double.parse(_comision.text),
                      cupoOperativo:    int.parse(_cupoOperativo.text),

                      afianzado:        afianzado.registro,
                      tipoPoliza:       tipoPoliza.registro,
                      clausulado:       _clausulado.text,

                      periodoEmision:  int.parse(_periodoEmision.text),
                      retroactividad:   int.parse(_retroactividad.text),
                      fechaHoraInicial:fechaHoraInicial.toString(),
                      fechaHoraFinal:  fechaHoraFinal.toString(),

                      contratante:     contratante.registro,
                      objeto:          int.parse(_objeto.toString()),      // fixCombo (16 feb 2019): new variable
                      numeroContrato:  _numeroContrato.text,
                      valorContrato:   double.parse(_valorContrato.text),
                      fechaInicial:    fechaInicial.toString(),
                      fechaFinal:      fechaFinal.toString(),

                      sincronizar:      0
                  );

                  if(widget.actual==null) {                 // Manejo DB Insertar
                    bloc.add(ctv);
                  }
                  else {                                    // Manejo DB Actualizar
                    bloc.update(ctv);
                  }

                  Navigator.pop(context);                   // Regresa a la pantalla inicial
                },
              ),

            ]
        )

    );

  } // Widget build

  void updateInputType({bool date, bool time}) {
//    date = date ?? inputType != InputType.time;
//    time = time ?? inputType != InputType.date;
//    setState(() => inputType =
//    date ? time ? InputType.both : InputType.date : InputType.time);
  }

  void _onDropDownItemSelected(String newValueSelected) {   // fixCombo (16 feb 2019): new function
    setState(() {
      this._objeto = newValueSelected;
    });
  }

  updateListView() async {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbPoliza.initDB();
    db.then((database) {
      Future<List<Objeto>> objetoListFuture = dbPoliza.getObjetoList();
      objetoListFuture.then((objetoList){
        setState(() {
          this.objetos = objetoList;
        });
      });
    }
    );
  }


}
