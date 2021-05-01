import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UI/bezier.dart';
import 'UI/doctorRegistration.dart';
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
  String verId;

  int _forceResendingToken;

//! ------------------------------------------------ Check user is authenticate or not and then forward it towards  -----------------------------------------------

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
      getToken();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return DoctorRegistration();
        },
      ));
    }
  }

//!-----------------  INITSTATE  ------------------------------------

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();

    //! -----------------------    For Splash Screen -------------------------
    Future.delayed(Duration(seconds: 3), () {
      page = 4;
      setState(() {});
      Future.delayed(Duration(seconds: 3), () {
        page = 1;
        setState(() {});
        getUser();
      });
    });
  }

  FirebaseAuth auth;

//! -----------------------  For signing the user  -----------------------------------
//
  signin() async {
    getUser();
    loading = true;
    setState(() {});
    auth.verifyPhoneNumber(
        phoneNumber: "+91" + mobileController.text,
        timeout: new Duration(minutes: 2),
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      width: 300,
                      child: Center(child: Text("Authentication Successful")),
                    ),
                  ));
          getToken();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return DoctorRegistration();
            },
          ));
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          loading = false;
          setState(() {});
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                      height: 200,
                      width: 300,
                      child: Center(
                        child: Text(e.code),
                      )),
                );
              });
        },
        codeSent: (String verificationId, [int resendToken]) async {
          this.verId = verificationId;
          _forceResendingToken = resendToken;
          loading = true;
          setState(() {});
          // Update the UI - wait for the user to enter the SMS code
          smsOTPDialog(context).whenComplete(() async {
            String smsCode = smsOTP;
            print(smsCode);
            // Create a PhoneAuthCredential with the code

            // Sign the user in (or link) with the credential
            if (smsCode.length > 0)
              try {
                AuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);

                await auth.signInWithCredential(phoneAuthCredential);
                loading = false;
                setState(() {});
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            height: 200,
                            width: 300,
                            child: Center(
                                child: Text("Authentication Successful")),
                          ),
                        ));
                getToken();
                Navigator.pop(context);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return DoctorRegistration();
                  },
                ));
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 200,
                          width: 300,
                          child: Center(
                            child: Text("Invallid Code"),
                          ),
                        )));
              }
            loading = false;
            setState(() {});
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verId = verificationId;
        },
        forceResendingToken: _forceResendingToken);
  }

  //! ********************************************************  For Sms Diolog Box   ********************************************************

  Future<bool> smsOTPDialog(BuildContext context) async {
    // await SmsAutoFill().listenForCode;
    return showDialog(
      context: context,
      builder: (context) => Scaffold(
        body: Container(
            child: Stack(
          children: [
            Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(child: BezierContainer())),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    // page = 1;

                    // setState(() {});
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 35, 20, 10),
                    child: Text(
                      "Back",
                      style: GoogleFonts.dosis(
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
                          style: GoogleFonts.dosis(
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
                          style: GoogleFonts.dosis(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Container(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            fillColor: Colors.greenAccent,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        onChanged: (value) {
                          smsOTP = value;
                        },
                      )),
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
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Verify",
                          style: GoogleFonts.dosis(
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
                      style: GoogleFonts.dosis(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  Resend ',
                            style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }

  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: page == 4
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image-home.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(12.0),
                          child: Text(
                            'Welcome To \n Plan My Health',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dosis(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : page == 0
                ? Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Image.asset('assets/splash.jpg')),
                          Container(
                            margin: EdgeInsets.all(12.0),
                            child: Text(
                              'Welcome To Plan My Health',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dosis(
                                fontWeight: FontWeight.bold,
                                // fontSize: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )
                : loading == true
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(
                        child: Stack(
                        children: [
                          Positioned(
                              top: -MediaQuery.of(context).size.height * .15,
                              right: -MediaQuery.of(context).size.width * .4,
                              child: Container(child: BezierContainer())),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 35, 20, 10),
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "What is your \nphone number?",
                                      style: GoogleFonts.dosis(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      "To Continue to get an SMS confirmation to help you use Plan My Health. We would like your phone number.",
                                      style: GoogleFonts.dosis(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Container(
                                        child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          child: TextFormField(
                                            controller: mobileController,
                                            keyboardType: TextInputType.number,
                                            maxLength: 10,
                                            style: GoogleFonts.dosis(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                            decoration: InputDecoration(
                                                hintText: 'Phone Number',
                                                hintStyle: GoogleFonts.dosis(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: GestureDetector(
                                  onTap: () {
                                    signin();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "Continue",
                                        style: GoogleFonts.dosis(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )));
  }
}
