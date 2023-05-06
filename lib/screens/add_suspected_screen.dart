import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orphaned/widgets/app_drawer.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/data_processor.dart';
import 'home_page.dart';

class AddSuspectedChild extends StatefulWidget {
  static const routeName = '/add-suspected-child';

  @override
  State<AddSuspectedChild> createState() => _AddSuspectedChildState();
}

class _AddSuspectedChildState extends State<AddSuspectedChild> {
  var _authInstance = FirebaseAuth.instance;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  File _suspectedChildImage;

  // To Avoid Any Memory Leaks (dispose method used to release the memory allocated to variables when state object is removed.)
  void dispose() {
    super.dispose();
    _numberController.dispose();
    _nameController.dispose();
  }

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _suspectedChildImage = File(pickedImageFile.path);
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_suspectedChildImage == null) {
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
            .child('suspected_child_images')
            .child(Timestamp.now().seconds.toString() + '.jpg');

        await ref.putFile(_suspectedChildImage);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('suspected_child').add({
          'name': _nameController.text,
          'number': _numberController.text,
          'image_url': url,
          'user_id': _authInstance.currentUser.uid,
          'created_at': Timestamp.now(),
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thanks For Helping!'),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );

        final MyDataProcessor dataProcessor = MyDataProcessor();
        await dataProcessor.processData(url);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      drawer: _authInstance.currentUser == null ? null : AppDrawer(),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(40.0),
        children: [
          SizedBox(
            width: 250.0,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Add Suspected Child",
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
                CustomTextField(
                  controller: _nameController,
                  hinttext: "Your Name",
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _numberController,
                  hinttext: "Your Number",
                ),
                SizedBox(height: 20),
                //Upload Suspected Child Image
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: _suspectedChildImage != null
                          ? FileImage(_suspectedChildImage)
                          : null,
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
                      label: const Text('Upload Suspected Child image',
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
    );
  }
}
