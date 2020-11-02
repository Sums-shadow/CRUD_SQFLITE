import 'package:flutter/material.dart';
import 'package:roger/data/db.dart';
import 'package:roger/model/produitModel.dart';

class AccueilPrincipal extends StatefulWidget {
  @override
  _AccueilPrincipalState createState() => _AccueilPrincipalState();
}

class _AccueilPrincipalState extends State<AccueilPrincipal> {
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  DB db = new DB();
  var data;
  init() async {
    await db.fetchData().then((value) {
      data = value;
    });
    setState(() {
      data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        controller: c1,
                      ),
                      TextField(
                        controller: c2,
                      ),
                    ],
                  ),
                  actions: [
                    RaisedButton(
                        child: Text("annulé"),
                        onPressed: () => Navigator.pop(context)),
                    RaisedButton(
                      child: Text("Save"),
                      onPressed: () => SaveData(c1.text, c2.text),
                    ),
                  ],
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              db.deleteAll().then((value) {
                print("All delete");
                init();
              }).catchError((err) => print("error on delete all"));
            },
          )
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          :data.length==0?Center(child: Text("Vous n'avez Aucun Produit enregistré"),)
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (contex, i) {
                return ListTile(
                  title: Text(data[i]["nom"]),
                  leading: Text(data[i]['id'].toString()),
                  subtitle: Text(data[i]["prix"] + " FC"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      db.deleteData(data[i]['id']).then((value) {
                        print("Suppression reussie");
                        init();
                      }).catchError((err) =>
                          print("erreur survenue lors de la suppression"));
                    },
                  ),
                  onLongPress: () {
                    TextEditingController cnom =
                        TextEditingController(text: data[i]['nom']);
                    TextEditingController cprix =
                        TextEditingController(text: data[i]['prix']);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              children: [
                                TextField(
                                  controller: cnom,
                                ),
                                TextField(
                                  controller: cprix,
                                ),
                              ],
                            ),
                            actions: [
                              RaisedButton(
                                  child: Text("annulé"),
                                  onPressed: () => Navigator.pop(context)),
                              RaisedButton(
                                child: Text("Update"),
                                onPressed: () => UpdateData(
                                    data[i]['id'], cnom.text, cprix.text),
                              ),
                            ],
                          );
                        });
                  },
                );
              },
            ),
    );
  }

  SaveData(nom, prix) {
    Produit p = new Produit(id: null, nom: nom, prix: prix);
    return db.insertData(p).then((value) {
      print("insertion reusssi $value");
      Navigator.pop(context);
      init();
    }).catchError((err) => print("erreur survenu $err"));
  }

  UpdateData(id, nom, prix) {
    Produit p = new Produit.SansId(nom: nom, prix: prix);
    return db.updateData(id, p).then((value) {
      print("insertion reusssi $value");
      Navigator.pop(context);
      init();
    }).catchError((err) => print("erreur survenu $err"));
  }
}
