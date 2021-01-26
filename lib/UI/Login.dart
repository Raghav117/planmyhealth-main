import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/MobileNumber.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                    child: Image.asset("assets/login.png"),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2 -15,
                  child: Column(children: [
                     SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Login With",
                    style: TextStyle(color: Colors.green, fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 12),
             


                 Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
child: GestureDetector(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MobileNumber()));                    },
                        child: Container(
                         
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Phone Number", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),),
                          ),
                        ),
                      ),
              ),
                SizedBox(height: 30),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 0.2,
                        width: MediaQuery.of(context).size.width / 2 - 32,
                        color: Colors.black),
                    Text(
                      "  Or  ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      height: 0.2,
                      color: Colors.black,
                    )
                  ],
                )),
                SizedBox(height: 30),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width:20),
                      Image(
                          height: 60,
                          width: 60,
                          image: AssetImage('assets/fb.png')),
                          SizedBox(width:25),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.black,
                      ),
                      SizedBox(width:20),
                      Image(
                          height: 60,
                          width: 60,
                          image: AssetImage('assets/google.png')),
                      SizedBox(width: 25),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Text("By continuing, you agree to terms & Conditions")
                  ],),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
