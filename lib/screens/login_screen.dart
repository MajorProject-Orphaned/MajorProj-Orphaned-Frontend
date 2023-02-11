import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../utils/widgets.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).isFirstFocus) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildLoginAppBar(context),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(40.0),
          children: [
            buildHeroThumbnail(),
            SizedBox(height: 20),
            buildTextLoginNow(),
            SizedBox(height: 20),
            buildRowCreateNew(),
            SizedBox(height: 20),

            // email field
            TextField(
              textCapitalization: TextCapitalization.words,
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: TextInputType.emailAddress,
              decoration: fieldDecoration(
                Icon(CupertinoIcons.mail_solid),
                'Email',
              ),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),

            // password field
            TextField(
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Theme.of(context).primaryColor,),
              autofocus: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Theme.of(context).primaryColor,
              decoration: fieldDecoration(
                Icon(CupertinoIcons.lock_fill),
                'Password',
              ),
            ),
            SizedBox(height: 40),
            buildRowForgotPassword(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print('Login button pressed');
              },
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
