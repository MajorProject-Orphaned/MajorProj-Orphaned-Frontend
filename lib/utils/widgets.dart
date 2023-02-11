import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

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

Hero buildHeroThumbnail() {
  return Hero(
    tag: "userThumbnail",
    child: Center(
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: AssetImage('assets/images/login-user.png'),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}

Row buildRowForgotPassword() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Don't have an account? ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          )),
      Text(
        'Register.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Text buildRowCreateNew() {
  return Text(
    'Welcome back.',
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.normal,
    ),
  );
}

SizedBox buildTextLoginNow() {
  return SizedBox(
    width: 250.0,
    child: AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        TypewriterAnimatedText(
          "Let's sign you in",
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
