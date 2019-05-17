import 'package:emision/polizaModelo/PolizaModel.dart';
import 'package:emision/utils/ui_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

//import '../../gallery/demo.dart';
//TODO el modelo de los datos no debería ir en una ventana aparte??
class Afianzado {
  const Afianzado(this.registro, this.descripcion);

  final int registro;
  final String descripcion;
}

class TipoPoliza {
  const TipoPoliza(this.registro, this.descripcion);

  final int registro;
  final String descripcion;
}

Afianzado afianzado;
List<Afianzado> afianzados = <Afianzado>[
  const Afianzado(1, ''),
  const Afianzado(2, 'Luis enrrique'),
  const Afianzado(3, 'Juan Carlos')
];

TipoPoliza tipoPoliza;
List<TipoPoliza> tipoPolizas = <TipoPoliza>[
  const TipoPoliza(16, 'Particular'),
  const TipoPoliza(19, 'Estatal')
];

class _PageSelector extends StatefulWidget {
  final List<Icon> icons;

  const _PageSelector({Key key, this.icons}) : super(key: key);

  @override
  __PageSelectorState createState() => __PageSelectorState();
}

class __PageSelectorState extends State<_PageSelector> {
  final GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompKey = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  //Crea una instancia de la base de datos de Firebase
  final FirebaseDatabase database = FirebaseDatabase.instance;

  //Se definen las referencias a la base de datos Firebase
  DatabaseReference rootRef;
  DatabaseReference gAuxRef;
  DatabaseReference afianzRef;

  //TODO inicializar la poliza con los campos fijos por el momento

  //Cuando debe usarse final en una variable
  Poliza poliza;

  var afianzadoList = <String>[];
  String _selectedAfianzado = '';


  @override
  void initState() {
    poliza = Poliza();

    //Root reference Firebase
    rootRef = database.reference();
    //Referencia a g_auxiliar
    gAuxRef = database.reference().child("g_auxiliar");

    //Firebase reference for auxCont
    //TODO cambiar la referencia a la lista de afianzados
    afianzRef = gAuxRef.child("Intermediarios");

    //Mock de nits de intermediarios desde FireBase
    afianzRef.onChildAdded.listen(_onAdded);

    print(afianzadoList.toString());

    super.initState();
  }

  void _handleArrowButtonPress(BuildContext context, int delta) {
    final TabController controller = DefaultTabController.of(context);
    final int controllerLength = 2;
    if (!controller.indexIsChanging)
      controller.animateTo((controller.index + delta).clamp(
          0, controllerLength - 1)); //2 se cambia por widget.icons.length
  }

  //TODO Crear un Widget para cada pagina a mostrar
  //TODO Inicializar el objeto con los campos que se traen del sistema por ahora que son:
  //poliza,sede,fechaEmision = now, numero,temporario,periodo, estado, intermediario, comision, cupoOperativo.
  //cuando se incluya inicializar tambien la variable cumulo.

  Widget datosClasificacion() {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            "Datos del afianzado",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: azulSolidaria1),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),

          AutoCompleteTextField<String>(
            //Suggested data in the item builder
            itemBuilder: (context, item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    item,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Text(item)
                ],
              );
            },
            itemFilter: (item, query) {
              return item.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            itemSubmitted: (item) {
              setState(() {
                controller.text = item;
              });
            },
            clearOnSubmit: false,
            key: autoCompKey,
            suggestions: afianzadoList,
            style: new TextStyle(color: azulSolidaria1, fontSize: 16.0),
            decoration: new InputDecoration(
                icon: Icon(Icons.person),
                suffixIcon: Container(
                  width: 85.0,
                  height: 60.0,
                ),
                contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                filled: false,
                hintText: 'Buscar afianzado',
                hintStyle: TextStyle(color: Colors.black)),
          ),

          DropdownButtonFormField<Afianzado>(
              hint: Text("Seleccione un afianzado"),
              value: afianzado,
              onChanged: (Afianzado newValue) {
                setState(() {
                  afianzado = newValue;
                });
              },
              onSaved: (val) => poliza.afianzado = val.registro,
              validator: (val) =>
              val.descripcion == "" ? val.descripcion : null,
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
              ),
              items: afianzados.map((Afianzado user) {
                return DropdownMenuItem<Afianzado>(
                  value: user,
                  child: Text(
                    user.descripcion,
                  ),
                );
              }).toList()), // afianzado

          DropdownButtonFormField<TipoPoliza>(
              hint: Text("Seleccione tipo de póliza"),
              value: tipoPoliza,
              onChanged: (TipoPoliza newValue) {
                setState(() {
                  tipoPoliza = newValue;
                  poliza.tipoPoliza = newValue.registro;
                });
              },
              onSaved: (val) => poliza.tipoPoliza = val.registro,
              validator: (val) =>
              val.descripcion == "" ? val.descripcion : null,
              decoration: InputDecoration(
                icon: const Icon(Icons.description),
              ),
              items: tipoPolizas.map((TipoPoliza user) {
                return DropdownMenuItem<TipoPoliza>(
                  value: user,
                  child: Text(
                    user.descripcion,
                  ),
                );
              }).toList()),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  color: amarilloSolidaria2,
                  onPressed: () {
                    print("Do nothing button...");
                  },
                  child: Text(
                    "Validar",
                    style: TextStyle(
                        color: azulSolidaria1, fontWeight: FontWeight.bold),
                  )),
              FlatButton(
                  color: azulSolidaria1,
                  onPressed: () {
                    setState(() {
                      handelSubmit();
                    });
                  },
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          Center(child: Text("Afianzado: ${poliza.afianzado}")),
          Center(child: Text("TipoPoliza: ${poliza.tipoPoliza}")),
//RaisedButton(onPressed:   )

/*
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
                      //TODO cambiar a onSaved
                      tipoPoliza = newValue;
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
          ), // tipoPóliza

          TextFormField(
            //TODO cambiar controladores por opción onSaved y guardar directamente al objeto
            //controller: _clausulado,
            decoration: const InputDecoration(
              icon: const Icon(Icons.format_list_bulleted),
              hintText: 'Modifique el clausulado',
              labelText: 'Detalle clausulado',
            ),

            //focusNode: _clausuladoFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              //TODO Definir los metodos focus
              //_retroactividadFocus.unfocus();
              //FocusScope.of(context).requestFocus(_periodoEmisionFocus);
            },
            keyboardType: TextInputType.text,
          ), // clausulado

*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    final Color color = Theme.of(context).accentColor;
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, -1);
                  },
                  tooltip: 'Atras',
                ),
                TabPageSelector(controller: controller),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: color,
                  onPressed: () {
                    _handleArrowButtonPress(context, 1);
                  },
                  tooltip: 'Adelante',
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: 128.0,
                color: color,
              ),
              //TODO puse TabBarView dentro de form vamos a ver si funciona!!!
              child: Form(
                key: formKey,
                child: TabBarView(
                  //Aca se definen las ventanas _____________________________________
                    children: <Widget>[
                      datosClasificacion(),
                      Card(
                          margin: EdgeInsets.all(10.0),
                          child: Center(child: Text("Pagina 2")))
                    ]

                  /*
                  widget.icons.map<Widget>((Icon icon) {
                    //TODO lista de Widgets para las paginas
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: Center(
                          child: icon,
                        ),
                      ),
                    );
                  }).toList(),
                  */
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handelSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      debugPrint("Form validated");
      setState(() {
        form.save();
        form.reset();
      });
      //Genera un nuevo registro y trae la clave con la que se guarda
      /*
        String newKey = journalRef.push().key;
        journalRef.child(newKey).set(journal.toJson());
        debugPrint("last key es: $newKey");
        */

    }
  }

  void _onAdded(Event event) {
    setState(() {
      afianzadoList.add(event.snapshot.key);
      print("Add ${event.snapshot.key}");
    });
  }
}

class PageSelectorDemo extends StatelessWidget {
  static const String routeName = '/material/page-selector';
  static final List<Icon> icons = <Icon>[
    const Icon(Icons.event, semanticLabel: 'Event'),
    const Icon(Icons.home, semanticLabel: 'Home'),
    const Icon(Icons.android, semanticLabel: 'Android'),
    const Icon(Icons.alarm, semanticLabel: 'Alarm'),
    const Icon(Icons.face, semanticLabel: 'Face'),
    const Icon(Icons.language, semanticLabel: 'Language'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Póliza'),
        actions: <Widget>[],
      ),
      body: DefaultTabController(
        length: 2,
        child: _PageSelector(icons: icons),
      ),
    );
  }
}
