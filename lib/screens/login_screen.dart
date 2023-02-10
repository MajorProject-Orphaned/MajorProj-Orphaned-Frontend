import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    print('deviceWidth $deviceWidth and deviceHeight $deviceHeight');
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).isFirstFocus) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildLoginAppBar(context),
          body: LoginBody()),
    );
  }
}

const profileThumb = "https://image.flaticon.com/icons/png/512/891/891399.png";


class LoginBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(40.0),
      children: [
        buildHeroThumbnail(profileThumb),
        SizedBox(height: 20),
        buildTextLoginNow(),
        SizedBox(height: 20),
        buildRowCreateNew(),
        SizedBox(height: 20),
        emailField,
        SizedBox(height: 20),
        passwordField,
        SizedBox(height: 40),
        buildRowForgotPassword(),
        SizedBox(height: 10),
        buildLoginButton(),
      ],
    );
  }
}

Padding backNavIcon(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => Navigator.pop(context),
      child: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
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
    hintStyle: TextStyle(color: Colors.deepPurple),
    prefixIcon: icon,
  );
}

final emailField = TextField(
  textCapitalization: TextCapitalization.words,
  style: TextStyle(color: Colors.deepPurple),
  cursorColor: Colors.deepPurple,
  keyboardType: TextInputType.emailAddress,
  decoration: fieldDecoration(
    Icon(CupertinoIcons.mail_solid),
    'Email',
  ),
);

final passwordField = TextField(
  textCapitalization: TextCapitalization.words,
  style: TextStyle(color: Colors.deepPurple),
  autofocus: false,
  obscureText: true,
  keyboardType: TextInputType.visiblePassword,
  cursorColor: Colors.deepPurple,
  decoration: fieldDecoration(Icon(CupertinoIcons.lock_fill), 'Password'),
);


Hero buildHeroThumbnail(profileThumb) {
  return Hero(
    tag: "userThumbnail",
    child: Center(
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: NetworkImage(profileThumb),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}


ElevatedButton buildLoginButton() {
  return ElevatedButton(
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
              child: Text("Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )))));
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
    'Welcome back.\nYou have been missed!',
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
        TypewriterAnimatedText("Let's sign you in",
            textStyle: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 35)),
      ],
      onTap: () {
        print("Tap Event");
      },
    ),
  );

  //   Text(
  //   "Let's sign you in.",
  //   style: TextStyle(
  //   fontSize: 25,
  //   fontWeight: FontWeight.bold,
  // ),
  // );
}