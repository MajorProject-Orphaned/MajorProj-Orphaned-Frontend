import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';

class DatabaseManager extends StatefulWidget {
  const DatabaseManager({Key key}) : super(key: key);

  @override
  State<DatabaseManager> createState() => _DatabaseManagerState();
}

class _DatabaseManagerState extends State<DatabaseManager> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('cases').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: data["childName"],
            );
          }).toList(),
        );
      },
    );
  }
}
