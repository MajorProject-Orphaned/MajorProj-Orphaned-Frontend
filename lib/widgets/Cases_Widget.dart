import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_drawer.dart';
import '../screens/case_detail_screen.dart';

class CasesWidget extends StatefulWidget {
  final bool isButtonPressed;

  CasesWidget({this.isButtonPressed});

  @override
  State<CasesWidget> createState() => _CasesWidgetState();
}

class _CasesWidgetState extends State<CasesWidget> {
  bool _isButtonPressed;

  @override
  void initState() {
    super.initState();
    _isButtonPressed = widget.isButtonPressed;
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('cases').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isButtonPressed
            ? Text(
                'Opened Cases',
                style: TextStyle(color: Colors.black87),
              )
            : Text(
                'Closed Cases',
                style: TextStyle(color: Colors.black87),
              ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
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
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              if ((_isButtonPressed && data['isClosed']) ||
                  (!_isButtonPressed && !data['isClosed'])) return Container();
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(data['childImageUrl']),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pushNamed(CaseDetailScreen.routeName, arguments: {'case_id': document.id});
                  },
                  title: Text(
                    'Name: ${data['childName']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Text(
                    'Parent\'s Contact: ${data['childParentContact']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
