import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orphaned/screens/add_suspected_screen.dart';
import 'package:orphaned/screens/admin_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/register_case.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  static const adminUserId = '88O2i0s9h5RQU6ESBmDfN7uclrD3';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _authInstance = FirebaseAuth.instance;

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
    if (_authInstance.currentUser != null) {
      _userData().then((value) => setState(() {
            _data = value as Map<String, dynamic>;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _authInstance.currentUser != null &&
            _authInstance.currentUser.uid == HomePage.adminUserId
        ? AdminScreen()
        : Scaffold(
            appBar: _authInstance.currentUser == null
                ? null
                : AppBar(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    iconTheme: IconThemeData(color: Colors.green),
                  ),
            drawer: _authInstance.currentUser == null ? null : AppDrawer(),
            body: SafeArea(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to ORPHANED!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "An initiative to find missing children and reunite them with their families.",
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/intro-image.jpeg'),
                        ),
                      ),
                    ),
                    if (_authInstance.currentUser == null)
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    if (_authInstance.currentUser != null &&
                        _data != null &&
                        _data['isPolice'] == true)
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterCaseScreen.routeName);
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "Register Case",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _authInstance.currentUser != null
                            ? Navigator.of(context)
                                .pushNamed(AddSuspectedChild.routeName)
                            : Navigator.of(context)
                                .pushNamed(SignupScreen.routeName);
                      },
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _authInstance.currentUser != null
                            ? "Add Suspected Child"
                            : "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
