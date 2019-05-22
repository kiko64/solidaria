import 'dart:io';
import 'dart:convert';
import 'package:emision/utils/ui_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:emision/auxiliarModelo/AuxiliarModel.dart';
import 'package:emision/auxiliarModelo/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart'; // fixCombo (16 feb 2019): new variable
import 'package:fluttertoast/fluttertoast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class AuxiliarPage extends StatefulWidget {
  Auxiliar actual;

  AuxiliarPage({Key key, @required this.actual})
      : super(
            key:
                key); // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AuxiliarPageState createState() => _AuxiliarPageState();
}

class _AuxiliarPageState extends State<AuxiliarPage> {
  //Clave global para unificar la informacion de la forma
  static final GlobalKey<FormState> formKey = GlobalKey();

  //Definicion objeto tercero
  Auxiliar tercero;

  //Crea una instancia de la base de datos de Firebase
  final FirebaseDatabase database = FirebaseDatabase.instance;

  //Se definen las referencias a la base de datos Firebase
  DatabaseReference rootRef;
  DatabaseReference gAuxRef;
  DatabaseReference afianzRef;
  DatabaseReference intermRef;

  DBProvider dbProvider = DBProvider(); // fixCombo (16 feb 2019): new variable
  List<Genero> generos;
  List<EstadoCivil> estadoCiviles;
  List<Tipo> tipos;
  List<Documento> documentos = [
    Documento.withId(1, "Intermediario"),
    Documento.withId(2, "Afianzado"),
    Documento.withId(3, "Contratante")
  ];

  List<PuntoVenta> puntosVenta = [
    PuntoVenta.withId(1, "Agencia Yopal"),
    PuntoVenta.withId(2, "Agencia Cartagena"),
    PuntoVenta.withId(3, "Agencia Bucaramanga")
  ];

  List<Clasificacion> clasificaciones;

  List<Municipio> municipios;
  List<Lugar> lugares;

  var _genero = null;
  var _estadoCivil = null;
  var _tipo = null;
  var _clasificacion = "";
  var _municipio = null;
  var _lugar = "";
  var _documento = "";
  var _documentoObj;

  var _tipoObj;
  var _clasificacionObj;
  var _lugarObj;
  var _generoObj;
  var _estadoCivilObj;
  var _municipioObj;
  var _puntoVentaObj;

  var _puntoVenta = null;

  //---AutoComplete variables

  var intermedList = <String>[];
  String _intermediario = '';

  GlobalKey<AutoCompleteTextFieldState<Lugar>> autoCompKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Municipio>> autoCompKeyMunicipio =
      new GlobalKey();

  AutoCompleteTextField lugarSearch;
  AutoCompleteTextField municipioSearch;

  DropdownButtonFormField prueba;

  TextEditingController controller = new TextEditingController();

  int _auxiliar;
  var _id = TextEditingController();
  var _nombres = TextEditingController();
  var _apellidos = TextEditingController();
  final _favorito = TextEditingController();
  File _foto = null; // FOTO: Variable

  var _direccionController = TextEditingController();
  var _movilController = TextEditingController();
  var _fijoController = TextEditingController();
  var _correoController = TextEditingController();
  var _documentoController = TextEditingController();

  TextEditingController _controllerLugarNacimiento = TextEditingController();

  //Controladores Widget Intermediario
  var _agenciaController = TextEditingController();
  var _claveController = TextEditingController();
  var _comCumplimientoController = TextEditingController();
  var _delegacionCumplController = TextEditingController();

  //Controladores Widget Afianzado
  var _cupoOperativoController = TextEditingController();
  var _cumuloActualController = TextEditingController();

  final FocusNode _idFocus = FocusNode();
  final FocusNode _nombresFocus = FocusNode();
  final FocusNode _apellidosFocus = FocusNode();
  final FocusNode _favoritoFocus = FocusNode();

  final FocusNode _movilFocus = FocusNode();
  final FocusNode _fijoFocus = FocusNode();
  final FocusNode _correoFocus = FocusNode();
  final FocusNode _documentoFocus = FocusNode();

  final bloc = AuxiliarBloc(); // Manejo DB


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
      _foto = image; // FOTO: Pasa la imagen a la variable
      print('Camara <-- ' + _foto.path.toString());
    });
  }

  @override
  void initState() {
    //Metodos de llenado de listas para ComboBox
    generoListView();
    estadoCivilListView();
    tipoListView();
    clasificacionListView();
    municipioListView();
    lugarListView();

    //Inicializa el objeto tercero
    tercero = Auxiliar(favorito: "Ninguno");

    //Root reference Firebase
    rootRef = database.reference();
    //Referencia a g_auxiliar
    gAuxRef = database.reference().child("g_auxiliar");

    //Firebase reference for Intermadiarios
    afianzRef = gAuxRef.child("Intermediario");

    //Firebase reference for Afianzados
    afianzRef = gAuxRef.child("Afianzado");

    if (widget.actual == null) {
      // Manejo DB es Insertar
      print('I N S E R T ...');
      _auxiliar = 0;
      nacimiento = new DateTime.now();
    } else {
      // Manejo DB es Actualizar
      print('U P D A T E ...');

      _documento = widget.actual.documento;
      //TODO Crear una vista que incluya las descripciones de los campos con el mismo nombre
      _tipo = widget.actual.tipo.toString(); // widget.actual.descPuntoVenta;
      _clasificacion = widget.actual.clasificacion.toString();
      _auxiliar = widget.actual.auxiliar;
      _id.text = widget.actual.identificacion.toString();
      _nombres.text =
          widget.actual.primerNombre; //+ " " + widget.actual.segundoNombre;
      _apellidos.text =
          widget.actual.primerApellido; //+ " " + widget.actual.segundoApellido;
      _favorito.text = widget.actual.favorito;
/*
      if (widget.actual.foto.toString() != 'assets/person.jpg') {
        print('Recuperación ' + widget.actual.foto.toString());
        _foto = File(widget.actual.foto
            .toString()); // FOTO: Pasa la imagen a la variable
      } else
        _foto = null;
*/

       //Se añade prueba de null para el caso de seleccionar una persona juridica

      nacimiento = widget.actual.nacimiento ==null ? DateTime.now() :
          DateTime.parse(widget.actual.nacimiento); // String -> DateTime
      //        String algo     = nacimiento.toString();          // DateTime --> String
      //        DateTime todayDate = DateTime.parse(String);

      _direccionController.text = widget.actual.direccion;
      _movilController.text = widget.actual.movil;
      _fijoController.text = widget.actual.fijo;
      _correoController.text = widget.actual.correo;
      _documentoController.text = widget.actual.documento;

      _genero = widget.actual.genero.toString(); // fixCombo (16 feb 2019): load list
      _estadoCivil = widget.actual.estadoCivil.toString();

      //TODO Revisar la asignacion de clasificacion
      //_clasificacion = widget.actual.clasificacion.toString();
      _municipio = widget.actual.municipio.toString();
      _lugar = widget.actual.lugar.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        Theme.of(context).textTheme.title; // fixCombo (16 feb 2019): load list
    if (generos == null) {
      generos = List<Genero>();
      estadoCiviles = List<EstadoCivil>();
      tipos = List<Tipo>();
      clasificaciones = List<Clasificacion>();
      municipios = List<Municipio>();
      lugares = List<Lugar>();

      //Metodos de llenado de listas para ComboBox
      generoListView();
      estadoCivilListView();
      tipoListView();
      clasificacionListView();
      municipioListView();
      lugarListView();
    }

    Color color = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(title: Text("Nuevo Tercero")),
        body: Form(
          key: formKey,
          // Antes SafeArea
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            children: <Widget>[
              SizedBox(height: 12.0),
              //Datos Identificacion ____________________________________________________________________________________
              Center(
                child: Text(
                  "Identificación",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: amarilloSolidaria1),
                ),
              ),
              DropdownButtonFormField<Documento>(
                decoration: InputDecoration(
                    hintText:
                        widget.actual == null ? "Tipo Tercero" : _documento,
                    hintStyle: widget.actual != null
                        ? TextStyle(color: azulSolidaria1)
                        : null,
                    icon: Icon(Icons.person_outline)),
                items: documentos.map((Documento item) {
                  return DropdownMenuItem<Documento>(
                    value: item,
                    child: Text(item.descripcion),
                  );
                }).toList(),
                value: _documentoObj,
                //hint: new Text("Tipo Tercero"),
                onSaved: (Documento valueSaved) {
                  tercero.documento = valueSaved.descripcion;
                },
                validator: (val) => val == null ? "Campo obligatorio" : null,
                onChanged: (Documento newValueSelected) {
                  setState(() {
                    _documentoObj = newValueSelected;
                    _documento = newValueSelected.registro.toString();
                  });
                },
              ),
              DropdownButtonFormField<Tipo>(
                  decoration: InputDecoration(
                      hintText:
                          widget.actual == null ? "Tipo Documento" : _tipo,
                      hintStyle: widget.actual != null
                          ? TextStyle(color: azulSolidaria1)
                          : null,
                      icon: Icon(Icons.contact_mail)),
                  value: _tipoObj,
                  onChanged: (Tipo newValue) {
                    setState(() {
                      _tipoObj = newValue;
                    });
                  },
                  onSaved: (val) {
                    tercero.tipo = val.registro;
                    tercero.descTipo = val.descripcion;
                  },
                  validator: (val) => val == null ? "Campo obligatorio" : null,
                  items: tipos.map((Tipo user) {
                    return DropdownMenuItem<Tipo>(
                      value: user,
                      child: Text(
                        user.descripcion,
                      ),
                    );
                  }).toList()),
              // TipoDocumento

              DropdownButtonFormField<Clasificacion>(
                decoration: InputDecoration(
                    hintText: widget.actual == null
                        ? "Clasificacion tercero"
                        : _clasificacion,
                    hintStyle: widget.actual != null
                        ? TextStyle(color: azulSolidaria1)
                        : null,
                    icon: Icon(Icons.person)),
                items: clasificaciones.map((Clasificacion item) {
                  return DropdownMenuItem<Clasificacion>(
                    value: item,
                    child: Text(item.descripcion),
                  );
                }).toList(),
                value: _clasificacionObj,
                onSaved: (val) {
                  tercero.clasificacion = val.registro;
                  print("Clasificacion en tercero = ${tercero.clasificacion}");
                  tercero.descClasificacion = val.descripcion;
                },
                validator: (val) => val == null ? "Campo obligatorio" : null,
                onChanged: (Clasificacion user) {
                  setState(() {
                    _clasificacionObj = user;
                    _clasificacion = user.registro.toString();
                  });
                },
              ),
              //Clasificacion,
              TextFormField(
                controller: _id,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el número de identificación',
                  labelText: 'Identificación',
                ),
                onSaved: (val) => tercero.identificacion = int.parse(val),
                //TODO ver si la validacion va aca en o en onFieldSubmitted
                validator: (val) => val == "" ? val : null,
                focusNode: _idFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  bloc
                      .getValidarAuxiliar("identificacion = ${_id.text.trim()}")
                      .then((value) {
                    if (int.parse('$value') >= 1) {
                      Fluttertoast.showToast(
                          msg: "Auxiliar previamente registrado... ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 2,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.black,
                          fontSize: 16.0);
                      FocusScope.of(context).requestFocus(_idFocus);
                    } else {
                      _idFocus.unfocus();
                      FocusScope.of(context).requestFocus(_nombresFocus);
                    }
                  }, onError: (error) {
                    Fluttertoast.showToast(
                        msg: "Error de conexión, reintente nuevamente... ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  });
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              TextFormField(
                controller: _nombres,
                decoration: InputDecoration(
                  labelText: 'Nombres/Razon Social',
                ),
                focusNode: _nombresFocus,
                textInputAction: TextInputAction.next,
                onSaved: (val) => tercero.primerNombre = val,
                validator: (val) => val == "" ? val : null,
                onFieldSubmitted: (term) {
                  _nombresFocus.unfocus();
                  FocusScope.of(context).requestFocus(_apellidosFocus);
                },
              ),

              //Datos Adicionales _______________________________________________________________________________________
              _clasificacion == '54'
                  ? Column(
                      children: [
                        TextFormField(
                          controller: _apellidos,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
//                icon: const Icon(Icons.person),
                            hintText: 'Escriba ambos apellidos',
                          ),
                          focusNode: _apellidosFocus,
                          textInputAction: TextInputAction.next,
                          //TODO como se dividen los nombres y apellidos si se ingresa junto
                          onSaved: (val) => tercero.primerApellido = val,
                          validator: (val) => val == "" ? val : null,
                          onFieldSubmitted: (term) {
                            _apellidosFocus.unfocus();
                            FocusScope.of(context).requestFocus(_favoritoFocus);
                          },
                        ),
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
                          onSaved: (val) => tercero.nacimiento = val.toString(),
                          //TODO confirmar si la validacion de fechas es con null
                          validator: (val) =>
                              val == null ? val.toString() : null,
                        ),

                        SizedBox(height: 12.0),

                        DropdownButtonFormField<Genero>(
                            decoration: InputDecoration(
                                hintText:
                                    widget.actual == null ? "Genero" : _genero,
                                hintStyle: widget.actual != null
                                    ? TextStyle(color: azulSolidaria1)
                                    : null,
                                icon: Icon(Icons.wc)),
                            value: _generoObj,
                            onChanged: (Genero newValue) {
                              setState(() {
                                _generoObj = newValue;
                              });
                            },
                            onSaved: (val) {
                              tercero.genero = val.registro;
                              tercero.descGenero = val.descripcion;
                            },
                            validator: (val) => val.descripcion == ""
                                ? "Campo obligatorio"
                                : null,
                            items: generos.map((Genero user) {
                              return DropdownMenuItem<Genero>(
                                value: user,
                                child: Text(
                                  user.descripcion,
                                ),
                              );
                            }).toList()),
                        // TipoDocumento

                        DropdownButtonFormField<EstadoCivil>(
                            decoration: InputDecoration(
                                hintText: widget.actual == null
                                    ? "Estado Civil"
                                    : _estadoCivil,
                                hintStyle: widget.actual != null
                                    ? TextStyle(color: azulSolidaria1)
                                    : null,
                                icon: Icon(Icons.share)),
                            value: _estadoCivilObj,
                            onChanged: (EstadoCivil newValue) {
                              setState(() {
                                _estadoCivilObj = newValue;
                              });
                            },
                            onSaved: (val) {
                              tercero.estadoCivil = val.registro;
                              tercero.descEstadoCivil = val.descripcion;
                            },
                            validator: (val) => val.descripcion == ""
                                ? "Campo obligatorio"
                                : null,
                            items: estadoCiviles.map((EstadoCivil user) {
                              return DropdownMenuItem<EstadoCivil>(
                                value: user,
                                child: Text(
                                  user.descripcion,
                                ),
                              );
                            }).toList()),
                        // TipoDocumento

//            new Text("Selecionado: ${estadoCivil.registro} (${estadoCivil.descripcion})"),
                      ],
                    )
                  : Container(),

              SizedBox(height: 18.0),

              //Datos Contacto____________________________________________________________________________________
              Center(
                child: Text(
                  "Contacto",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: amarilloSolidaria1),
                ),
              ),
              //TODO Esta municipio del afianzado pero no la ciudad,

              DropdownButtonFormField<Lugar>(
                  hint: Text("Lugar"),
                  value: _lugarObj,
                  onChanged: (Lugar newValue) {
                    setState(() {
                      _lugarObj = newValue;
                    });
                  },
                  onSaved: (val) {
                    tercero.lugar = val.registro;
                    tercero.descLugar = val.descripcion;
                    tercero.municipio = val.registro;
                    tercero.descMunicipio = val.descripcion;
                  },
                  validator: (val) =>
                  val.descripcion == "" ? "Campo obligatorio" : null,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.place),
                  ),
                  items: lugares.map((Lugar user) {
                    return DropdownMenuItem<Lugar>(
                      value: user,
                      child: Text(
                        user.descripcion,
                      ),
                    );
                  }).toList()),
              // Lugar Dropbox



              lugarSearch = AutoCompleteTextField<Lugar>(
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: widget.actual == null ? "Ciudad" : _lugar,
                    hintStyle: widget.actual != null
                        ? TextStyle(color: azulSolidaria1)
                        : null,
                    icon: Icon(Icons.place),
                    suffixIcon: Container(
                      width: 85.0,
                      height: 60.0,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    filled: false,
                  ),
                  itemSubmitted: (item) {
                    setState(() {
                      lugarSearch.textField.controller.text = item.descripcion;
                      tercero.lugar = item.registro;
                      tercero.descLugar = item.descripcion;
                      tercero.municipio = item.registro;
                      tercero.descMunicipio = item.descripcion;
                    });
                  },
                  clearOnSubmit: false,
                  key: autoCompKey,
                  suggestions: lugares,
                  itemBuilder: (context, item) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.registro.toString(),
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                        Text(item.descripcion)
                      ],
                    );
                  },
                  itemSorter: (a, b) {
                    return a.descripcion.compareTo(b.descripcion);
                  },
                  itemFilter: (item, query) {
                    return item.descripcion
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }),

              TextFormField(
                controller: _direccionController,
                onSaved: (val) => tercero.direccion = val,
                validator: (val) => val == "" ? val : null,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.home),
                  hintText: 'Dirección',
                  labelText: 'Dirección',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 12.0),

              new TextFormField(
                controller: _movilController,
                onSaved: (val) => tercero.movil = val,
                validator: (val) => val == "" ? val : null,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone_iphone),
                  hintText: 'Ingrese el número del teléfono',
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
                controller: _fijoController,
                onSaved: (val) => tercero.fijo = val,
                validator: (val) => val == "" ? val : null,
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
                controller: _correoController,
                onSaved: (val) => tercero.correo = val,
                validator: (val) => val == "" ? val : null,
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

              SizedBox(height: 18.0),

              //Datos Intermediario_______________________________________________________________________________

              _documento == '1'
                  ? Column(children: <Widget>[
                      //TODO Agencia,    ,Clave, comCumplimiento, delegacion  como TextFormField

                      //Agencia
                      //TODO Revisar si Agencia debe tener registro y descripcion
                      //TODO Agencia ya esta definido en Primer Nombre no?

                      Text(
                        "Datos Intermediario",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: amarilloSolidaria1),
                      ),

                      TextFormField(
                        controller: _agenciaController,
                        onSaved: (val) => tercero.descAgencia = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person_outline),
                          hintText: 'Razón social de la Agencia de Venta',
                          labelText: 'Agencia',
                        ),
                        keyboardType: TextInputType.text,
                      ),

                      //Punto de Venta
                      DropdownButtonFormField<PuntoVenta>(
                          hint: Text("Punto de venta"),
                          value: _puntoVentaObj,
                          onChanged: (PuntoVenta newValue) {
                            setState(() {
                              _puntoVentaObj = newValue;
                            });
                          },
                          onSaved: (val) {
                            tercero.puntoVenta = val.registro;
                            tercero.descPuntoVenta = val.descripcion;
                          },
                          validator: (val) =>
                              val.descripcion == "" ? val.descripcion : null,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.home),
                          ),
                          items: puntosVenta.map((PuntoVenta user) {
                            return DropdownMenuItem<PuntoVenta>(
                              value: user,
                              child: Text(
                                user.descripcion,
                              ),
                            );
                          }).toList()),
                      // Clasificación

                      //Clave de intermediario
                      TextFormField(
                        controller: _claveController,
                        onSaved: (val) => tercero.clave = int.parse(val),
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.vpn_key),
                          hintText: 'Clave de intermediario',
                          labelText: 'Clave de intermediario',
                        ),
                        keyboardType: TextInputType.text,
                      ),

                      //Comisión Cumplimiento
                      TextFormField(
                        controller: _comCumplimientoController,
                        onSaved: (val) =>
                            tercero.comCumplimiento = double.parse(val),
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.check_circle_outline),
                          hintText: 'Comision Cumplimiento',
                          labelText: 'Comisión Cumplimiento',
                        ),
                        keyboardType: TextInputType.number,
                      ),

                      //Delegacion Cumplimiento
                      TextFormField(
                        controller: _delegacionCumplController,
                        onSaved: (val) =>
                            tercero.delegacionCumpl = int.parse(val),
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.account_balance),
                          hintText: 'Delegacion Cumplimiento',
                          labelText: 'Delegacion Cumplimiento',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ])
                  : Container(),

              //Datos Afianzado __________________________________________________________________________________

              SizedBox(height: 18.0),
              _documento == '2'
                  ? Column(children: <Widget>[
                      Text(
                        "Datos Afianzado",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: amarilloSolidaria1),
                      ),
                      TextFormField(
                        controller: _cupoOperativoController,
                        onSaved: (val) =>
                            tercero.cupoOperativo = int.parse(val),
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.account_balance),
                          hintText: 'Delegacion Cumplimiento',
                          labelText: 'Delegacion Cumplimiento',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: _cumuloActualController,
                        onSaved: (val) {
                          tercero.cumuloActual = int.parse(val);
                          tercero.cupoDisponible =
                              tercero.cupoOperativo - tercero.cumuloActual;
                        },
                        validator: (val) => val == "" ? val : null,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.account_balance),
                          hintText: 'Cumulo Actual',
                          labelText: 'Cumulo Actual',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ])
                  : Container(),

//            new Container(
//                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
//                child: new RaisedButton(
//                  child: const Text('Grabar'),
//                  onPressed: null,
//                )),
            ],
          ),
        ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              backgroundColor: Colors.black38,

              onPressed: getImage,
              // FOTO: llama la camara
              tooltip: 'Tomar foto',
            ),
            FloatingActionButton(
              heroTag: null,
              child: Icon(
                Icons.update,
                color: Colors.white,
              ),
              onPressed: () async {
                String primerNombre;
                String segundoNombre;
                if (_nombres.text.trim().indexOf(' ') > 0 &&
                    _nombres.text.trim().length > 0) {
                  // Partir nombres en primero y segundo nombres
                  primerNombre = _nombres.text
                      .trim()
                      .substring(0, _nombres.text.trim().indexOf(' '));
                  segundoNombre = _nombres.text
                      .trim()
                      .substring(_nombres.text.trim().indexOf(' ') + 1);
                } else {
                  primerNombre = _nombres.text.trim();
                  segundoNombre = '';
                }

                String primerApellido;
                String segundoApellido;
                if (_apellidos.text.trim().indexOf(' ') > 0 &&
                    _apellidos.text.trim().length > 0) {
                  // Si tiene segundo apellido
                  primerApellido = _apellidos.text
                      .trim()
                      .substring(0, _apellidos.text.trim().indexOf(' '));
                  segundoApellido = _apellidos.text
                      .trim()
                      .substring(_apellidos.text.trim().indexOf(' ') + 1);
                } else {
                  primerApellido = _apellidos.text.trim();
                  segundoApellido = '';
                }

                String fotoOk = 'assets/person.jpg';
                if (_foto != null) {
                  fotoOk = _foto.path.toString();
                }
                print('Upadate <-- ' +
                    fotoOk); // FOTO: Pasa el nombre del archivo a la DB
/*
                Auxiliar rnd = Auxiliar(
                  // objeto
                  auxiliar: _auxiliar,
                  tipo: _tipo,
                  // fixCombo (16 feb 2019): new variable
                  clasificacion: int.parse(_clasificacion.toString()),
                  identificacion: int.parse(_id.text),

                  primerNombre: primerNombre,
                  segundoNombre: segundoNombre,
                  primerApellido: primerApellido,
                  segundoApellido: segundoApellido,
                  favorito: _favorito.text.trim(),

                  foto: fotoOk,

                  nacimiento: nacimiento.toString(),
                  lugar: _lugar,
                  // fixCombo (16 feb 2019): new variable

                  genero: int.parse(_genero.toString()),
                  // fixCombo (16 feb 2019): new variable
                  estadoCivil: int.parse(_estadoCivil.toString()),
                  // fixCombo (16 feb 2019): new variable

                  direccion: _direccionController.text.trim(),
                  municipio: int.parse(_municipio.toString()),
                  movil: _movilController.text.trim(),
                  fijo: _fijoController.text.trim(),
                  correo: _correoController.text.trim(),

                  documento: _documentoController.text.trim(),
                );
*/
                if (widget.actual == null) {
                  // Manejo DB Insertar
                  await handelSubmit();
                  bloc.add(tercero);
                } else {
                  // Manejo DB Actualizar
                  bloc.update(tercero);

//            bloc.delete(rnd.auxiliar);                // Manejo DB Borrar
//            Auxiliar rnd = testAuxiliar[math.Random().nextInt(testAuxiliar.length)];
//            await DBProvider.db.newAuxiliar(rnd);
//            Auxiliar rnd = testAuxiliar[math.Random().nextInt(testAuxiliar.length)];
                }

                Navigator.pop(context); // Regresa a la pantalla inicial
              },
            ),
          ],
        ));
  }

  void _onDropDownGeneroSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._genero = newValueSelected;
    });
  }

  void generoListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Genero>> generoListFuture = dbProvider.getGeneroList();
      generoListFuture.then((generoList) {
        setState(() {
          this.generos = generoList;
        });
      });
    });
  }

  void _onDropDownEstadoCivilSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._estadoCivil = newValueSelected;
    });
  }

  void estadoCivilListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<EstadoCivil>> estadoCivilListFuture =
          dbProvider.getEstadoCivilList();
      estadoCivilListFuture.then((estadoCivilList) {
        setState(() {
          this.estadoCiviles = estadoCivilList;
        });
      });
    });
  }

  void _onDropDownTipoSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._tipo = newValueSelected;
    });
  }

  void tipoListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Tipo>> tipoListFuture = dbProvider.getTipoList();
      tipoListFuture.then((tipoList) {
        setState(() {
          this.tipos = tipoList;
        });
      });
    });
  }

  void _onDropDownClasificacionSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._clasificacion = newValueSelected;
    });
  }

  void clasificacionListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Clasificacion>> clasificacionListFuture =
          dbProvider.getClasificacionList();
      clasificacionListFuture.then((clasificacionList) {
        setState(() {
          this.clasificaciones = clasificacionList;
        });
      });
    });
  }

  void _onDropDownDocumentoSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._documento = newValueSelected;
    });
  }

  void _onDropDownMunicipioSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._municipio = newValueSelected;
    });
  }

  void municipioListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Municipio>> municipioListFuture =
          dbProvider.getMunicipioList();
      municipioListFuture.then((municipioList) {
        setState(() {
          this.municipios = municipioList;
        });
      });
    });
  }

  void _onDropDownLugarSelected(String newValueSelected) {
    // fixCombo (16 feb 2019): new function
    setState(() {
      this._lugar = newValueSelected;
    });
  }

  void lugarListView() {
    // fixCombo (16 feb 2019): new function
    final Future<Database> db = dbProvider.initDB();
    db.then((database) {
      Future<List<Lugar>> lugarListFuture = dbProvider.getLugarList();
      lugarListFuture.then((lugarList) {
        setState(() {
          this.lugares = lugarList;
        });
      });
    });
  }

  void handelSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      debugPrint("Form validated");
      setState(() {
        form.save();
        form.reset();
        gAuxRef
            .child(tercero.documento)
            .child(tercero.identificacion.toString())
            .set(jsonDecode(auxiliarToJson(tercero)));
      });
    }
  }
}
