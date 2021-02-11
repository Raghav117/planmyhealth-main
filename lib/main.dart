import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/UI/Splash.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/prescriptionpreview.dart';
import 'UI/UsersListScreen.dart';
import 'UI/doctorRegistration.dart';
import 'UI/signupverify.dart';
import 'global/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Plan My Health',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String phoneNo;

  String phn;

  String smsOTP = "";

  String verificationId;

  String errorMessage = '';

  String error;

  bool loading = true;

  getUser() {
    auth = FirebaseAuth.instance;
    navigate();
    loading = false;
    setState(() {});
  }

  navigate() async {
    if (auth.currentUser != null) {
      print(auth.currentUser);
      mobileController.text = auth.currentUser.phoneNumber;
      if (mobileController.text.length == 13) {
        mobileController.text = mobileController.text.substring(3);
        print(mobileController.text);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return DoctorRegistration();
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    Future.delayed(Duration(seconds: 5), () {
      page = 1;
      setState(() {});
      getUser();
    });
  }

  FirebaseAuth auth;

  signin() async {
    // mobileController.text = "+91" + mobileController.text;
    getUser();
    loading = true;
    setState(() {});
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + mobileController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        showDialog(
            context: context,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 200,
                width: 300,
                child: Center(child: Text("Authentication Successful")),
              ),
            ));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        loading = false;
        setState(() {});
        showDialog(
            context: context,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 200,
                width: 300,
                child: Center(child: Text("Authentication Failed")),
              ),
            ));
      },
      codeSent: (String verificationId, int resendToken) async {
        loading = true;
        setState(() {});
        // Update the UI - wait for the user to enter the SMS code
        smsOTPDialog(context).whenComplete(() async {
          String smsCode = smsOTP;
          print(smsCode);
          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          try {
            await auth.signInWithCredential(phoneAuthCredential);
            loading = false;
            setState(() {});
            showDialog(
                context: context,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Center(child: Text("Authentication Successful")),
                  ),
                ));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return DoctorRegistration();
              },
            ));
          } catch (e) {
            showDialog(
                context: context,
                child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      width: 300,
                      child: Center(
                        child: Text("Invalid Code"),
                      ),
                    )));
          }
          loading = false;
          setState(() {});
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  //! ********************************************************  Login Method   ********************************************************

  //! ********************************************************  For Sms Diolog Box   ********************************************************

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: Scaffold(
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                page = 1;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 35, 20, 10),
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
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
                          mobileController.text,
                      // widget.otp,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Container(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: Colors.green,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    onChanged: (value) {
                      smsOTP = value;
                    },
                  ))
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
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
                      "Verify",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
        )),
      ),
    );
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    // return DoctorRegistration();
    return Scaffold(
        body: page == 0
            ? Center(
                child: Image.asset("assets/logo.png"),
              )
            : loading == true
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 15),
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: TextFormField(
                                    controller: mobileController,
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
                            signin();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
  }
}
