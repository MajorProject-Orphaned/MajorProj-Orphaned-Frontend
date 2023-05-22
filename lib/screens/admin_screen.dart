import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_drawer.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin_screen';
  const AdminScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Container(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  if (!data['isPolice'] || data['isVerified'])
                    return Container();

                  return Column(children: [
                    Container(
                      child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(data['userImageUrl']),
                            ),
                          ),
                          title: Text(
                            "${data['userName']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${data['userContact']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    users.doc(data['userId']).update({
                                      'isVerified': true
                                    }).then((value) => print(
                                        "${data['userName']} Verified as Police Officer"));
                                  },
                                  icon: const Icon(Icons.check)),
                              IconButton(
                                  onPressed: () {
                                    users.doc(data['userId']).update({
                                      'isPolice': false
                                    }).then((value) => print(
                                        "${data['userName']} Unverified as Police Officer"));
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          )),
                    ),
                    Divider(
                      color: Colors.grey[800],
                      thickness: 0.4,
                    ),
                  ]);
                }).toList(),
              ));
        },
      ),
    );
  }
}
