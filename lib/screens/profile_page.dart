import 'package:flutter/material.dart';
import 'package:orphaned/screens/update_profile_screen.dart';

import '../widgets/app_drawer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  static const routeName = '/profile_page';

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(UpdateProfileScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Center(child: Text("Document does not exist"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network("${data['userImageUrl']}"),
                            ),
                          ),
                        ),
                      ]),
                  Divider(
                    height: 40,
                    thickness: 1.5,
                    color: Colors.blueGrey,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Name : ${data['userName']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            "Contact : ${data['userContact']}",
                          ),
                          Text(
                            "Address : ${data['userAddress']}",
                            style: TextStyle(fontSize: 15),
                          ),
                          if (data['isPolice']) ...[
                            if (data['isVerified']) ...[
                              const Text(
                                "Verified as a Police Officer",
                                style: TextStyle(fontSize: 15),
                              )
                            ] else ...[
                              const Text(
                                "Not yet verified as a Police Officer",
                                style: TextStyle(fontSize: 15),
                              )
                            ]
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text("loading"));
        },
      ),
    );
  }
}
