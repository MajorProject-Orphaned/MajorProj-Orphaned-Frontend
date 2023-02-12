import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../utils/widgets.dart';


class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
            buildHeroThumbnail(false),
            SizedBox(height: 20),
            buildTextLoginNow(false),
            SizedBox(height: 20),
            buildRowCreateNew(false),
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

            // confirm password field
            TextField(
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Theme.of(context).primaryColor,),
              autofocus: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Theme.of(context).primaryColor,
              decoration: fieldDecoration(
                Icon(CupertinoIcons.lock_fill),
                'Confirm Password',
              ),
            ),
            SizedBox(height: 40),
            buildRowForgotPassword(context, false),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print('Signup button pressed');
              },
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                backgroundColor: Theme.of(context).accentColor,
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Signup",
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
