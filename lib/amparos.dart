import 'package:flutter/material.dart';
import 'package:emision/amparoModelo/AmparoModel.dart';
import 'package:emision/amparoModelo/AmparoControler.dart';
import 'amparo.dart';                    // (Verificar)

class AmparoList extends StatefulWidget {

  int actualPoliza;
  AmparoList( @required this.actualPoliza ); // Manejo DB - Recibe en actualPoliza=datos(update) o actualPoliza=null(insert)

  @override
  _AmparoListState createState() => _AmparoListState();
}

class _AmparoListState extends State<AmparoList> {

  @override
  Widget build(BuildContext context) {

    final bloc = AmparoBloc( this.widget.actualPoliza );  //new separate
    TextEditingController busqueda = TextEditingController();

    @override
    void initState() {
    }

    @override//new separate
    void dispose() {
      bloc.dispose();
      super.dispose();
    }

    return new Scaffold(
      //appBar: AppBar(
      //  title: new Text("Lista", style: new TextStyle(color: Colors.white),),
      //),
        body: Container(
          child: Column(
            children: <Widget>[
              Container (
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
                    print('A buscar:'+busqueda.toString());
                  },
                  controller: busqueda,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Buscar",
                  ),
                ),
              ),

              Expanded(
                child: StreamBuilder<List<Amparo>>(  //new separate
                  stream: bloc.amparos, //new separate

                  //body: FutureBuilder<List<Amparo>>(  //new separate
                  //future: DBProvider.db.getAllAmparo(), //new separate

                  builder: (BuildContext context, AsyncSnapshot<List<Amparo>> snapshot) {
                    if (snapshot.hasData) {
                      //          return ListView.builder(
                      return ListView.separated(

                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),

                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Amparo item = snapshot.data[index];
                          //                ok = snapshot.data[index].amparo;
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
                              bloc.delete( item.amparo, item.poliza );     // Manejo DB Borrar
                            },

                            child: ListTile(
                              onTap: () {
                                Navigator.push(                           // Manejo DB Actualizar
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AmparoPage(actual: item)
                                    )
                                );
                              },

                              leading: CircleAvatar(
                                  child: Text( item.orden.toString() )
                              ),

                              title: Text( '( '+item.poliza.toString()+' ) '+item.descripcion+
                                  ' ( '+item.fechaInicial.toString().substring(0,10)+'-'+item.fechaFinal.toString().substring(0,10)+' )',
                                style: TextStyle(fontWeight: FontWeight.bold),   // fontSize: 18,
                              ),

                              //child: row(
                              //children[
                              subtitle: Text('('+item.porcentaje.toString()+'% )'+ item.prima.toString()),
                              //],
                              //),

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

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(
                          builder: (context) => new AmparoPage()    // Manejo DB Adicionar Actividad (Verificar)
                      )
                  );
                },
              ),

            ]
        )

    );
  } // Widget build

}
