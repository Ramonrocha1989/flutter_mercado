import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sucos/voto_route.dart';

import 'inclusao_route.dart';
import 'inclusao_route.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? filtro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              __showFilter(context);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                filtro = null;
              });
            },
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
//          onPressed: adicionar,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InclusaoRoute()),
          );
        },
        tooltip: 'Adicionar Produto',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  CollectionReference cfproduto =
      FirebaseFirestore.instance.collection("mercado");

  Column _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: cfproduto.where("produto", isEqualTo: filtro).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              return data.size > 0
                  ? ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              data.docs[index].get("foto"),
                            ),
                          ),
                          title: Text(data.docs[index].get("produto")),
                          subtitle: Text(data.docs[index].get("marca") +
                              "\n" +
                              NumberFormat.simpleCurrency(locale: "pt_BR")
                                  .format(data.docs[index].get("preco"))),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VotoRoute(data.docs[index].id)),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Exclusão'),
                                  content: Text(
                                      'Confirma a exclusão do suco de ${data.docs[index].get("produto")}?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        cfproduto
                                            .doc(data.docs[index].id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sim'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Não'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text("Não ha Produto com a fruta informada"),
                    );
            },
          ),
        ),
      ],
    );
  }

  Future<void> __showFilter(BuildContext context) async {
    String? valueText;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Filtro de Produtos'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              decoration: InputDecoration(hintText: "Digite o Produto"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    filtro = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
