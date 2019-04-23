import 'package:flutter/material.dart';
import 'package:emision/anexoModelo/AnexoModel.dart';
import 'package:emision/anexoModelo/AnexoControler.dart';
import 'anexo.dart';                    // (Verificar)

class AnexoList extends StatefulWidget {

  int actualPoliza;
  AnexoList( @required this.actualPoliza ); // Manejo DB - Recibe en actualPoliza=datos(update) o actualPoliza=null(insert)

  @override
  _AnexoListState createState() => _AnexoListState();
}

class _AnexoListState extends State<AnexoList> {

  @override
  Widget build(BuildContext context) {

    final bloc = AnexoBloc( '' );  //new separate
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
              ),// buscar

              Expanded(
                child: StreamBuilder<List<Anexo>>(  //new separate
                  stream: bloc.anexos, //new separate

                  builder: (BuildContext context, AsyncSnapshot<List<Anexo>> snapshot) {
                    if (snapshot.hasData) {
                      //          return ListView.builder(
                      return ListView.separated(

                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Anexo item = snapshot.data[index];
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
                            ),// delete

                            onDismissed: (direction) {
                              bloc.delete( item.anexo );  // Manejo DB Borrar
                            },

                            child: ListTile(
                              title: Card(
                                elevation: 8.0,
                                child: new Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
//                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        child: Image.asset( item.documento ),
                                        padding: EdgeInsets.only(bottom: 10.0),
                                      ),

                                      Row(children: <Widget>[
                                        Padding(
                                            child: Text(
                                              '( '+item.interno.toString()+' )',
                                              style: new TextStyle(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                            padding: EdgeInsets.all(1.0)),
                                        Text("  "),
                                        Padding(
                                            child: Text(
                                              item.descripcion,
                                              style: new TextStyle(fontStyle: FontStyle.italic),
                                              textAlign: TextAlign.right,
                                            ),
                                            padding: EdgeInsets.all(1.0)),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () {
                                Navigator.push(                           // Manejo DB Actualizar
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnexoPage(actual: item)
                                    )
                                );
                              }, // update

                            ),
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

              SizedBox(height: 6.0),

            ],
          ),
        ),


        floatingActionButton: Row (
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add,color: Colors.white,),

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(
                          builder: (context) => new AnexoPage()    // Manejo DB Adicionar Actividad (Verificar)
                      )
                  );
                },
              ),

            ]
        )

    );
  } // Widget build

}
