import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/widgets.dart';
import '../widgets/app_drawer.dart';

class RegisterCaseScreen extends StatefulWidget {
  static const routeName = '/register-case';

  @override
  _RegisterCaseScreenState createState() => _RegisterCaseScreenState();
}

class _RegisterCaseScreenState extends State<RegisterCaseScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _childName = '';
  String _childParentName = '';
  String _childParentContact = '';
  String _childAddress = '';
  int _childAge;
  File _childImage;
  var _authInstance = FirebaseAuth.instance;

    void _pickImage() async {
    final pickedImageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    
    setState(() {
      _childImage = File(pickedImageFile.path);
    });

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
        appBar: _authInstance.currentUser == null
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.green),
              ),
        drawer: _authInstance.currentUser == null ? null : AppDrawer(),
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(40.0),
          children: [
            SizedBox(
              width: 250.0,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Register New Case",
                    textStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey('childName'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid name.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.person_fill),
                      'Child Name',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _childName = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('childParentName'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid name.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.person_fill),
                      'Child\'s Parent Name',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _childParentName = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('childAddress'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid address.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.streetAddress,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.location_fill),
                      'Child Address',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _childAddress = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('childAge'),
                    validator: (value) {
                      if (value as int < 0 || value as int > 100) {
                        return 'Please enter a valid age.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.arrowtriangle_up_circle_fill),
                      'Child Age',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _childAge = value as int;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('childParentContact'),
                    validator: (value) {
                      if (value.length != 10) {
                        return 'Please enter a valid contact number.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.phone,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.phone_fill),
                      'Parent\'s Contact Number',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _childParentContact = value;
                    },
                  ),

                  SizedBox(height: 20),

                  // child image upload
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            _childImage != null ? FileImage(_childImage) : null,
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(CupertinoIcons.add,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        label: const Text('Upload child image', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: () {},
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
                            "Register",
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
