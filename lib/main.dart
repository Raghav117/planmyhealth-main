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
  Firebase.initializeApp();
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

  @override
  void initState() {
    // signin();
    super.initState();
  }

  signin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser);
    auth.verifyPhoneNumber(
      phoneNumber: "+919012220988",
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
                child: Text("Authentication Successful"),
              ),
            ));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        showDialog(
            context: context,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 200,
                width: 300,
                child: Text("Authentication Failed"),
              ),
            ));
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        smsOTPDialog(context).whenComplete(() async {
          String smsCode = smsOTP;

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await auth.signInWithCredential(phoneAuthCredential);
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
                              Navigator.pop(context);
                            });
                          }
                        })
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  final _loginFormKey = GlobalKey<FormState>();
  // ApiHelper apiHelper = ApiHelper();

  @override
  Widget build(BuildContext context) {
    return Prescription();
    // Scaffold(
    //   body: ListView(
    //     children: [
    //       SizedBox(
    //         height: 200,
    //       ),
    //       RaisedButton(
    //         onPressed: () {
    //           print("yeah");
    //           signin();
    //         },
    //         child: Text("YEha"),
    //       ),
    //       // Splash(),
    //     ],
    //   ),
    // );
  }
}
