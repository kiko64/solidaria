// Copyright 2020-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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
  List<EstadoCivil> estadoCiviles;
  List<Tipo> tipos;
  List<Clasificacion> clasificaciones;

  List<Municipio> municipios;
  List<Lugar> lugares;

  var _genero = null;
  var _estadoCivil = null;
  var _tipo = null;
  var _clasificacion = null;
  var _municipio = null;
  var _lugar = null;


  //---AutoComplete variables

  var intermedList = <String>[];
  String _intermediario = '';

  GlobalKey<AutoCompleteTextFieldState<String>> autoCompKey = new GlobalKey();

  AutoCompleteTextField searchTextField;





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
      _estadoCivil    = widget.actual.estadoCivil.toString();
      _tipo           = widget.actual.tipo.toString();
      _clasificacion  = widget.actual.clasificacion.toString();
      _municipio      = widget.actual.municipio.toString();
      _lugar          = widget.actual.lugar.toString();

    }
  }


  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;        // fixCombo (16 feb 2019): load list
    if(generos == null) {
      generos        = List<Genero>();
      estadoCiviles  = List<EstadoCivil>();
      tipos          = List<Tipo>();
      clasificaciones= List<Clasificacion>();
      municipios     = List<Municipio>();
      lugares        = List<Lugar>();

      generoListView();
      estadoCivilListView();
      tipoListView();
      clasificacionListView();
      municipioListView();
      lugarListView();
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

                    bloc.getValidarAuxiliar("identificacion = "+_id.text.trim() ).then((value) {
                      if ( int.parse('$value') >= 1 ) {
                        Fluttertoast.showToast( msg: "Auxiliar previamente registrado... ", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 2,
                            backgroundColor: Colors.redAccent, textColor: Colors.black, fontSize: 16.0 );
                        FocusScope.of(context).requestFocus(_idFocus);
                      }
                      else {
                        _idFocus.unfocus();
                        FocusScope.of(context).requestFocus(_nombresFocus);
                      }
                    }, onError: (error) {
                      Fluttertoast.showToast( msg: "Error de conexión, reintente nuevamente... ", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 2,
                          backgroundColor: Colors.redAccent, textColor: Colors.black, fontSize: 16.0 );
                    });

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

          SizedBox(height: 12.0),

          ListTile (                              // fixCombo (16 feb 2019): new variable
            leading: Icon(Icons.place),
            title: DropdownButton<String> (
              items: lugares.map((dynamic item){
                return DropdownMenuItem<String>(
                  value: item.registro.toString(),
                  child: Text(item.descripcion),
                );
              }).toList(),
              value: _lugar,
              hint: new Text("Lugar nacimiento         "),
              onChanged: (String newValueSelected) {
                var cual = lugares.where((registro) => registro == newValueSelected );
                _onDropDownLugarSelected(newValueSelected);
              },
            ),
          ),// lugar

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
              hint: new Text("Género                           "),
              onChanged: (String newValueSelected) {
                var cual = generos.where((registro) => registro == newValueSelected );
                _onDropDownGeneroSelected(newValueSelected);
              },
            ),
          ),// genero

          ListTile (                              // fixCombo (16 feb 2019): new variable
            leading: Icon(Icons.share),
            title: DropdownButton<String> (
              items: estadoCiviles.map((dynamic item){
                return DropdownMenuItem<String>(
                  value: item.registro.toString(),
                  child: Text(item.descripcion),
                );
              }).toList(),
              value: _estadoCivil,
              hint: new Text("Estado civil                   "),
              onChanged: (String newValueSelected) {
                var cual = estadoCiviles.where((registro) => registro == newValueSelected );
                _onDropDownEstadoCivilSelected(newValueSelected);
              },
            ),
          ),// estadoCivil

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

        ListTile (                              // fixCombo (16 feb 2019): new variable
          leading: Icon(Icons.contact_mail),
          title: DropdownButton<String> (
            items: tipos.map((dynamic item){
              return DropdownMenuItem<String>(
                value: item.registro.toString(),
                child: Text(item.descripcion),
              );
            }).toList(),
            value: _tipo,
            hint: new Text("Documento                   "),
            onChanged: (String newValueSelected) {
              var cual = tipos.where((registro) => registro == newValueSelected );
              _onDropDownTipoSelected(newValueSelected);
            },
          ),
        ),// tipo

        ListTile (                              // fixCombo (16 feb 2019): new variable
          leading: Icon(Icons.person),
          title: DropdownButton<String> (
            items: clasificaciones.map((dynamic item){
              return DropdownMenuItem<String>(
                value: item.registro.toString(),
                child: Text(item.descripcion),
              );
            }).toList(),
            value: _clasificacion,
            hint: new Text("Clasificación tercero   "),
            onChanged: (String newValueSelected) {

              print('Selecionado:'+newValueSelected);

              var cual = clasificaciones.where((registro) => registro == newValueSelected );
              print('Encontado:' +cual.toString());

              _onDropDownClasificacionSelected(newValueSelected);
            },
          ),
        ),// clasificacion

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

        SizedBox(height: 12.0),

        ListTile (                              // fixCombo (16 feb 2019): new variable
          leading: Icon(Icons.place),
          title: DropdownButton<String> (
            items: municipios.map((dynamic item){
              return DropdownMenuItem<String>(
                value: item.registro.toString(),
                child: Text(item.descripcion),
              );
            }).toList(),
            value: _municipio,
            hint: new Text("Residencia                   "),
            onChanged: (String newValueSelected) {
              var cual = municipios.where((registro) => registro == newValueSelected );
              _onDropDownMunicipioSelected(newValueSelected);
            },
          ),
        ),// municipio

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
                  tipo:             int.parse(_tipo.toString() ),    // fixCombo (16 feb 2019): new variable
                  clasificacion:    int.parse(_clasificacion.toString() ),
                  identificacion:   int.parse(_id.text),

                  primerNombre:    primerNombre,
                  segundoNombre:   segundoNombre,
                  primerApellido:  primerApellido,
                  segundoApellido: segundoApellido,
                  favorito:         _favorito.text.trim(),

                  foto:             fotoOk,

                  nacimiento:       nacimiento.toString(),
                  lugar:            int.parse(_lugar.toString() ),    // fixCombo (16 feb 2019): new variable

                  genero:           int.parse(_genero.toString() ),    // fixCombo (16 feb 2019): new variable
                  estadoCivil:      int.parse(_estadoCivil.toString()),// fixCombo (16 feb 2019): new variable


                  direccion:        _direccion.text.trim(),
                  municipio:        int.parse(_municipio.toString() ),
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

  void _onDropDownGeneroSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._genero = newValueSelected;
    });
  }

  void generoListView() {                                 // fixCombo (16 feb 2019): new function
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

  void _onDropDownEstadoCivilSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._estadoCivil = newValueSelected;
    });
  }

  void estadoCivilListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<EstadoCivil>> estadoCivilListFuture = dbProvider.getEstadoCivilList();
      estadoCivilListFuture.then((estadoCivilList){
        setState(() {
          this.estadoCiviles = estadoCivilList;
        });
      });
    }
    );
  }

  void _onDropDownTipoSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._tipo = newValueSelected;
    });
  }

  void tipoListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Tipo>> tipoListFuture = dbProvider.getTipoList();
      tipoListFuture.then((tipoList){
        setState(() {
          this.tipos = tipoList;
        });
      });
    }
    );
  }

  void _onDropDownClasificacionSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._clasificacion = newValueSelected;
    });
  }

  void clasificacionListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Clasificacion>> clasificacionListFuture = dbProvider.getClasificacionList();
      clasificacionListFuture.then((clasificacionList){
        setState(() {
          this.clasificaciones = clasificacionList;
        });
      });
    }
    );
  }

  void _onDropDownMunicipioSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._municipio = newValueSelected;
    });
  }

  void municipioListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Municipio>> municipioListFuture = dbProvider.getMunicipioList();
      municipioListFuture.then((municipioList){
        setState(() {
          this.municipios = municipioList;
        });
      });
    }
    );
  }

  void _onDropDownLugarSelected(String newValueSelected) { // fixCombo (16 feb 2019): new function
    setState(() {
      this._lugar = newValueSelected;
    });
  }

  void lugarListView() {                                 // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Lugar>> lugarListFuture = dbProvider.getLugarList();
      lugarListFuture.then((lugarList){
        setState(() {
          this.lugares = lugarList;
        });
      });
    }
    );
  }

}
