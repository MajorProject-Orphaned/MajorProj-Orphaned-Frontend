import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

Padding backNavIcon(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      hoverColor: Colors.white,
      onTap: () => Navigator.pop(context),
      child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.blueGrey,
          )),
    ),
  );
}

AppBar buildLoginAppBar(context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: backNavIcon(context),
    actions: [],
  );
}

InputDecoration fieldDecoration(Icon icon, String fieldText) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Colors.grey.shade100, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide(color: Colors.grey.shade100),
    ),
    alignLabelWithHint: true,
    fillColor: Colors.grey.shade100,
    filled: true,
    hintText: fieldText,
    hintStyle: TextStyle(color: Colors.grey),
    prefixIcon: icon,
  );
}

Hero buildHeroThumbnail([bool isLogin = true]) {
  return Hero(
    tag: "userThumbnail",
    child: Center(
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: isLogin
            ? AssetImage('assets/images/login-user.png')
            : AssetImage('assets/images/register-user.png'),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}

Row buildRowForgotPassword(BuildContext context, [bool isLogin = true]) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(isLogin ? "Don't have an account? " : "Already have an account? ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          )),
      GestureDetector(
        onTap: () {
          isLogin
              ? Navigator.of(context)
                  .pushReplacementNamed(SignupScreen.routeName)
              : Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.routeName);
        },
        child: Text(
          isLogin ? 'Register.' : 'Login.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Text buildRowCreateNew([bool isLogin = true]) {
  return Text(
    isLogin ?
    'Welcome back.' : 'Create a new account.',
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.normal,
    ),
  );
}

SizedBox buildTextLoginNow([bool isLogin = true]) {
  return SizedBox(
    width: 250.0,
    child: AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        TypewriterAnimatedText(
          isLogin ? "Let's sign you in" : "Let's sign you up",
          textStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ],
    ),
  );
}
