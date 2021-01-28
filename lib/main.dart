import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/UI/Splash.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/prescriptionpreview.dart';
import 'UI/UsersListScreen.dart';
import 'UI/signupverify.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
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

  bool loading;

  bool dialogloading;

  FirebaseAuth _auth;

  @override
  void initState() {
    // dialogloading = false;
    // loading = true;
    // _auth = FirebaseAuth.instance;
    // print(_auth);
    // login();
    super.initState();
  }

  //! ********************************************************  Login Method   ********************************************************

  login() async {
    String email = await _auth.currentUser.email;

    if (email != null) {
    } else {
      setState(() {
        loading = false;
      });
    }
  }
//! ********************************************************  For Verify Phone   ********************************************************

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      setState(() {
        loading = false;
      });
      this.verificationId = verId;
      smsOTPDialog(context);
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {},
          verificationFailed: (var exceptio) {
            setState(() {
              print(exceptio.message);
              error = "Error Occured";
              loading = false;
            });
          });
    } catch (e) {
      handleError(e);
    }
  }

  //! ********************************************************  For Sms Diolog Box   ********************************************************

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return !dialogloading
              ? AlertDialog(
                  title: Text('Enter SMS Code'),
                  content: Container(
                    padding: EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height / 5.63,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Sms Code",
                          hintText: "Sms Code",
                          prefixIcon: Icon(Icons.code),
                          errorText: errorMessage == "" ? null : errorMessage),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        this.smsOTP = value;
                      },
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Back"),
                      onPressed: () {
                        errorMessage = "";
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                        child: Text('Done'),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (smsOTP == "") {
                            setState(() {
                              errorMessage = 'Invalid Code';
                            });
                          } else {
                            setState(() {
                              dialogloading = true;
                            });
                            signIn();
                          }
                        })
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
//! ********************************************************  For Sign in   ********************************************************

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      var authResult = await _auth.signInWithCredential(credential);
      var user = authResult.user;
      var currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);
    } catch (e) {
      handleError(e);
    }
  }

//! ********************************************************  For Handle Error in Diolog Box   ********************************************************

  handleError(var error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          dialogloading = false;
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context);
        break;
      default:
        setState(() {
          dialogloading = false;
          errorMessage = error.message;
        });

        break;
    }
  }

  final _loginFormKey = GlobalKey<FormState>();
  // ApiHelper apiHelper = ApiHelper();

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}
