import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_drawer.dart';

class CaseDetailScreen extends StatelessWidget {
  static const routeName = '/case_detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    String caseId = args["case_id"];
    CollectionReference cases = FirebaseFirestore.instance.collection('cases');
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Details'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
          stream: cases.doc(caseId).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            bool isOpen = !data['isClosed'];
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
                              child: Image.network("${data['childImageUrl']}"),
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
                                  "Name : ${data['childName']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  "Age : ${data['childAge']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Father's Name : ${data['childFatherName']}",
                                ),
                                Text(
                                  "Mother's Name : ${data['childMotherName']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Address : ${data['childAddress']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child:
                              isOpen ? Text("Case Open") : Text("Case Closed")),
                      FilledButton(
                          onPressed: () {
                            cases.doc(caseId).update({'isClosed': isOpen}).then(
                                (value) => print("status updatated"));
                          },
                          child: const Text('Change status')),
                    ],
                  ),
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
          }),
    );
  }
}
