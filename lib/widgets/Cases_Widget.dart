import 'package:flutter/material.dart';

class CasesWidget extends StatelessWidget {
  List cases;

  CasesWidget(this.cases);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: ListView.builder(
          itemCount: cases.length,
          itemBuilder: (context, index) {
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
                ],
              ),
              child: ListTile(
                title: Text(
                  'Name: ${cases[index].childName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  'Parent\'s Contact: ${cases[index].childParentContact}',
                  style: TextStyle(fontSize: 14.0),
                ),
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1521747116042-5a810fda9664'),
                  backgroundColor: Colors.transparent,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Screen to be done by Akshit CASE DETAIL SCREEN!!
                },
              ),
            );
          },
        ));
  }
}
