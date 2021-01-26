import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/Login.dart';
import 'package:plan_my_health/UI/MobileNumber.dart';
import 'package:plan_my_health/UI/doctorRegistration.dart';
import 'package:plan_my_health/UI/signupmobile.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: SafeArea(
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(height: height * 0.4),
                  Center(
                      child: GestureDetector(
                          child: Image.asset("assets/logo.png"))),
                  SizedBox(height: height * 0.02),
                  FlatButton(
                    child: Text(
                      """If you are a Health Service Provider
  -Register Here""",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpMobileNumber()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
