import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController aname = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController an = TextEditingController();
  TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Account"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: loading == true
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Bank Account Name",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: aname,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Bank Account Name",
                                  labelText: "Bank Account Name"),
                            ),
                          ),
                        ),
                        Text(
                          "Account Number",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: an,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Account Number",
                                  labelText: "Account Number"),
                            ),
                          ),
                        ),
                        Text(
                          "IFSC Code",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          // height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: code,
                              // maxLines: 10,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "IFSC Code",
                                  labelText: "IFSC Code"),
                            ),
                          ),
                        ),
                        Text(
                          "UPI PIN",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: pin,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Upi pin",
                                  labelText: "Upi pin"),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (aname.text.length != 0 &&
                                code.text.length != 0 &&
                                pin.text.length != 0 &&
                                an.text.length != 0) {
                              setState(() {
                                loading = true;
                              });
                              if (special.length == 0) {
                                special = spe[0]["name"];
                              }
                              // var resonse = await http.post(
                              //     "http://3.15.233.253:5000/healtharticle",
                              //     body: {
                              //       "speciality": special,
                              //       "subject": subject.text,
                              //       "description": description.text,
                              //       "doctorid": data.sId
                              //     });
                              setState(() {
                                loading = false;
                              });
                              // print(resonse.body);
                              showDialog(
                                  context: context,
                                  child: Dialog(
                                    child: Container(
                                      height: 300,
                                      child: Center(
                                          child: Text("Successfully Done")),
                                    ),
                                  ));
                            } else {
                              showDialog(
                                  context: context,
                                  child: Dialog(
                                    child: Container(
                                      height: 300,
                                      child: Center(
                                          child: Text(
                                              "All Fields are Compulsory")),
                                    ),
                                  ));
                            }
                          },
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Save"),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  String special = "";
  ApiHelper apiHelper = ApiHelper();

  List<Map<String, String>> spe = [];
  void getSpecialities() {
    apiHelper.getSpecialitieslist().then((value) {
      print("get Diagnosis");
      print(value[0].name);
      for (Specialitieslist specialitieslist in value) {
        spe.add({
          "name": specialitieslist.name.toString(),
          "sId": specialitieslist.sId.toString()
        });
        print(specialitieslist.sId.toString());
      }
      loading = false;
      setState(() {});
    });
  }

  bool loading = true;
  @override
  void initState() {
    getSpecialities();
    // TODO: implement initState
    super.initState();
  }
}
