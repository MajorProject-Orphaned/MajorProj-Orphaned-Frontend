import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin_screen';
  const AdminScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Page'),
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Column(children: [
                Container(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset('assets/images/po.jpg'),
                      ),
                    ),
                    title: const Text(
                      "Full Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("policeofficer@gmail.com"),
                    trailing: Icon(Icons.check),
                  ),
                ),
                Divider(color: Colors.grey[800], thickness: 0.4,),
              ]);
            },
          ),
        ));
  }
}
