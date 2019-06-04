// Copyright 2018-present the Flutter authors. All Rights Reserved.
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

import 'package:emision/amparos.dart';
import 'package:emision/inicio.dart';
import 'package:emision/polizaPagination.dart';
import 'package:emision/polizas.dart';
import 'package:emision/pruebaCrudFB.dart';
import 'package:emision/ventanaDatos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';                     //new
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'auxililares.dart';
import 'main.dart';
//import 'amparos.dart';                                     // (Verificar)
//import 'acciones.dart';                                    // (Verificar)
//import 'polizas.dart';                                     // (Verificar)

class SeguridadApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emisión poliza',

      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,

    home: PaginaInicio(),
      routes: <String, WidgetBuilder>{
        '/polizaPagination'    : (BuildContext context) => PageSelectorDemo(), //AmparoList()
        '/polizas': (BuildContext context) => PolizaList(),
        '/auxiliares'  : (BuildContext context) => AuxiliarList(),
        '/amparos'   : (BuildContext context) => AmparoList(0),
        '/gregistro' : (BuildContext context) => VentanaGRegistro(actual: null),
        '/crudFB' : (BuildContext context) => ventanaCrud(),
      },
//    home: PolizaList(),                                   // (Verificar)
//    home: AccionList(),                                   // (Verificar)
//    home: AmparoList(),                                   // (Verificar)

      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}
