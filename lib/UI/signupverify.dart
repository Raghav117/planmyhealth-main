import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/UI/doctorRegistration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpVerifyNumber extends StatefulWidget {
  SignUpVerifyNumber({this.number});
  final String number;
  @override
  _SignUpVerifyNumberState createState() => _SignUpVerifyNumberState();
}

class _SignUpVerifyNumberState extends State<SignUpVerifyNumber> {
  final _verifyotpFormKey = GlobalKey<FormState>();
  // ApiHelper apiHelper = ApiHelper();
  bool _isloading = false;
  TextEditingController _oneController;
  TextEditingController _twoController;
  TextEditingController _threeController;
  TextEditingController _fourController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _oneController = TextEditingController();
    _twoController = TextEditingController();
    _threeController = TextEditingController();
    _fourController = TextEditingController();
  }

  int random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _verifyotpFormKey,
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 35, 20, 10),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Text(
                          "Verify phone \nnumber",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                        child: Text(
                          "Check your SMS message. We've send you the PIN at +91" +
                              this.widget.number +
                              " your Otp is: " +
                              random(1000, 9999).toString(),
                          // widget.otp,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _oneController,
                                onChanged: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _isloading = false;
                                    });
                                    return "";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(

                                    // border: new OutlineInputBorder(
                                    //     borderSide: new BorderSide(color: Colors.teal)),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _twoController,
                                onChanged: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _isloading = false;
                                    });
                                    return "";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(

                                    // border: new OutlineInputBorder(
                                    //     borderSide: new BorderSide(color: Colors.teal)),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _threeController,
                                onChanged: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _isloading = false;
                                    });
                                    return "";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(

                                    // border: new OutlineInputBorder(
                                    //     borderSide: new BorderSide(color: Colors.teal)),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _fourController,
                                onChanged: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _isloading = false;
                                    });
                                    return "";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(

                                    // border: new OutlineInputBorder(
                                    //     borderSide: new BorderSide(color: Colors.teal)),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                  child: GestureDetector(
                    onTap: () {
                      if (_verifyotpFormKey.currentState.validate()) {
                        setState(() {
                          _isloading = true;
                        });
                        // String otp = _oneController.text +
                        //     _twoController.text +
                        //     _threeController.text +
                        //     _fourController.text.toString();
                        // print(otp);
                        // apiHelper.verifyNumber(context, otp).then((value) {
                        //   if (value != null) {
                        //     saveId(value.data.toString(),
                        //             value.data.name.toString())
                        //         .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorRegistration()));
                        //     });
                        //   } else {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) {
                        //         return AlertDialog(
                        //           title: Text('Authentication Failed'),
                        //           content: SingleChildScrollView(
                        //             child: ListBody(
                        //               children: <Widget>[
                        //                 Text('Plese check Credencial'),
                        //                 Text('Invalid user name or password'),
                        //               ],
                        //             ),
                        //           ),
                        //           actions: <Widget>[
                        //             TextButton(
                        //               child: Text('OK'),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   }
                        // });
                      }
                    },
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _isloading == false ? "Verify" : "Loading...",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Didn\'t recive',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  Resend ',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  // Future saveId(String id, String name) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print("Save Name And ID");
  //   print(id);
  //   prefs.setString('id', id);
  //   prefs.setString('name', name);
  // }
}
