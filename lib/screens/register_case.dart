import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/widgets.dart';
import '../widgets/app_drawer.dart';
import './home_page.dart';

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
  String _childAge;
  File _childImage;
  var _authInstance = FirebaseAuth.instance;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _childImage = File(pickedImageFile.path);
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_childImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // upload image to firebase storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('case_images')
            .child(Timestamp.now().seconds.toString() + '.jpg');

        await ref.putFile(_childImage);

        final url = await ref.getDownloadURL();

        // use those values to send our auth request...
        await FirebaseFirestore.instance.collection('cases').add({
          'policeUserId': _auth.currentUser.uid,
          'isClosed': false,
          'isFound': false,
          'childName': _childName,
          'childParentName': _childParentName,
          'childParentContact': _childParentContact,
          'childAddress': _childAddress,
          'childAge': _childAge,
          'createdAt': Timestamp.now(),
          'childImageUrl': url,
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Case registered successfully!'),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
      } on FirebaseAuthException catch (error) {
        var message = 'An error occurred, please check your credentials!';

        if (error.message != null) {
          message = error.message;
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
      } catch (error) {
        print(error);
        setState(() {
          _isLoading = false;
        });
      }
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
                      if (value.isEmpty || value.length > 2) {
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
                      _childAge = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('childParentContact'),
                    validator: (value) {
                      if (value.isEmpty || value.length != 10) {
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
                        icon: const Icon(
                          CupertinoIcons.add,
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        label: const Text('Upload child image',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _submitForm,
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
