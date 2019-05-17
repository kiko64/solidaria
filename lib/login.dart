import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emision/auxiliarModelo/Database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:emision/auxiliarModelo/user.dart';
import 'package:emision/utils/ui_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }

//Variables de la funcion autenticar
User _authenticatedUser;
Timer _authTimer;
PublishSubject<bool> _userSubject = PublishSubject();
String _selProductId;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final _username = TextEditingController();
  final _password = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>(); //Para que se utiliza?

  //Por defecto authMode es Login
  AuthMode _authMode = AuthMode.Login;

  Widget loginBtn() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4.0,
          color: amarilloSolidaria1,
          child: Text(
            _authMode == AuthMode.Login ? "INGRESAR" : "REGISTRO",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
//                    Retorna un Future que debo hacer para seleccionar un int
//                    int resultado=bloc.getPassword("correo='"+_username.text.trim()+"' and password='"+_password.text.trim()+"' ");

            _submitForm(authenticate);
/*
            int resultado = 1;

            if (resultado == 0) {
              Fluttertoast.showToast(
                  msg: "Error, reintente nuevamente " + resultado.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 2,
//                          backgroundColor: Colors.red,
//                          textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              CircularProgressIndicator();
             }
           Navigator.pop(context);
*/



          },
        ),
      ),
    ]);
  }

  Widget ResetBtn() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4.0,
          color: azulSolidaria2,
          child: Text(
            "REESTABLECER CONTRASEÑA",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            CircularProgressIndicator();
          },
        ),
      ),
    ]);
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Acepto Términos'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      if(!_formData['acceptTerms']){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ha ocurrido un error!'),
              content: Text("Por favor aceptar términos"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        return;
      }else return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      //TODO forma insegura para ingreso, cambiar por dirección de la ventana
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "Bienvenido...", //+ resultado.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          fontSize: 16.0);

      // Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ha ocurrido un error!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Widget loginForm() {
    return Column(
      children: <Widget>[
        SizedBox(height: 1.0),
        Text(
          _authMode == AuthMode.Signup ? "Ventana de Registro" : "Ingreso",
          textScaleFactor: 2.0,
          style: TextStyle(color: azulSolidaria1),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _username,
                validator: (String value) {
                  if (value.isEmpty ||
                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                    return 'Por favor ingresar un correo valido';
                  }
                },
                onSaved: (String value) {
                  _formData['email'] = value;
                },
                decoration: InputDecoration(
                  labelText: 'Correo',
                  labelStyle: TextStyle(color: azulSolidaria1),
                ),
                focusNode: _usernameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _usernameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _password,
                validator: (String value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Contraseña muy corta';
                  }
                },
                onSaved: (String value) {
                  _formData['password'] = value;
                },
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: azulSolidaria1),
                ),
                focusNode:_passwordFocus,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                obscureText: true,
              ),
              _authMode == AuthMode.Signup ? TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  labelStyle: TextStyle(color: azulSolidaria1),
                ),
                obscureText: true,
                validator: (String value) {
                  if (_password.text != value &&
                      _authMode == AuthMode.Signup) {
                    return 'Contraseña no concuerda.';
                  }
                },
              ) : Container()
            ],
          ),
        ),
        SizedBox(height: 12.0),
        loginBtn(),
        ResetBtn(),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }


  @override
  Widget build(BuildContext context) {
    //final bloc = AuxiliarBloc(); // separate
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            child: Image.asset(
              "assets/logo.png",
              scale: 0.9,
              height: 180,
              width: 500,
            ),
          ),
          Container(
            child: Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        loginForm(),
                        SizedBox(height: 12.0),
                        _buildAcceptSwitch(),
                        FlatButton(
                          child: Text(
                              '${_authMode == AuthMode.Login ? 'Deseo registrarme' : 'Ya tengo contraseña'}'),
                          onPressed: () {
                            if (_authMode == AuthMode.Login) {
                              setState(() {
                                _authMode = AuthMode.Signup;
                              });
                            } else {
                              setState(() {
                                _authMode = AuthMode.Login;
                              });
                            }
                          },
                        )
                      ],
                    ),
                    height: 500.0,
                    width: 320.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.grey.shade200.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//----------------Debería ir en el bloc -------------------------
//TODO implementar el bloc e incluir estos metodos ahí
Future<Map<String, dynamic>> authenticate(String email, String password,
    [AuthMode mode = AuthMode.Login]) async {
  //_isLoading = true;
  //notifyListeners();

  final Map<String, dynamic> authData = {
    'email': email,
    'password': password,
    'returnSecureToken': true
  };
  http.Response response;
  if (mode == AuthMode.Login) {
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyA3a4hkdzz_D6k-BQJv7qBdkfKI9N5Uhng',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA3a4hkdzz_D6k-BQJv7qBdkfKI9N5Uhng',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
  }

  final Map<String, dynamic> responseData = json.decode(response.body);
  bool hasError = true;
  String message = 'Algo salió mal.';
  print(responseData);
  if (responseData.containsKey('idToken')) {
    hasError = false;
    message = 'Autenticación satisfactoria!';
    _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken']);
    setAuthTimeout(int.parse(responseData['expiresIn']));
    _userSubject.add(true);
    final DateTime now = DateTime.now();
    final DateTime expiryTime =
    now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', responseData['idToken']);
    prefs.setString('userEmail', email);
    prefs.setString('userId', responseData['localId']);
    prefs.setString('expiryTime', expiryTime.toIso8601String());
  } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
    message = 'El e-mail ya existe.';
  } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
    message = 'E-mail no encontrado.';
  } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
    message = 'La contraseña es invalida.';
  }
  //_isLoading = false;
  //notifyListeners();
  return {'success': !hasError, 'message': message};
}

void logout() async {
  _authenticatedUser = null;
  _authTimer.cancel();
  _userSubject.add(false);
  _selProductId = null;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove('userEmail');
  prefs.remove('userId');
}

void setAuthTimeout(int time) {
  _authTimer = Timer(Duration(seconds: time), logout);
}
