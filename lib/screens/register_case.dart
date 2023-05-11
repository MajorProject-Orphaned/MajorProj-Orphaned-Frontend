import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/widgets.dart';
import '../widgets/app_drawer.dart';
import './home_page.dart';
import 'package:http/http.dart' as http;
import '../utils/fcm_messaging.dart';

class RegisterCaseScreen extends StatefulWidget {
  static const routeName = '/register-case';

  @override
  _RegisterCaseScreenState createState() => _RegisterCaseScreenState();
}

class _RegisterCaseScreenState extends State<RegisterCaseScreen> {
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _childName = '';
  String _childParentName = '';
  String _childParentContact = '';
  String _childAddress = '';
  String _childAge;
  File _childImage;
  String token = "";
  var _authInstance = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FcmMessaging fcmMessaging = FcmMessaging();

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

        // await FirebaseMessaging.instance.getToken().then((value) {
        //   setState(() {
        //     token = value;
        //   });
        // });

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
          'token': token,
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
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    FirebaseMessaging.instance.subscribeToTopic("${_auth.currentUser.uid}");
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

// This sendPushMessage here is for Testing here only do not remove it from here!!.

  // void sendPushMessage(String token) async {
  //   try {
  //     http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'key=AAAACfEFCWo:APA91bGN1Wly0orEqfvV95z6MHQOo9jjD8VeeMM-xtRTQD4BHUy8B5agRH6QFkGXsjS5-258pHMqHE23oi8PCI-CxNSLnZ4K9gEzUFAWeGsyiQuGEeLcjh59AhDdKdgueYEsV52BY319'
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': 'Test message',
  //             'title': 'title'
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": "/topics/${_auth.currentUser.uid}",
  //         },
  //       ),
  //     );
  //     print('Hello Send successfull');
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        token = token;
      });
      print('token: ${token}');
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
                  // For Testing Notifications
                  // ElevatedButton(
                  //   onPressed: () {
                  //     sendPushMessage(token);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     shape: new RoundedRectangleBorder(
                  //       borderRadius: new BorderRadius.circular(8.0),
                  //     ),
                  //   ),
                  //   child: Container(
                  //     padding: EdgeInsets.all(12),
                  //     width: double.infinity,
                  //     child: Center(
                  //       child: Text(
                  //         "Notification",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
