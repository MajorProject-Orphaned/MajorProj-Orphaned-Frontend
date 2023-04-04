import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orphaned/screens/home_page.dart';
import 'package:orphaned/screens/register_case.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return startDrawer();
  }

  ///
  /// left side drawer using [DrawerHeader]
  ///
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
                CircleAvatar(
                  radius: 48.0,
                  backgroundImage: NetworkImage(
                      "https://www.w3schools.com/howto/img_avatar.png"),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "My Profile",
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
          createDrawerListTiles(Icons.app_registration, "Register FIR"),
          createDrawerListTiles(Icons.file_open, "Opened Cases"),
          createDrawerListTiles(Icons.close, "Closed Cases"),
          createDrawerListTiles(Icons.info, "Report Missing Child"),
          const Divider(),
          createDrawerListTiles(Icons.assessment, "Statistical Report"),
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

        if (title == "Register FIR") {
          Navigator.of(context).pushReplacementNamed(RegisterCaseScreen.routeName);
        }
      },
    );
  }
}
