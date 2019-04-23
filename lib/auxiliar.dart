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
import 'package:path_provider/path_provider.dart';
import 'package:emision/auxiliarModelo/AuxiliarModel.dart';
import 'package:emision/auxiliarModelo/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';          // fixCombo (16 feb 2019): new variable


class EstadoCivil {
  EstadoCivil(this.registro,this.descripcion);
  int    registro;
  String descripcion;
}

class Lugar {
  Lugar(this.registro,this.descripcion);
  int    registro;
  String descripcion;
}

class Municipio {
  Municipio(this.registro,this.descripcion);
  int    registro;
  String descripcion;
}

class Clasificacion {
  Clasificacion(this.registro,this.descripcion);
  int    registro;
  String descripcion;
}

class Tipo {
  Tipo(this.registro,this.descripcion);
  int    registro;
  String descripcion;
}

Clasificacion clasificacion;
List<Clasificacion> clasificaciones = <Clasificacion>[Clasificacion(14, 'Persona jurídica'), Clasificacion(15, 'Persona natural'), Clasificacion(13, 'Consorcio')];

Tipo tipo;
List<Tipo> tipos = <Tipo>[Tipo(2, 'Nit'), Tipo(1, 'Nit persona natural'), Tipo(3, 'Cedula de ciudadanía')];

EstadoCivil estadoCivil;
List<EstadoCivil> estadoCiviles = <EstadoCivil>[EstadoCivil(60, 'Casado'), EstadoCivil(61, 'Soltero')];

Lugar lugar;
List<Lugar> lugares = <Lugar>[Lugar(41, 'Ibagué'), Lugar(42, 'Bogota')];
//List<Lugar> lugares.add(await DBProvider.db.getAllRegistro(' where tabla=110 order by descripcion'));

Municipio municipio;
List<Municipio> municipios = <Municipio>[Municipio(27, 'Ibagué'), Municipio(28, 'Bogota')];

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class AuxiliarPage extends StatefulWidget {

  Auxiliar actual;
  AuxiliarPage({Key key, @required this.actual}) : super(key: key);   // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AuxiliarPageState createState() => _AuxiliarPageState();
}

class _AuxiliarPageState extends State<AuxiliarPage> {

  DBProvider dbProvider = DBProvider();         // fixCombo (16 feb 2019): new variable
  List<Genero> generos;
  var _genero = null;

  int _auxiliar;
  var _id         = TextEditingController();
  var _nombres    = TextEditingController();
  var _apellidos  = TextEditingController();
  final _favorito = TextEditingController();
  File _foto = null;                                        // FOTO: Variable

  var _direccion  = TextEditingController();
  var _movil      = TextEditingController();
  var _fijo       = TextEditingController();
  var _correo     = TextEditingController();
  var _documento = TextEditingController();

  final FocusNode _idFocus        = FocusNode();
  final FocusNode _nombresFocus   = FocusNode();
  final FocusNode _apellidosFocus = FocusNode();
  final FocusNode _favoritoFocus  = FocusNode();

  final FocusNode _movilFocus     = FocusNode();
  final FocusNode _fijoFocus      = FocusNode();
  final FocusNode _correoFocus    = FocusNode();
  final FocusNode _documentoFocus = FocusNode();

  final bloc = AuxiliarBloc();  // Manejo DB

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('dd-MM-yyyy'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  bool editable = false;
  DateTime nacimiento;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _foto = image;          // FOTO: Pasa la imagen a la variable
      print('Camara <-- '+_foto.path.toString() );

    }
    );
  }

  @override
  void initState() {
    if(widget.actual==null) { // Manejo DB es Insertar
      print('I N S E R T ...');
      _auxiliar = 0;
      nacimiento = new DateTime.now();

      estadoCivil=estadoCiviles[0];
      lugar=lugares[0];
      tipo=tipos[0];
      municipio=municipios[0];
      clasificacion=clasificaciones[0];
    }
    else {                    // Manejo DB es Actualizar
      print('U P D A T E ...');
      _auxiliar       = widget.actual.auxiliar;
      _id.text        = widget.actual.identificacion.toString();
      _nombres.text   = widget.actual.primerNombre+' '+widget.actual.segundoNombre;
      _apellidos.text = widget.actual.primerApellido+' '+widget.actual.segundoApellido;
      _favorito.text  = widget.actual.favorito;

      if (widget.actual.foto.toString() != 'assets/person.jpg') {
        print('Recuperación '+widget.actual.foto.toString() );
        _foto = File(widget.actual.foto.toString());              // FOTO: Pasa la imagen a la variable
      }
      else _foto = null;

      nacimiento      = DateTime.parse(widget.actual.nacimiento); // String -> DateTime
      //        String algo     = nacimiento.toString();          // DateTime --> String
      //        DateTime todayDate = DateTime.parse(String);

      _direccion.text = widget.actual.direccion;
      _movil.text     = widget.actual.movil;
      _fijo.text      = widget.actual.fijo;
      _correo.text    = widget.actual.correo;
      _documento.text = widget.actual.documento;

      _genero         = widget.actual.genero.toString();        // fixCombo (16 feb 2019): load list

      estadoCivil=estadoCiviles[0];

      lugar=lugares[0];
      tipo=tipos[0];
      municipio=municipios[0];
      clasificacion=clasificaciones[0];

      //      genero          = widget.actual.genero;
      //      lugar           = widget.actual.lugar;
      //      municipio       = widget.actual.municipio;
      //      clasificacion      = widget.actual.clasificacion;
      //      tipo             = widget.actual.tipo;
    }
  }


  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;        // fixCombo (16 feb 2019): load list
    if(generos == null) {
      generos = List<Genero>();
      updateListView();
    }

    Color color = Theme.of(context).primaryColor;

    Widget datosDescripcion = Container(

      child: Row(
        children: [

          Expanded(
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container (
                  child: _foto == null
                      ? new Stack(
                    children: <Widget>[
                      new Center(
                        child: new CircleAvatar(
                          radius: 56.0,
                          backgroundColor: Colors.black38,
                          child: new Image.asset("assets/photo_camera.png"),

                        ),
                      ),
                    ],
                  )
                      : new CircleAvatar(backgroundImage: new FileImage(_foto), radius: 56.0,),  // FOTO: Presenta la foto
                ),
              ],
            ),
          ),

/*
              child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),

              radius: 60.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/foto/imagen.jpg')

              CircleAvatar(
                radius: 20.0,
                child: Text('+'),
                foregroundColor: Theme.of(context).cardColor,
                backgroundColor: Theme.of(context).accentColor,
              ),
              _buildButtonColumn(Theme.of(context).accentColor, Icons.add, ''),

              Container(
                child: new RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  elevation: 4.0,
                  textColor: Theme.of(context).cardColor,
                  color: Theme.of(context).accentColor,
                  child: const Text('+'),
                  onPressed: () {
                    //do it
                    getImage;
                    tooltip: 'Tomar foto';
                  }
                ),
              ),
*/

          Text("  "),

          Expanded(
            flex: 2,
            child: Column(
              children: [
                new TextFormField(
                  controller: _id,
                  decoration: const InputDecoration(
                    hintText: 'Entre el número de identificación',
                    labelText: 'Identificación',
                  ),
                  focusNode: _idFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _idFocus.unfocus();
                    FocusScope.of(context).requestFocus(_nombresFocus);
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),

                new TextFormField(
                  controller: _nombres,
                  decoration: InputDecoration(
                    labelText: 'Nombres',
                  ),
                  focusNode: _nombresFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _nombresFocus.unfocus();
                    FocusScope.of(context).requestFocus(_apellidosFocus);
                  },
                ),


                new TextFormField(
                  controller: _apellidos,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
//                icon: const Icon(Icons.person),
                    hintText: 'Escriba ambos apellidos',
                  ),
                  focusNode: _apellidosFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _apellidosFocus.unfocus();
                    FocusScope.of(context).requestFocus(_favoritoFocus);
                  },
                ),


                new TextFormField(
                  controller: _favorito,
                  decoration: const InputDecoration(
                    labelText: 'Favorito',
                  ),
                  focusNode: _favoritoFocus,
                ),
              ],
            ),
          ),

        ], // Children
      ),
    );

    Widget datosAdicional = Container(

      child: Column(
        children: [

          DateTimePickerFormField(
            inputType: inputType,
            format: formats[inputType],
            editable: editable,
            initialValue: nacimiento,
//
//              initialValue: DateTime.now(),

            decoration: InputDecoration(
                icon: const Icon(Icons.calendar_today),
                labelText: 'Nacimiento'),
            onChanged: (dt) => setState(() => nacimiento = dt),
          ),

          new FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.place),
//                    hintText: 'Lugar de nacimiento',
//                    labelText: 'Lugar',
                ),

                child: new DropdownButtonHideUnderline(

                  child: new DropdownButton<Lugar>(
                    value: lugar,
                    onChanged: (Lugar newValue) {
                      setState(() {
                        lugar = newValue;
                      });
                    },
                    items: lugares.map((Lugar user) {
                      return new DropdownMenuItem<Lugar>(
                        value: user,
                        child: new Text(
                          user.descripcion,
//                            style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),


                ),
              );
            },
          ),

          ListTile (                              // fixCombo (16 feb 2019): new variable
            leading: Icon(Icons.wc),
            title: DropdownButton<String> (
              items: generos.map((dynamic item){
                return DropdownMenuItem<String>(
                  value: item.registro.toString(),
                  child: Text(item.descripcion),
                );
              }).toList(),
              value: _genero,
              hint: new Text("Seleccione el género"),
              onChanged: (String newValueSelected) {

                print('Selecionado:'+newValueSelected);

                var cual = generos.where((registro) => registro == newValueSelected );
                print('Encontado:' +cual.toString());

                _onDropDownItemSelected(newValueSelected);
              },
            ),
          ),


          new FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.share),
//                    labelText: 'Estado civil',
                ),

                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton<EstadoCivil>(
                    value: estadoCivil,
                    onChanged: (EstadoCivil newValue) {
                      setState(() {
                        estadoCivil = newValue;
                      });
                    },
                    items: estadoCiviles.map((EstadoCivil user) {
                      return new DropdownMenuItem<EstadoCivil>(
                        value: user,
                        child: new Text(
                          user.descripcion,
//                            style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),

                ),
              );
            },
          ),
//            new Text("Selecionado: ${estadoCivil.registro} (${estadoCivil.descripcion})"),


        ],
      ),
    );

    Widget datosIdentificacion = ExpansionTile (
      initiallyExpanded: true,
      title: Text(
        "Identificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
//                    labelText: 'Clasificacion',
              ),

              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<Clasificacion>(
                  value: clasificacion,
                  onChanged: (Clasificacion newValue) {
                    setState(() {
                      clasificacion = newValue;
                    });
                  },
                  items: clasificaciones.map((Clasificacion user) {
                    return new DropdownMenuItem<Clasificacion>(
                      value: user,
                      child: new Text(
                        user.descripcion,
//                            style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),

            );
          },
        ),

        new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.contact_mail),
//                    labelText: 'Tipo',
              ),
              child: new DropdownButtonHideUnderline(

                child: new DropdownButton<Tipo>(
                  value: tipo,
                  onChanged: (Tipo newValue) {
                    setState(() {
                      tipo = newValue;
                    });
                  },
                  items: tipos.map((Tipo user) {
                    return new DropdownMenuItem<Tipo>(
                      value: user,
                      child: new Text(
                        user.descripcion,
//                            style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),

              ),
            );
          },
        ),
        datosDescripcion,
        datosAdicional,
      ], // children principal

    );

    Widget datosContacto = ExpansionTile (
      initiallyExpanded: true,
      title: Text(
        "Contacto",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [

        new TextFormField(
          controller: _direccion,
          decoration: const InputDecoration(
            icon: const Icon(Icons.home),
            hintText: 'Dirección residencia',
            labelText: 'Dirección',
          ),
          keyboardType: TextInputType.text,
        ),

        new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                icon: const Icon(Icons.place),
//                    labelText: 'Municipio',
              ),
              child: new DropdownButtonHideUnderline(

                child: new DropdownButton<Municipio>(
                  value: municipio,
                  onChanged: (Municipio newValue) {
                    setState(() {
                      municipio = newValue;
                    });
                  },
                  items: municipios.map((Municipio user) {
                    return new DropdownMenuItem<Municipio>(
                      value: user,
                      child: new Text(
                        user.descripcion,
//                            style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),


              ),
            );
          },
        ),

        new TextFormField(
          controller: _movil,
          decoration: const InputDecoration(
            icon: const Icon(Icons.phone_iphone),
            hintText: 'Entre el número del teléfono',
            labelText: 'Móvil',
          ),

          focusNode: _movilFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _movilFocus.unfocus();
            FocusScope.of(context).requestFocus(_fijoFocus);
          },
          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

        new TextFormField(
          controller: _fijo,
          decoration: const InputDecoration(
            icon: const Icon(Icons.phone),
            hintText: 'Teléfono fijo',
            labelText: 'Fijo',
          ),

          focusNode: _fijoFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fijoFocus.unfocus();
            FocusScope.of(context).requestFocus(_correoFocus);
          },

          keyboardType: TextInputType.phone,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),

        new TextFormField(
          controller: _correo,
          decoration: const InputDecoration(
            icon: const Icon(Icons.email),
            hintText: 'Enter la dirección de correo electrónico',
            labelText: 'Correo',
          ),
          focusNode: _correoFocus,

          onFieldSubmitted: (term) {
            _fijoFocus.unfocus();
            FocusScope.of(context).requestFocus(_documentoFocus);
          },
          keyboardType: TextInputType.emailAddress,
        ),

        new TextFormField(
          controller: _documento,
          decoration: const InputDecoration(
            icon: const Icon(Icons.people),
            hintText: 'Enter el tipo de documento',
            labelText: 'Documento',
          ),
          focusNode: _documentoFocus,
          keyboardType: TextInputType.text,
        ),
      ],
    );

    return new Scaffold(

        appBar: new AppBar(
            title: Text("Registrar")
        ),

        body: new Container(     // Antes SafeArea
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            children: <Widget>[

              SizedBox(height: 12.0),
              datosIdentificacion,

              SizedBox(height: 18.0),
              datosContacto,

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
              child: Icon(Icons.add_a_photo,color: Colors.white,),
              backgroundColor: Colors.black38,

              onPressed: getImage,              // FOTO: llama la camara
              tooltip: 'Tomar foto',
            ),

            FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.update,color: Colors.white,),

              onPressed: () async{

                String primerNombre;
                String segundoNombre;
                if (_nombres.text.trim().indexOf(' ')>0 && _nombres.text.trim().length>0 ) { // Partir nombres en primero y segundo nombres
                  primerNombre  = _nombres.text.trim().substring(0, _nombres.text.trim().indexOf(' '));
                  segundoNombre = _nombres.text.trim().substring(_nombres.text.trim().indexOf(' ')+1);
                }
                else {
                  primerNombre  =  _nombres.text.trim();
                  segundoNombre = '';
                }

                String primerApellido;
                String segundoApellido;
                if (_apellidos.text.trim().indexOf(' ')>0 && _apellidos.text.trim().length>0 ) { // Si tiene segundo apellido
                  primerApellido  = _apellidos.text.trim().substring(0, _apellidos.text.trim().indexOf(' '));
                  segundoApellido = _apellidos.text.trim().substring(_apellidos.text.trim().indexOf(' ')+1);
                }
                else {
                  primerApellido  =  _apellidos.text.trim();
                  segundoApellido = '';
                }

                String fotoOk='assets/person.jpg';
                if (_foto!=null) {
                  fotoOk = _foto.path.toString();
                }
                print('Upadate <-- '+fotoOk );    // FOTO: Pasa el nombre del archivo a la DB

                Auxiliar rnd = Auxiliar(          // objeto
                  auxiliar:         _auxiliar,
                  tipo:             tipo.registro,
                  clasificacion:    clasificacion.registro,
                  identificacion:   int.parse(_id.text),

                  primerNombre:    primerNombre,
                  segundoNombre:   segundoNombre,
                  primerApellido:  primerApellido,
                  segundoApellido: segundoApellido,
                  favorito:         _favorito.text.trim(),

                  foto:             fotoOk,

                  nacimiento:       nacimiento.toString(),
                  lugar:            lugar.registro,

                  genero:           int.parse(_genero.toString() ),    // fixCombo (16 feb 2019): new variable

                  estadoCivil:      estadoCivil.registro,

                  direccion:        _direccion.text.trim(),
                  municipio:        municipio.registro,
                  movil:            _movil.text.trim(),
                  fijo:             _fijo.text.trim(),
                  correo:           _correo.text.trim(),

                  documento:        _documento.text.trim(),
                );

                if(widget.actual==null) {               // Manejo DB Insertar
                  bloc.add(rnd);
                }
                else {                                  // Manejo DB Actualizar
                  bloc.update(rnd);

//            bloc.delete(rnd.auxiliar);                // Manejo DB Borrar
//            Auxiliar rnd = testAuxiliar[math.Random().nextInt(testAuxiliar.length)];
//            await DBProvider.db.newAuxiliar(rnd);
//            Auxiliar rnd = testAuxiliar[math.Random().nextInt(testAuxiliar.length)];
                }

                Navigator.pop(context);                 // Regresa a la pantalla inicial

              },
            ),
          ],
        )

    );

  }

  void _onDropDownItemSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._genero = newValueSelected;
    });
  }

  void updateListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Genero>> generoListFuture = dbProvider.getGeneroList();
      generoListFuture.then((generoList){
        setState(() {
          this.generos = generoList;
        });
      });
    }
    );
  }

}
