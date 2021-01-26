import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/VerifyNumber.dart';

class MobileNumber extends StatefulWidget {
  MobileNumber({Key key}) : super(key: key);

  @override
  _MobileNumberState createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  final _loginFormKey = GlobalKey<FormState>();
  ApiHelper apiHelper = ApiHelper();
  bool _isloading = false;
  TextEditingController _mobileController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mobileController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _loginFormKey,
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 20, 10),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 35, 20, 10),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What is your \nphone number?",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "To Continue to get an SMS confirmation to help you use Plan My Health. We would like your phone number.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                          child: Row(
                        children: [
                          // Container(
                          //   width: MediaQuery.of(context).size.width / 6,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: TextFormField(
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 22,
                          //           fontWeight: FontWeight.w500),
                          //       decoration: InputDecoration(
                          //           hintText: '+91 ',
                          //           hintStyle: TextStyle(
                          //               fontSize: 22,
                          //               fontWeight: FontWeight.w500)),
                          //       validator: (value) {
                          //         if (value.isEmpty) {
                          //           return 'Please enter some text';
                          //         }
                          //         return null;
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ))
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: GestureDetector(
                    onTap: () {
                      if (_loginFormKey.currentState.validate()) {
                        setState(() {
                          _isloading = true;
                        });

                        apiHelper.mobileLogin(context, _mobileController.text);
                        //     .then((value) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               VerifyNumber(otp: value)));
                        // });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _isloading == false ? "Continue" : "Loading...",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
