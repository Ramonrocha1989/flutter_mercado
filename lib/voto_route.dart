import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VotoRoute extends StatefulWidget {
  final String produtoId;

  VotoRoute(this.produtoId);

  @override
  State<VotoRoute> createState() => _VotoRouteState();
}

class _VotoRouteState extends State<VotoRoute> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('mercado')
        .doc(widget.produtoId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    return MaterialApp(
      title: 'Avalie o Produto',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Avalie o Produto'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World: ${widget.produtoId}'),
          ),
        ),
      ),
    );
  }
}
