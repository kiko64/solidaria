import 'package:flutter/material.dart';
import 'package:emision/polizaModelo/PolizaModel.dart';
import 'package:emision/polizaModelo/PolizaControler.dart';
import 'poliza.dart';                    // (Verificar)
import 'amparos.dart';                    // (Verificar)


class PolizaList extends StatefulWidget {

  @override
  _PolizaListState createState() => _PolizaListState();
}

class _PolizaListState extends State<PolizaList> {

  @override
  Widget build(BuildContext context) {

    final bloc = PolizaBloc();  //new separate
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
      //appBar: AppBar(
      //  title: new Text("Lista", style: new TextStyle(color: Colors.white),),
      //),
        body: Container(
          child: Column(
            children: <Widget>[

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

              Expanded(
                child: StreamBuilder<List<Poliza>>(  //new separate
                  stream: bloc.polizas, //new separate

                  //body: FutureBuilder<List<Poliza>>(  //new separate
                  //future: DBProvider.db.getAllPoliza(), //new separate

                  builder: (BuildContext context, AsyncSnapshot<List<Poliza>> snapshot) {
                    if (snapshot.hasData) {
                      //          return ListView.builder(
                      return ListView.separated(

                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),

                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {

                          Poliza item = snapshot.data[index];
                          //                ok = snapshot.data[index].poliza;
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
                              bloc.delete(item.poliza);     // Manejo DB Borrar
                            },
                            child: ListTile(
                              onTap: () {
                                Navigator.push(             // Manejo DB Actualizar
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PolizaPage(actual: item)
                                    )
                                );
                              },
                              leading: CircleAvatar(
                                child: Text( item.poliza.toString() )
                              ),
                              title: Text(item.nombre+
                                  ' ( '+item.fechaEmision.toString().substring(0,10)+' )',
                                style: TextStyle(fontWeight: FontWeight.bold),   // fontSize: 18,
                              ),
                              //child: row(
                              //children[
                              subtitle: Text(item.descripcion.toString()),
                              //],
                              //),
                              trailing:
                              new IconButton(
                                icon: const Icon(Icons.keyboard_arrow_right, ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => new AmparoList( item.poliza )   // Relacionar amparos
                                  ),
                                ),
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

                onPressed: () async {
                  Navigator.push( context,
                      new MaterialPageRoute(
                          builder: (context) => new PolizaPage()    // Manejo DB Adicionar Actividad (Verificar)
                      )
                  );
                },
              ),

            ]
        )

    );
  } // Widget build

}
