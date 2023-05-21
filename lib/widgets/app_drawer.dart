import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orphaned/screens/Cases_screen.dart';
import 'package:orphaned/screens/home_page.dart';
import 'package:orphaned/screens/register_case.dart';
import '../utils/data_processor.dart';
import '../screens/case_detail_screen.dart';
import '../screens/admin_screen.dart';
import '../screens/profile_page.dart';
import '../screens/add_suspected_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // fetch user details from firebase
  Future<Object> _userData() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final data = await users.doc(userId).get().then((value) => value.data());
    return data;
  }

  Map<String, dynamic> _data = null;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _userData().then((value) => setState(() {
            _data = value as Map<String, dynamic>;
          }));
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return startDrawer();
  }

  Widget startDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.orangeAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ProfilePage.routeName),
                  child: CircleAvatar(
                    radius: 48.0,
                    backgroundImage: NetworkImage(
                      _data != null
                          ? _data['userImageUrl']
                          : "https://www.w3schools.com/howto/img_avatar.png",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _data != null ? _data['userName'] : "User Name",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          createDrawerListTiles(Icons.home, "Dashboard"),
          if(_data != null && _data['isPolice'] == true)
            createDrawerListTiles(Icons.app_registration, "Register FIR"),
          if(_data != null && _data['isPolice'] == true)
            createDrawerListTiles(Icons.file_open, "Opened Cases"),
          if(_data != null && _data['isPolice'] == true)
            createDrawerListTiles(Icons.close, "Closed Cases"),
          if(FirebaseAuth.instance.currentUser.uid == '88O2i0s9h5RQU6ESBmDfN7uclrD3')
            createDrawerListTiles(Icons.cases_rounded, "Admin Page"),
          createDrawerListTiles(Icons.cases_rounded, "Add Suspected Child"),
          const Divider(),
          createDrawerListTiles(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  ///
  /// Account list tile
  ///
  Widget createDrawerAccountListTiles() {
    return const ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orangeAccent,
        child: FlutterLogo(),
      ),
      title: Text(
        "flutterexample@gmail.com",
        style: TextStyle(
          // fontFamily: Strings.fontRobotoBold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  ///
  /// Drawer container list tiles
  /// [IconData]
  ///
  Widget createDrawerListTiles(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onTap: () {
        if (title == "Logout") {
          _signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged out!'),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        }
        if (title == "Dashboard") {
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        }
        if (title == "Admin Page") {
          Navigator.of(context).pushReplacementNamed(AdminScreen.routeName);
        }
        if (title == "Register FIR") {
          Navigator.of(context)
              .pushReplacementNamed(RegisterCaseScreen.routeName);
        }
        if (title == "Opened Cases") {
          Navigator.of(context)
              .pushNamed(Cases.routeName, arguments: {'is_open': true});
        }
        if (title == "Closed Cases") {
          Navigator.of(context)
              .pushNamed(Cases.routeName, arguments: {'is_open': false});
        }
        if (title == "Add Suspected Child") {
          Navigator.of(context).pushNamed(AddSuspectedChild.routeName);
        }
      },
    );
  }
}
