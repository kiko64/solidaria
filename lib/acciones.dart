import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:emision/accionModelo/AccionModel.dart';
import 'package:emision/accionModelo/AccionControler.dart';
import 'acccion.dart';                    // (Verificar)


class AccionList extends StatefulWidget {

  @override
  _AccionListState createState() => _AccionListState();
}

class _AccionListState extends State<AccionList> {

  @override
  Widget build(BuildContext context) {

    final bloc = AccionBloc('');  //new separate
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
            ),// seek

            Expanded(
              child: StreamBuilder<List<Accion>>(  //new separate
                stream: bloc.acciones, //new separate

                //body: FutureBuilder<List<Accion>>(  //new separate
                //future: DBProvider.db.getAllAccion(), //new separate

                builder: (BuildContext context, AsyncSnapshot<List<Accion>> snapshot) {
                  if (snapshot.hasData) {
                      //          return ListView.builder(
                    return ListView.separated(

                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                      ),

                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {

                        Accion item = snapshot.data[index];
                            //                ok = snapshot.data[index].accion;
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
                            bloc.delete(item.accion);     // Manejo DB Borrar
                          },

                          child: ListTile(
                            onTap: () {
                              Navigator.push(             // Manejo DB Actualizar
                                context,
                                  MaterialPageRoute(
                                    builder: (context) => AccionPage(actual: item)
                                  )
                              );
                            },

                            leading: Image.asset('assets/'+item.categoria.toString()+'.png'),

                            title: Text(item.titulo+' ( '+item.fecha.toString()+' )',
                                   style: TextStyle(fontWeight: FontWeight.bold),   // fontSize: 18,
                            ),

                            //child: row(
                            //children[
                            subtitle: Text(item.subtitulo),
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
            ),// listView

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
                  builder: (context) => new AccionPage()    // Manejo DB Adicionar Actividad (Verificar)
                )
              );
            },
          ),

        ]
      )

    );
  } // Widget build

}

