import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orphaned/screens/home_page.dart';

import '../utils/widgets.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  String _userConfirmPassword = '';

  void _submitAuthForm(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    UserCredential userCredential;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials!';

      if (e.message != null) {
        message = e.message;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      _submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userConfirmPassword.trim(),
        context,
      );
    }
  }

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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // email field
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
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
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.lock_fill),
                      'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 40),

                  // confirm password field
                  TextFormField(
                    key: const ValueKey('confirmPassword'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.lock_fill),
                      'Confirm Password',
                    ),
                    onSaved: (value) {
                      _userConfirmPassword = value;
                    },
                  ),
                  SizedBox(height: 40),
                  buildRowForgotPassword(context, false),
                  SizedBox(height: 40),

                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
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
          ],
        ),
      ),
    );
  }
}
