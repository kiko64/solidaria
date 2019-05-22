import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:emision/auxiliarModelo/AuxiliarModel.dart';
import 'package:emision/auxiliarModelo/Database.dart';
import 'auxiliar.dart';
import 'polizas.dart';                                      // (Verificar)
import 'amparos.dart';                                      // (Verificar)
import 'acciones.dart';                                     // (Verificar)
import 'anexos.dart';                                       // (Verificar)

class AuxiliarList extends StatefulWidget {

  @override
  _AuxiliarListState createState() => _AuxiliarListState();
}

class _AuxiliarListState extends State<AuxiliarList> {

  void _actualizar(Auxiliar item) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      DBProvider.db.blockOrUnblock(item);         // Manejo DB Caballo Original (Verificar)
//      DBProvider.db.oldblockOrUnblock(item);    // Manejo DB Caballo Ejemplo  (Verificar)

    });
  }

  @override
  Widget build(BuildContext context) {

    final bloc = AuxiliarBloc();  //new separate
    int ok=0;  //new separate
    TextEditingController editingController = TextEditingController();

    @override
    void initState() {
    }


    @override//new separate
    void dispose() {
      bloc.dispose();
      super.dispose();
    }


    return new Scaffold(
      appBar: AppBar(
        title: new Text("Lista de Terceros"),
      ),

        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
/*
              Container(
                margin: EdgeInsets.fromLTRB(8, 32, 8, 9),
                height: 40,
                alignment: Alignment.topCenter,

                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: new Border.all(color: Colors.grey[400],),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                ),
                child: TextField (
                  onChanged: (value) {
                    //filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Buscar",
                  ),
                ),
              ),
              */

              Expanded(
                child: StreamBuilder<List<Auxiliar>>(  //new separate
                  stream: bloc.auxiliares, //new separate

                  //body: FutureBuilder<List<Auxiliar>>(  //new separate
                  //future: DBProvider.db.getAllAuxiliar(), //new separate

                  builder: (BuildContext context, AsyncSnapshot<List<Auxiliar>> snapshot) {

                    if (snapshot.hasData) {
                      //          return ListView.builder(
                      return ListView.separated(

                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),

                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {

                          Auxiliar item = snapshot.data[index];
                          //                ok = snapshot.data[index].auxiliar;
                          return Dismissible (

                            key: UniqueKey(),

                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Theme.of(context).accentColor,

                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child:
                                Icon(Icons.delete, color: Colors.white,
                                ),
                              ),
                            ),

                            onDismissed: (direction) {
                              bloc.delete(item.auxiliar);   // Manejo DB Borrar
                            },

                            child: ListTile(
                              onTap: () {
                                Navigator.push(             // Manejo DB Actualizar
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuxiliarPage(actual: item)
                                    )
                                );
                              },
/*
                              leading: CircleAvatar(
                                  radius: 28.0,
                                  backgroundColor: Colors.transparent,
                                  //backgroundImage: AssetImage('assets/imagen.jpg')
                                  backgroundImage: AssetImage( item.foto.toString() )
                              ),
*/
                              title: Text("${item.primerNombre} ${item.segundoNombre} ${item.auxiliar.toString()}",//+item.nacimiento.substring(0,10)+item.nacimiento.substring(11,13)+item.nacimiento.substring(14,16)+item.nacimiento.substring(17,19),
                                style: TextStyle(fontWeight: FontWeight.bold),   // fontSize: 18,
                              ),

                              //child: row(
                              //children[
                              subtitle: Text("${item.primerApellido}  ${item.segundoApellido}"),

                              trailing: Checkbox(
                                onChanged: (bool value) {
                                  _actualizar(item);
                                },
//                              value: item.indicador,          // Original (Verificar)
                                value: item.sincronizar,          // Ejemplo

                              ),

                            ), // ListTile
                          );  // Dismissible
                        }, //itemBuilder
                      );
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              SizedBox(height: 54.0),

            ],
          ),
        ),


        floatingActionButton:Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add,color: Colors.white,),
                backgroundColor: Colors.black38,

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(
                          builder: (context) => new AuxiliarPage()    // Manejo DB Adicionar Actividad
                      )
                  );
                },
              ),

              FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.format_list_bulleted,color: Colors.white,),

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(                          // (Verificar)
                          builder: (context) => new PolizaList()   // Manejo DB Adicionar Auxiliar
                      )
                  );
                },
              ),

/*
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.details,color: Colors.white,),
            backgroundColor: Colors.black38,

            onPressed: () async {
              Navigator.push( context,
                  new MaterialPageRoute(                        // (Verificar)
                      builder: (context) => new AmparoList( 0 ) // Manejo DB Adicionar Auxiliar
                  )
              );
            },
          ),
*/

              FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.work,color: Colors.white,),

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(                          // (Verificar)
//                          builder: (context) => new AccionList()    // Manejo DB Adicionar Auxiliar
                          builder: (context) => new AnexoList( 0)     // Manejo DB Adicionar Auxiliar
                      )
                  );
                },
              )

            ]
        )


/*
      floatingActionButton: FloatingActionButton (
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push( context, new MaterialPageRoute( builder: (context) => new AuxiliarPage())); // Manejo DB Adicionar
          //Auxiliar rnd = testAuxiliar[math.Random().nextInt(testAuxiliar.length)];
          //await DBProvider.db.newAuxiliar(rnd);
          //setState(() {});
        },
      ),
*/
    );
  } // Widget build

}

