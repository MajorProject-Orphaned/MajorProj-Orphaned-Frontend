import 'package:firebase_core/firebase_core.dart';
import 'package:orphaned/screens/add_suspected_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './screens/add_suspected_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/home_page.dart';
import './screens/register_case.dart';
import './screens/Cases_screen.dart';
import './screens/case_detail_screen.dart';
import './screens/admin_screen.dart';
import './screens/update_profile_screen.dart';
import './screens/profile_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orphaned',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        RegisterCaseScreen.routeName: (ctx) => RegisterCaseScreen(),
        Cases.routeName: (ctx) => Cases(),
        CaseDetailScreen.routeName: (ctx) => CaseDetailScreen(),
        AdminScreen.routeName: (ctx) => AdminScreen(),
        UpdateProfileScreen.routeName: (ctx) => UpdateProfileScreen(),
        ProfilePage.routeName: (ctx) => ProfilePage(),
        AddSuspectedChild.routeName: (ctx) => AddSuspectedChild(),
      },
    );
  }
}
