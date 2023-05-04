import 'package:flutter/material.dart';

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
            return Text("Document does not exist");
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
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Name : ${data['username']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  "Age : ${data['userAge']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Contact : ${data['userContact']}",
                                ),
                                Text(
                                  "Address : ${data['userAddress']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]),
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
                      'More Images',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Flexible(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/cs.png'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}