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

class UpdateProfileScreen extends StatefulWidget {
  static const routeName = '/update-profile';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _contact = '';
  String _address = '';
  bool _isPolice = false;
  File _image;
  var _authInstance = FirebaseAuth.instance;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedImageFile.path);
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_image == null) {
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
            .child('user_images')
            .child(Timestamp.now().seconds.toString() + '.jpg');

        await ref.putFile(_image);

        final url = await ref.getDownloadURL();

        // use those values to send our auth request...
        final isUserExists = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: _auth.currentUser.uid)
            .get();
        
        if (isUserExists.docs.length > 0) {
          // update user profile
          await FirebaseFirestore.instance.collection('users').doc(isUserExists.docs[0].id).update({
            'childName': _name,
            'contact': _contact,
            'address': _address,
            'imageUrl': url,
          });
        } 
        else {
          await FirebaseFirestore.instance.collection('users').add({
            'userId': _auth.currentUser.uid,
            'isPolice': _isPolice,
            'childName': _name,
            'contact': _contact,
            'address': _address,
            'createdAt': Timestamp.now(),
            'imageUrl': url,
          });
        }

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
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
                    "Update Profile",
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
                    key: const ValueKey('FullName'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a full name.';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: fieldDecoration(
                      Icon(CupertinoIcons.person_fill),
                      'Full Name',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _name = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('Address'),
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
                      'Address',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _address = value;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    key: const ValueKey('contact'),
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
                      'Contact Number',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    onSaved: (value) {
                      _contact = value;
                    },
                  ),

                  SizedBox(height: 20),

                  // police or not
                  Row(
                    children: [
                      Checkbox(
                        value: _isPolice,
                        onChanged: (value) {
                          setState(() {
                            _isPolice = value;
                          });
                        },
                      ),
                      Text(
                        'Are you a police officer?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // image upload
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        backgroundImage: 
                            _image != null ? FileImage(_image) : null,
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
                        label: const Text('Upload image',
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
                            "Update",
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
