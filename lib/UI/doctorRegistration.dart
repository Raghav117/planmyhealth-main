import 'dart:convert';
import 'dart:io';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/accrediation.dart';
import 'package:plan_my_health/UI/speciality.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:plan_my_health/model/accrediations.dart';
import 'package:plan_my_health/model/speciality.dart';

import '../global/global.dart';
import 'bezier.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/model/image-capture.dart';
import 'package:plan_my_health/model/selectCityList.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/doctor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DoctorRegistration extends StatefulWidget {
  @override
  _DoctorRegistrationState createState() => _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {
  String selectCity = "Mumbai";

  checkDoctorExists() async {
    // mobileController.text = "8356928929";
    var response = await http.post("http://3.15.233.253:5000/checkdoctorexist",
        body: {
          "mobilenumber": mobileController.text
        }); //!  **************  To Do
    bool exists = jsonDecode(response.body)["status"];
    print(exists);
    if (exists == true) {
      data = Data.fromJson(jsonDecode(response.body)["data"]);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ));
    } else
      loading = false;
    setState(() {});
  }

  getAccrediations() async {
    var response = await http.get("http://3.15.233.253:5000/getaccrediation");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["accrediationlist"]) {
      accrediation.add(Accrediation.fromJson(data));
    }
  }

  getSpeciality() async {
    int ma = _DoctorCategory.indexOf(_selectedcategory);

    var response = await http.get(
        "http://3.15.233.253:5000/specialitieslist?prov_type=${_doctorCategory[ma]}");
    // print(response.body);
    Map m = jsonDecode(response.body);
    print(m);
    speciality.clear();

    for (var data in m["specialitieslist"]) {
      speciality.add(Speciality.fromJson(data));
    }
    setState(() {
      loading = false;
    });
  }

  bool loading = true;
  List<Accrediation> accrediation = [];
  List<Speciality> speciality = [];
  List<bool> accrediationColor = [], specialityColor = [];

  final _nameformKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clinicformKey = GlobalKey<FormState>();
  final _clinicController = TextEditingController();
  final _addressformKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _regNumformKey = GlobalKey<FormState>();
  final _regNumController = TextEditingController();
  final _emailformKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  // final _cityController = TextEditingController();
  final _experiencecontroller = TextEditingController();

  var _selectedcategory;
  String _selectedpractice = "Allopathy";
  var _selectedexperience = "";
  String _selectedqual = "BAMS";
  // String _selectedcity = "";
  String _selectedgender = "Male";
  // String cityName = "";
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedendTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  // List<City> selectCity = [];
  List images = List();
  File _imageFile;
  File _signatureimageFile;
  List<Asset> multiimages = List<Asset>();
  String _error = 'No Error Dectected';
  List<String> city = <String>[
    "Mumbai",
    "thane",
    "Navi Mumbai",
    "Pune",
    "Ahmedabad",
    "Delhi",
    "Bengluru",
    "Kolkata",
    "Indore",
    "Chandigarh",
    "Lucknow",
    "Patna"
  ];
  List _DoctorCategory = [];
  List _doctorCategory = [];

  List<String> _City = <String>[
    'Doctor',
    'Clinic',
    'Hospital',
    'Poly Clinic',
    'Nursing Home',
    'Nurse',
    'Physiotherapist',
    'AYUSH',
    'Psychologist',
    'Dietitian',
    'Caregiver',
    'Specialist',
  ];

  List _Qualification = [];

  List<bool> qualtification = [];

  List<String> _PracticeType = <String>[
    'Allopathy',
    'Ayurveda',
    'Homeopathy',
    'Hallopathy',
  ];

  List<String> _Gender = <String>[
    'Female',
    'Male',
    'Not Specified',
  ];

  getCategory() async {
    var r = await http.get("http://3.15.233.253:5000/providertypeslist");
    Map re = jsonDecode(r.body);
    re["providerlist"].forEach((element) {
      _DoctorCategory.add(element["prov_type_name"]);
      _doctorCategory.add(element["prov_type_code"]);
    });
  }

  getQualifications() async {
    var m = _DoctorCategory.indexOf(_selectedcategory);

    var r = await http.get(
        "http://3.15.233.253:5000/doctorqualificationslist?prov_type=${_doctorCategory[m]}");
    Map re = jsonDecode(r.body);
    print(re);
    _Qualification = re["doctorqualificationslist"];
    qualtification.clear();
    _Qualification.forEach((element) {
      qualtification.add(false);
    });

    getSpeciality();
  }

  bool check = false;

  bool vedio = false;
  bool medical = false;
  bool clinic = false;
  bool wellness = false;
  bool chat = false;
  bool homevisit = false;

  @override
  void initState() {
    super.initState();
    getToken();
    loading = true;
    getCategory();
    checkDoctorExists();
    getAccrediations();
    setState(() {});

    images.add("Add Image");
    getLocation();
    _experiencecontroller.text =
        "0"; // Setting the initial value for the field.
  }

  Location location = Location();
  LocationData locationData;
  getLocation() async {
    locationData = await location.getLocation();
  }

  Widget text() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlueAccent.withOpacity(0.2)),
        width: MediaQuery.of(context).size.width - 120,
        child: TextField(
          cursorColor: Colors.greenAccent,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ));
  }

  Widget _entryField(String title, isPassword, TextEditingController text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: GoogleFonts.dosis(
                    fontWeight: FontWeight.bold, fontSize: 17)),
            SizedBox(
              height: 10,
            ),
            TextField(
                controller: text,
                obscureText: isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: Container(child: BezierContainer())),
                SingleChildScrollView(
                    child: SafeArea(
                        child: Column(children: [
                  SizedBox(
                    height: 90,
                  ),
                  Text("Register",
                      style: GoogleFonts.dosis(
                          fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(height: height * 0.04),
                  _entryField("Name", false, _nameController),
                  _entryField("Email", false, _emailController),
                  // _entryField("Name", false),
                  // doctorName(),
                  // SizedBox(height: height * 0.04),
                  // email(),
                  // SizedBox(height: height * 0.04),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Date of Birth  ",
                      style: GoogleFonts.dosis(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(" " + selectedDate.toString().substring(0, 10),
                        style: GoogleFonts.dosis()),
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: DropdownButton(
                          items: _Gender.map((value) => DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: GoogleFonts.dosis(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                value: value,
                              )).toList(),
                          onChanged: (selectedgen) {
                            setState(() {
                              _selectedgender = selectedgen;
                              print(_selectedgender);
                            });
                          },
                          value: _selectedgender,
                          hint: Text(
                            "Select Gender",
                            style: GoogleFonts.dosis(color: Colors.green),
                          ),
                          elevation: 5,
                          isExpanded: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: DropdownButton(
                          items:
                              _DoctorCategory.map((value) => DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: GoogleFonts.dosis(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.green),
                                    ),
                                    value: value.toString(),
                                  )).toList(),
                          onChanged: (selectedCategory) {
                            setState(() {
                              loading = true;
                              _selectedcategory = selectedCategory;
                            });
                            getQualifications();
                          },
                          value: _selectedcategory == null
                              ? null
                              : _selectedcategory.toString(),
                          hint: Text(
                            "Select Category",
                            style: GoogleFonts.dosis(color: Colors.green),
                          ),
                          elevation: 5,
                          isExpanded: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Qualifications",
                      style: GoogleFonts.dosis(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Column(
                    children: _Qualification.map((e) {
                      int index = _Qualification.indexOf(e);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(e["qualific_name"].toString(),
                                    style: GoogleFonts.dosis())),
                            Expanded(
                              child: Checkbox(
                                activeColor: Colors.greenAccent,
                                value: qualtification[index],
                                onChanged: (value) {
                                  setState(() {
                                    qualtification[index] =
                                        !qualtification[index];
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: height * 0.04),
                  Text(
                    "Services",
                    style: GoogleFonts.dosis(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      // fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: vedio,
                          onChanged: (value) {
                            setState(() {
                              vedio = value;
                            });
                          }),
                      Text(
                        "Video Call",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: check,
                          onChanged: (value) {
                            setState(() {
                              check = value;
                            });
                          }),
                      Text(
                        "Call",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: chat,
                          onChanged: (value) {
                            setState(() {
                              chat = value;
                            });
                          }),
                      Text(
                        "Chat",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: clinic,
                          onChanged: (value) {
                            setState(() {
                              clinic = value;
                            });
                          }),
                      Text(
                        "At Clinic",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: medical,
                          onChanged: (value) {
                            setState(() {
                              medical = value;
                            });
                          }),
                      Text(
                        "Medical Camps",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: wellness,
                          onChanged: (value) {
                            setState(() {
                              wellness = value;
                            });
                          }),
                      Text(
                        "Wellness Sessions",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.greenAccent,
                          value: homevisit,
                          onChanged: (value) {
                            setState(() {
                              homevisit = value;
                            });
                          }),
                      Text(
                        "Home Visit",
                        style: GoogleFonts.dosis(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var response =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Accrediations();
                        },
                      ));
                      if (response != null) accrediationColor = response;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Accrediations",
                            style: GoogleFonts.dosis(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "+",
                            style: GoogleFonts.dosis(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  accrediationColor.indexOf(true) == -1
                      ? Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Not Selected",
                              style: GoogleFonts.dosis(),
                            ),
                          ),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: accrediationColor.length,
                            itemBuilder: (context, index) {
                              return accrediationColor[index] == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          accrediation[index].accrediationCode,
                                          style: GoogleFonts.dosis(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.green)),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),

                  //!********************  Speciality  *********************

                  GestureDetector(
                    onTap: () async {
                      var response =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Specialityy(
                            speciality: speciality,
                          );
                        },
                      ));
                      if (response != null) specialityColor = response;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Specialities",
                            style: GoogleFonts.dosis(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "+",
                            style: GoogleFonts.dosis(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  specialityColor.indexOf(true) == -1
                      ? Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Not Selected",
                              style: GoogleFonts.dosis(),
                            ),
                          ),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: specialityColor.length,
                            itemBuilder: (context, index) {
                              return specialityColor[index] == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(speciality[index].name,
                                          style: GoogleFonts.dosis(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.green)),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Years of experience: ",
                            style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,

                              // fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            controller: _experiencecontroller,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 38.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    size: 18.0,
                                  ),
                                  onTap: () {
                                    int currentValue =
                                        int.parse(_experiencecontroller.text);
                                    setState(() {
                                      currentValue++;
                                      _experiencecontroller.text =
                                          (currentValue)
                                              .toString(); // incrementing value
                                    });
                                  },
                                ),
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 18.0,
                                ),
                                onTap: () {
                                  int currentValue =
                                      int.parse(_experiencecontroller.text);
                                  setState(() {
                                    print("Setting state");
                                    currentValue--;
                                    _experiencecontroller.text =
                                        (currentValue > 0 ? currentValue : 0)
                                            .toString(); // decrementing value
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  _entryField("Clinic Name", false, _clinicController),
                  SizedBox(height: height * 0.04),
                  Text(
                    "Selecty City",
                    style: GoogleFonts.dosis(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.04),
                  DropdownButton(
                      value: selectCity,
                      onChanged: (value) {
                        setState(() {
                          selectCity = value;
                        });
                      },
                      items: city.map((e) {
                        return DropdownMenuItem(
                          child: Text(e, style: GoogleFonts.dosis()),
                          value: e,
                        );
                      }).toList()),
                  SizedBox(height: height * 0.06),
                  _entryField("Address", false, _addressController),
                  SizedBox(height: height * 0.04),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Working Hours: ",
                      style: GoogleFonts.dosis(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,

                        // fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(children: [
                    SizedBox(width: width * 0.2),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        _startTime(context);
                      },
                      child: Text(
                        "From: " +
                            selectedStartTime.toString().substring(10, 15),
                        style: GoogleFonts.dosis(),
                      ),
                    ),
                    SizedBox(width: width * 0.1),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        _endTime(context);
                      },
                      child: Text(
                        "To: " + selectedendTime.toString().substring(10, 15),
                        style: GoogleFonts.dosis(),
                      ),
                    ),
                  ]),
                  SizedBox(height: height * 0.04),
                  _entryField("Registration Number", false, _regNumController),
                  SizedBox(height: height * 0.04),

                  InkWell(
                    onTap: () {
                      _onAddImageClick();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Upload Profile Picture",
                          style: GoogleFonts.dosis(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _imageFile == null
                      ? Container()
                      : Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.greenAccent, width: 2)),
                          child: Image.file(_imageFile),
                        ),
                  SizedBox(height: height * 0.04),
                  InkWell(
                    onTap: () {
                      _onAddSignatureClick();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Upload Signature",
                          style: GoogleFonts.dosis(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _signatureimageFile == null
                      ? Container()
                      : Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.greenAccent, width: 2)),
                          child: Image.file(_signatureimageFile),
                        ),
                  SizedBox(height: height * 0.04),
                  InkWell(
                    onTap: () {
                      loadAssets();
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Load Assets",
                          style: GoogleFonts.dosis(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildGridView(),
                  SizedBox(height: height * 0.02),
                  saveButton(context),
                  SizedBox(height: height * 0.07),
                ]))),
                // Align(
                //   alignment: Alignment.center,
                //   child: FittedBox(
                //     child: Text(
                //       "Registration for Healthcare Service Provider",
                //       style: GoogleFonts.dosis(
                //           color: Colors.greenAccent,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 17
                //           // fontSize: 18,
                //           ),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }

  Widget buildGridView() {
    return multiimages.length == 0
        ? Container()
        : Container(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(multiimages.length, (index) {
                Asset asset = multiimages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.greenAccent, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AssetThumb(
                        asset: asset,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 50,
        enableCamera: true,
        selectedAssets: multiimages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      multiimages = resultList;
      _error = error;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1890, 01),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          child: child,
          data: ThemeData.light().copyWith(
            primaryColor: Colors.greenAccent,
            accentColor: Colors.greenAccent,
            colorScheme: ColorScheme.light(primary: Colors.greenAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

//!  ---------------  Save Button  *********************************
  Widget saveButton(context) {
    return OutlineButton(
      onPressed: () async {
        int i = -1;
        String qualif = "";
        while (++i < qualtification.length) {
          if (qualtification[i] == true) {
            print(_Qualification[i]);
            qualif = qualif + _Qualification[i]["qualific_code"] + ",";
          }
        }
        if (_experiencecontroller.text.length != 0 &&
            qualif.length > 0 &&
            _regNumController.text.length != 0 &&
            _clinicController.text.length != 0 &&
            _nameController.text.length != 0 &&
            _addressController.text.length != 0 &&
            _emailController.text.length != 0 &&
            _selectedcategory != null &&
            _selectedpractice.length != 0 &&
            // _selectedqual.length != 0 &&
            _selectedgender.length != 0 &&
            selectedDate != null &&
            selectedStartTime != null &&
            selectedendTime != null) {
          List<String> mode = [];
          if (check == true) mode.add("Call");
          if (vedio == true) mode.add("Vedio Call");
          if (chat == true) mode.add("Chat");
          if (clinic == true) mode.add("At Clinic");
          if (homevisit == true) mode.add("Home Visit");
          if (medical == true) mode.add("Medical Camps");
          if (wellness == true) mode.add("Wellness Sessions");

          loading = true;
          setState(() {});
          i = -1;
          List furtherA = [];
          accrediationColor.forEach((element) {
            ++i;
            if (element == true) {
              furtherA.add(jsonEncode(accrediation[i]));
            }
          });
          i = -1;
          List furtherS = [];
          specialityColor.forEach((element) {
            ++i;
            if (element == true) {
              furtherA.add(jsonEncode(speciality[i]));
            }
          });
          String url =
              "http://3.15.233.253:5000/doctorregister?name=${_nameController.text}&email=${_emailController.text}&dob=${selectedDate}&gender=${_selectedgender}&category=${_selectedcategory}&practice=${_selectedpractice}&qualification=${qualif}&experience=${_experiencecontroller.text}&clinicname=${_clinicController.text}&city=${selectCity}&address=${_addressController.text}&workingto=${selectedendTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&workingfrom=${selectedStartTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&regno=${_regNumController.text}&mobilenumber=${mobileController.text}&modeofservices=$mode&latitude=${locationData.latitude}&longitude=${locationData.longitude}&accrediation=${furtherA}&specialities=${furtherS}";
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(url),
          );
          if (_imageFile != null) {
            request.files.add(http.MultipartFile(
              'profilepicture',
              _imageFile.readAsBytes().asStream(),
              _imageFile.lengthSync(),
              filename: "profilepicture.jpg",
            ));
          }
          if (_signatureimageFile != null) {
            request.files.add(http.MultipartFile(
              'imagesignature',
              _signatureimageFile.readAsBytes().asStream(),
              _signatureimageFile.lengthSync(),
              filename: "imagesignature.jpg",
            ));
          }
          //! ********************************   This is function for sending multiple images  ********************************
          multiimages.forEach((element) async {
            String filePath =
                await FlutterAbsolutePath.getAbsolutePath(element.identifier);
            request.files.add(http.MultipartFile(
              'document',
              File(filePath).readAsBytes().asStream(),
              File(filePath).lengthSync(),
              filename: "document.jpg",
            ));
          });
          var res = await request.send();
          print(res.statusCode);
          print(res);

          // var response = await http.post("");
          // print(response.body);
          // loading = false;
          setState(() {});
          //!        TO   DO
          checkDoctorExists();
          // Navigator.of(context)
          //     .pushReplacement(MaterialPageRoute(builder: (context) {
          //   return Home();
          // }));
        } else {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      width: 300,
                      child: Center(
                        child: Text(
                          "All Fields are Cumpulsory",
                          style: GoogleFonts.dosis(),
                        ),
                      ),
                    ),
                  ));
        }
      },
      borderSide: BorderSide(color: Colors.green),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text("Save", style: GoogleFonts.dosis()),
    );
  }

  _onAddImageClick() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  _onAddSignatureClick() async {
    _signatureimageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<Null> _startTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedStartTime)
      setState(() {
        selectedStartTime = picked_s;
      });
    print(picked_s.toString());
  }

  Future<Null> _endTime(BuildContext context) async {
    final TimeOfDay picked_e = await showTimePicker(
        context: context,
        initialTime: selectedendTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked_e != null && picked_e != selectedendTime)
      setState(() {
        selectedendTime = picked_e;
      });
    print(picked_e.toString());
  }

  Widget row(City name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name.name,
          style: GoogleFonts.dosis(color: Colors.green),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Widget doctorName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0),
      child: Form(
        key: _nameformKey,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return "required";
            } else {}
          },
          controller: _nameController,
          decoration: InputDecoration(
            // fillColor: Colors.grey[200],
            // filled: true,
            labelText: "Name",
            labelStyle: GoogleFonts.dosis(color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget email() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0),
      child: Form(
        key: _emailformKey,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return "required";
            } else {}
          },
          controller: _emailController,
          decoration: InputDecoration(
            // fillColor: Colors.grey[200],
            // filled: true,
            labelText: "Email",
            labelStyle: GoogleFonts.dosis(color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget regNum() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0),
      child: Form(
        key: _regNumformKey,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return "required";
            } else {}
          },
          controller: _regNumController,
          decoration: InputDecoration(
            // fillColor: Colors.grey[200],
            // filled: true,
            labelText: "registration Number",
            labelStyle: GoogleFonts.dosis(color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget address() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0),
      child: Form(
        key: _addressformKey,
        child: TextFormField(
          maxLines: 2,
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return "required";
            } else {}
          },
          controller: _addressController,
          decoration: InputDecoration(
            // fillColor: Colors.grey[200],
            // filled: true,
            labelText: "Address",
            labelStyle: GoogleFonts.dosis(color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget clinicName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0),
      child: Form(
        key: _clinicformKey,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return "required";
            } else {}
          },
          controller: _clinicController,
          decoration: InputDecoration(
            // fillColor: Colors.grey[200],
            // filled: true,
            labelText: "Clinic Name",
            labelStyle: GoogleFonts.dosis(color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }
}
