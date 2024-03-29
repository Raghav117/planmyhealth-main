import 'dart:convert';
import 'dart:io';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/accrediation.dart';
import 'package:plan_my_health/UI/speciality.dart';
import 'package:plan_my_health/model/accrediations.dart';
import 'package:plan_my_health/model/facilityModel.dart';
import 'package:plan_my_health/model/prates.dart';
import 'package:plan_my_health/model/speciality.dart';
import '../global/global.dart';
import 'bezier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/global/design.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/doctor.dart';

class DoctorRegistration extends StatefulWidget {
  @override
  _DoctorRegistrationState createState() => _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {
  String selectCity = "";
  bool agree = false;
  List<String> language = [];
  List<bool> lang = [];
  Map provider = Map();
  bool page = false;

  List<PRates> pr = [];

  bool loading = true;
  List<Accrediation> accrediation = [];
  List<Speciality> speciality = [];
  List<bool> accrediationColor = [], specialityColor = [];

  final _nameController = TextEditingController();
  final _clinicController = TextEditingController();
  final _addressController = TextEditingController();
  final _regNumController = TextEditingController();
  final _emailController = TextEditingController();
  final _experiencecontroller = TextEditingController();

  var _selectedcategory;
  String _selectedpractice = "Allopathy";

  String _selectedgender = "Male";

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedendTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  List images = [];
  File _imageFile;
  File _signatureimageFile;
  List<Asset> multiimages = [];
  List<String> city = <String>[];
  List _doctorCategory1 = [];
  List _doctorCategory = [];

  List _qualification = [];
  List<Facility> facility = [];
  List<bool> facilityColor = [];

  List<bool> qualtification = [];

  List<String> _gender = <String>[
    'Female',
    'Male',
    'Not Specified',
  ];

  Location location = Location();
  LocationData locationData;
  bool check = false;

  bool vedio = false;
  bool medical = false;
  bool clinic = false;
  bool wellness = false;
  bool chat = false;
  bool homevisit = false;

  TextEditingController searchController = TextEditingController();

  //! -------------------------------------------For Fetching Current Location ----------------------------------------

  getLocation() async {
    locationData = await location.getLocation();
  }

  //! -------------------------------------------For Fetching Cities ----------------------------------------
  getCity() async {
    http.Response response =
        await http.get("http://3.15.233.253:5000/citylist");
    Map m = jsonDecode(response.body);
    for (var x in m["citylist"]) {
      city.add(x["city_name"]);
    }
    selectCity = city[0];
  }

  //! -------------------------------------------For Fetching Languages ----------------------------------------

  getLanguage() async {
    http.Response response =
        await http.get("http://3.15.233.253:5000/getlanguage");
    Map m = jsonDecode(response.body);
    for (var x in m["languagelist"]) {
      language.add(x["name"]);
      lang.add(false);
    }
    print(language);
  }

  //! -------------------------------------------For Fetching Accrediation ----------------------------------------

  getAccrediations() async {
    var response = await http.get("http://3.15.233.253:5000/getaccrediation");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["accrediationlist"]) {
      accrediation.add(Accrediation.fromJson(data));
    }
  }

  //! -------------------------------------------For Fetching Speciality ----------------------------------------

  getSpeciality() async {
    int ma = _doctorCategory1.indexOf(_selectedcategory);

    var response = await http.get(
        "http://3.15.233.253:5000/specialitieslist?prov_type=${_doctorCategory[ma]}");
    Map m = jsonDecode(response.body);
    print(m);
    speciality.clear();

    for (var data in m["specialitieslist"]) {
      speciality.add(Speciality.fromJson(data));
    }
    print(speciality);
    setState(() {
      loading = false;
    });
    response = await http.get(
        "http://3.15.233.253:5000/providerrates?prov_type=${_doctorCategory[ma]}");
    m = jsonDecode(response.body);
    print(m);
    provider = m;
    pr.clear();

    provider["providerrate"].forEach((value) {
      pr.add(PRates.fromJson(value));
    });
    getFacilityList();
  }

  //! -------------------------------------------For Fetching Facilities ----------------------------------------

  getFacilityList() async {
    int ma = _doctorCategory1.indexOf(_selectedcategory);

    var r = await http.get(
        "http://3.15.233.253:5000/facilitylist?prov_type=${_doctorCategory[ma]}");
    Map re = jsonDecode(r.body);
    print(re);
    facility.clear();
    facilityColor.clear();
    for (var data in re["facilitylist"]) {
      facility.add(Facility.fromJson(data));
      facilityColor.add(false);
    }
  }

  //! -------------------------------------------For Fetching Categories ----------------------------------------

  getCategory() async {
    var r = await http.get("http://3.15.233.253:5000/providertypeslist");
    Map re = jsonDecode(r.body);
    re["providerlist"].forEach((element) {
      _doctorCategory1.add(element["prov_type_name"]);
      _doctorCategory.add(element["prov_type_code"]);
    });
  }

  //! -------------------------------------------For Fetching Qualificaitons ----------------------------------------

  getQualifications() async {
    var m = _doctorCategory1.indexOf(_selectedcategory);

    var r = await http.get(
        "http://3.15.233.253:5000/doctorqualificationslist?prov_type=${_doctorCategory[m]}");
    Map re = jsonDecode(r.body);
    print(re);
    _qualification = re["doctorqualificationslist"];
    qualtification.clear();
    _qualification.forEach((element) {
      qualtification.add(false);
    });

    getSpeciality();
  }

//! ------------ For Picking Image   ----------------------------------------------

  _onAddImageClick() async {
    // ignore: deprecated_member_use
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

//! ------------ For Picking Signature Image   ----------------------------------------------

  _onAddSignatureClick() async {
    _signatureimageFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

//! ------------ For taking Start Time   ----------------------------------------------

  Future<Null> _startTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedStartTime)
      setState(() {
        selectedStartTime = pickedS;
      });
    print(pickedS.toString());
  }

//! ------------ For taking End Time   ----------------------------------------------

  Future<Null> _endTime(BuildContext context) async {
    final TimeOfDay pickedE = await showTimePicker(
        context: context,
        initialTime: selectedendTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (pickedE != null && pickedE != selectedendTime)
      setState(() {
        selectedendTime = pickedE;
      });
    print(pickedE.toString());
  }

  //! ---------------  Check if user is already registerd or not and then navigate to desired screen ---------------------------------------

  checkDoctorExists() async {
    // mobileController.text = "8356928929";
    // mobileController.text = "8357729";
    var response = await http.post("http://3.15.233.253:5000/checkdoctorexist",
        body: {"mobilenumber": mobileController.text});
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

//! - -------------------------  INIT Method ----------------------------------------------------------
  @override
  void initState() {
    super.initState();
    loading = true;

    checkDoctorExists();

    images.add("Add Image");
    _experiencecontroller.text = "0";

    getLocation();
    getLanguage();
    getCity();
    getCategory();
    getAccrediations();
    setState(() {});
  }

  //!  ---------------------------   It is Widget for making the the text box so that user input --------------------------------------

  Widget _entryField(String title, isPassword, TextEditingController text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: GoogleFonts.roboto(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 17)),
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

  //! ----------------------   Main Widget Starts ------------------------------------------------

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
                SafeArea(
                    child: page == false
                        ? SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 90,
                              ),
                              Text("Register",
                                  style: GoogleFonts.roboto(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(height: height * 0.04),
                              _entryField("Name", false, _nameController),
                              _entryField("Email", false, _emailController),

                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Date of Birth  ",
                                  style: GoogleFonts.roboto(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              // ignore: deprecated_member_use
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  _selectDate(context);
                                },
                                child: Text(
                                    " " +
                                        selectedDate
                                            .toString()
                                            .substring(0, 10),
                                    style: GoogleFonts.roboto()),
                              ),
                              SizedBox(height: height * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 300,
                                    child: DropdownButton(
                                      items: _gender
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value,
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primary),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (selectedgen) {
                                        setState(() {
                                          _selectedgender = selectedgen;
                                          print(_selectedgender);
                                        });
                                      },
                                      value: _selectedgender,
                                      hint: Text(
                                        "Select Gender",
                                        style:
                                            GoogleFonts.roboto(color: primary),
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
                                      items: _doctorCategory1
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value,
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: primary),
                                                ),
                                                value: value.toString(),
                                              ))
                                          .toList(),
                                      onChanged: (selectedCategory) {
                                        setState(() {
                                          // loading = true;
                                          _selectedcategory = selectedCategory;
                                        });
                                        getQualifications();
                                      },
                                      value: _selectedcategory == null
                                          ? null
                                          : _selectedcategory.toString(),
                                      hint: Text(
                                        "Select Category",
                                        style:
                                            GoogleFonts.roboto(color: primary),
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
                                  style: GoogleFonts.roboto(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Column(
                                children: _qualification.map((e) {
                                  int index = _qualification.indexOf(e);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                e["qualific_name"].toString(),
                                                style: GoogleFonts.roboto())),
                                        Expanded(
                                          child: Checkbox(
                                            activeColor: primary,
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
                                style: GoogleFonts.roboto(
                                  color: primary,
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
                                      activeColor: primary,
                                      value: vedio,
                                      onChanged: (value) {
                                        setState(() {
                                          vedio = value;
                                        });
                                      }),
                                  Text(
                                    "Video Call",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: check,
                                      onChanged: (value) {
                                        setState(() {
                                          check = value;
                                        });
                                      }),
                                  Text(
                                    "Call",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: chat,
                                      onChanged: (value) {
                                        setState(() {
                                          chat = value;
                                        });
                                      }),
                                  Text(
                                    "Chat",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: clinic,
                                      onChanged: (value) {
                                        setState(() {
                                          clinic = value;
                                        });
                                      }),
                                  Text(
                                    "At Clinic",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: medical,
                                      onChanged: (value) {
                                        setState(() {
                                          medical = value;
                                        });
                                      }),
                                  Text(
                                    "Medical Camps",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: wellness,
                                      onChanged: (value) {
                                        setState(() {
                                          wellness = value;
                                        });
                                      }),
                                  Text(
                                    "Wellness Sessions",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: primary,
                                      value: homevisit,
                                      onChanged: (value) {
                                        setState(() {
                                          homevisit = value;
                                        });
                                      }),
                                  Text(
                                    "Home Visit",
                                    style: GoogleFonts.roboto(),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Languages",
                                  style: GoogleFonts.roboto(color: primary)),

                              SizedBox(
                                height: 20,
                              ),

                              Column(
                                children: language
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Checkbox(
                                              activeColor: primary,
                                              value: lang[language.indexOf(e)],
                                              onChanged: (value) {
                                                setState(() {
                                                  lang[language.indexOf(e)] =
                                                      value;
                                                });
                                              }),
                                          Text(
                                            e,
                                            style: GoogleFonts.roboto(),
                                          )
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var response = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return Accrediations();
                                    },
                                  ));
                                  if (response != null)
                                    accrediationColor = response;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Accrediations",
                                        style: GoogleFonts.roboto(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        "+",
                                        style: GoogleFonts.roboto(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
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
                                          style: GoogleFonts.roboto(),
                                        ),
                                      ),
                                    )
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: accrediationColor.length,
                                        itemBuilder: (context, index) {
                                          return accrediationColor[index] ==
                                                  true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      accrediation[index]
                                                          .accrediationCode,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors
                                                              .greenAccent)),
                                                )
                                              : Container();
                                        },
                                      ),
                                    ),
                              SizedBox(
                                height: 30,
                              ),

                              //!    ********************  Speciality  *********************

                              GestureDetector(
                                onTap: () async {
                                  var response = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return Specialityy(
                                        speciality: speciality,
                                      );
                                    },
                                  ));
                                  if (response != null)
                                    specialityColor = response;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Specialities",
                                        style: GoogleFonts.roboto(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        "+",
                                        style: GoogleFonts.roboto(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
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
                                          style: GoogleFonts.roboto(),
                                        ),
                                      ),
                                    )
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: specialityColor.length,
                                        itemBuilder: (context, index) {
                                          return specialityColor[index] == true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      speciality[index].name,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors
                                                              .greenAccent)),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
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
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        controller: _experiencecontroller,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          decimal: false,
                                          signed: true,
                                        ),
                                        // inputFormatters: <TextInputFormatter>[
                                        //   WhitelistingTextInputFormatter
                                        //       .digitsOnly
                                        // ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 38.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                int currentValue = int.parse(
                                                    _experiencecontroller.text);
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
                                              int currentValue = int.parse(
                                                  _experiencecontroller.text);
                                              setState(() {
                                                print("Setting state");
                                                currentValue--;
                                                _experiencecontroller
                                                    .text = (currentValue > 0
                                                        ? currentValue
                                                        : 0)
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
                              _entryField(
                                  "Clinic Name", false, _clinicController),
                              SizedBox(height: height * 0.04),
                              Text(
                                "Selecty City",
                                style: GoogleFonts.roboto(
                                    color: primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.04),
                              Column(
                                children: [
                                  Center(
                                    child: Container(
                                      width: width / 2,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(color: primary)),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Center(
                                          child: TypeAheadField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: searchController,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                      hintText: 'Search City',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey)),
                                            ),
                                            suggestionsCallback: (pattern) {
                                              List<String> c = [];
                                              city.forEach((element) {
                                                if (element
                                                    .toLowerCase()
                                                    .contains(pattern
                                                        .toLowerCase())) {
                                                  c.add(element);
                                                }
                                              });
                                              return c;
                                              // return searchController.text.length >= 3
                                              //     ? await commeonMethod4(
                                              //         BASE_URL +
                                              //             "algolia/search?keyword=" +
                                              //             pattern,
                                              //         accessToken)
                                              //     : null;
                                            },
                                            itemBuilder: (context, suggestion) {
                                              // return Container(),
                                              return ListTile(
                                                title: Text(suggestion),
//                                        subtitle: Text('\$${suggestion['price']}'),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              searchController.text =
                                                  suggestion;
                                              selectCity = suggestion;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(selectCity)
                                ],
                              ),
                              //!  ----------------------  City Drop Down  --------------------------
                              // DropdownButton(
                              //     value: selectCity,
                              //     onChanged: (value) {
                              //       setState(() {
                              //         selectCity = value;
                              //       });
                              //     },
                              //     items: city.map((e) {
                              //       return DropdownMenuItem(
                              //         child:
                              //             Text(e, style: GoogleFonts.roboto()),
                              //         value: e,
                              //       );
                              //     }).toList()),
                              SizedBox(height: height * 0.06),
                              _entryField("Address", false, _addressController),
                              SizedBox(height: height * 0.04),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Working Hours: ",
                                  style: GoogleFonts.roboto(
                                    color: primary,
                                    fontWeight: FontWeight.bold,

                                    // fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Row(children: [
                                SizedBox(width: width * 0.2),
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    _startTime(context);
                                  },
                                  child: Text(
                                    "From: " +
                                        selectedStartTime
                                            .toString()
                                            .substring(10, 15),
                                    style: GoogleFonts.roboto(),
                                  ),
                                ),
                                SizedBox(width: width * 0.1),
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    _endTime(context);
                                  },
                                  child: Text(
                                    "To: " +
                                        selectedendTime
                                            .toString()
                                            .substring(10, 15),
                                    style: GoogleFonts.roboto(),
                                  ),
                                ),
                              ]),
                              SizedBox(height: height * 0.04),
                              _entryField("Registration Number", false,
                                  _regNumController),
                              SizedBox(height: height * 0.04),

                              InkWell(
                                onTap: () {
                                  _onAddImageClick();
                                },
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Text(
                                          "Upload Profile Picture",
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // fontWeight: FontWeight.w600,
                                            // fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text("*",
                                        style: GoogleFonts.roboto(
                                            fontSize: 20, color: Colors.red)),
                                    Spacer(),
                                  ],
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: primary, width: 2)),
                                      child: Image.file(_imageFile),
                                    ),
                              SizedBox(height: height * 0.04),
                              InkWell(
                                onTap: () {
                                  _onAddSignatureClick();
                                },
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      "Upload Signature",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // fontWeight: FontWeight.w600,
                                        // fontSize: 17,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: primary, width: 2)),
                                      child: Image.file(_signatureimageFile),
                                    ),
                              SizedBox(height: height * 0.04),
                              InkWell(
                                onTap: () {
                                  loadAssets();
                                },
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Text(
                                          "Upload Documents",
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // fontWeight: FontWeight.w600,
                                            // fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text("*",
                                        style: GoogleFonts.roboto(
                                            fontSize: 20, color: Colors.red)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              buildGridView(),
                              SizedBox(height: height * 0.02),
                              saveButton(context),
                              SizedBox(height: height * 0.07),
                            ]),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 60,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: primary),
                                        onPressed: () {
                                          page = false;
                                          setState(() {});
                                        }),
                                    Spacer(),
                                    Text(
                                      "Facilities",
                                      style: GoogleFonts.roboto(fontSize: 20),
                                    ),
                                    Spacer(),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: facility
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                int i = facility.indexOf(e);
                                                facilityColor[i] =
                                                    !facilityColor[i];
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: facilityColor[facility
                                                              .indexOf(e)] ==
                                                          true
                                                      ? primary
                                                      : Colors.transparent,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    e.facility,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: InkWell(
                                  onTap: () async {
                                    //!  -----------------  This is function for Register User through api --------------------
                                    List<String> mode = [];
                                    if (check == true) mode.add("Call");
                                    if (vedio == true) mode.add("Vedio Call");
                                    if (chat == true) mode.add("Chat");
                                    if (clinic == true) mode.add("At Clinic");
                                    if (homevisit == true)
                                      mode.add("Home Visit");
                                    if (medical == true)
                                      mode.add("Medical Camps");
                                    if (wellness == true)
                                      mode.add("Wellness Sessions");

                                    loading = true;
                                    setState(() {});
                                    i = -1;
                                    List furtherA = [];
                                    accrediationColor.forEach((element) {
                                      ++i;
                                      if (element == true) {
                                        furtherA
                                            .add(jsonEncode(accrediation[i]));
                                      }
                                    });
                                    i = -1;
                                    List furtherS = [];
                                    specialityColor.forEach((element) {
                                      ++i;
                                      if (element == true) {
                                        furtherS.add(jsonEncode(speciality[i]));
                                      }
                                    });
                                    // print(furtherS);

                                    i = -1;
                                    List furtherF = [];
                                    facilityColor.forEach((element) {
                                      ++i;
                                      if (element == true) {
                                        furtherF.add(jsonEncode(facility[i]));
                                      }
                                    });
                                    // print(qualif);
                                    // print(furtherF);
                                    i = -1;
                                    List<String> langf = [];
                                    while (++i < lang.length) {
                                      if (lang[i] == true)
                                        langf.add(language[i]);
                                    }
                                    print(langf);
                                    String url =
                                        "http://3.15.233.253:5000/doctorregister?name=${_nameController.text}&email=${_emailController.text}&dob=$selectedDate&gender=$_selectedgender&category=$_selectedcategory&practice=$_selectedpractice&qualification=$qualif&experience=${_experiencecontroller.text}&clinicname=${_clinicController.text}&city=$selectCity&address=${_addressController.text}&workingto=${selectedendTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&workingfrom=${selectedStartTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&regno=${_regNumController.text}&mobilenumber=${mobileController.text}&modeofservices=$mode&latitude=${locationData.latitude}&longitude=${locationData.longitude}&accrediation=$furtherA&specialities=$furtherS&facility=$furtherF&language=$langf";
                                    print("url is " + url);
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
                                        _signatureimageFile
                                            .readAsBytes()
                                            .asStream(),
                                        _signatureimageFile.lengthSync(),
                                        filename: "imagesignature.jpg",
                                      ));
                                    }
                                    //! ********************************   This is function for sending multiple images  ********************************
                                    multiimages.forEach((element) async {
                                      String filePath =
                                          await FlutterAbsolutePath
                                              .getAbsolutePath(
                                                  element.identifier);
                                      request.files.add(http.MultipartFile(
                                        'document',
                                        File(filePath).readAsBytes().asStream(),
                                        File(filePath).lengthSync(),
                                        filename: "document.jpg",
                                      ));
                                    });
                                    // var res = await request.send();
                                    // print(res.statusCode);
                                    // print(res.stream.);
                                    http.Response response =
                                        await http.Response.fromStream(
                                            await request.send());
                                    print("Result: ${response.statusCode}");
                                    print(response.body);

                                    setState(() {});
                                    checkDoctorExists();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text(
                                        "Register",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
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
                        border: Border.all(color: primary, width: 2)),
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
    List<Asset> resultList = [];

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
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      multiimages = resultList;
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
            primaryColor: primary,
            accentColor: primary,
            colorScheme: ColorScheme.light(primary: primary),
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

  int i = -1;
  String qualif = "";
//!  -----------------------------------------  When Save Button Pressed User is Register From HERE *********************************
  Widget saveButton(context) {
    // ignore: deprecated_member_use
    return OutlineButton(
      onPressed: () async {
        i = -1;
        qualif = "";
        while (++i < qualtification.length) {
          if (qualtification[i] == true) {
            print(_qualification[i]);
            qualif = qualif + _qualification[i]["qualific_code"] + ",";
          }
        }
        if (_experiencecontroller.text.length != 0 &&
            _regNumController.text.length != 0 &&
            _clinicController.text.length != 0 &&
            _nameController.text.length != 0 &&
            _addressController.text.length != 0 &&
            _emailController.text.length != 0 &&
            _selectedcategory != null &&
            _selectedpractice.length != 0 &&
            _selectedgender.length != 0 &&
            selectedDate != null &&
            selectedStartTime != null &&
            selectCity.length > 0 &&
            _imageFile != null &&
            multiimages.length > 0 &&
            selectedendTime != null) {
          var result = await showDialog(
              context: context,
              builder: (context) {
                bool agr = false;
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: StatefulBuilder(
                    builder: (context, setState) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Agreements",
                                  style: GoogleFonts.roboto(
                                      color: primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(agreement, style: GoogleFonts.roboto()),
                              SizedBox(
                                height: 30,
                              ),
                              Text("Charges", style: GoogleFonts.roboto()),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: pr.map((e) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(e.serviceType + ":",
                                            style: GoogleFonts.roboto()),
                                      ),
                                      Expanded(
                                        child: Text('₹' + e.finalPrice,
                                            style: GoogleFonts.roboto()),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 80,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Checkbox(
                                          value: agr,
                                          activeColor: primary,
                                          onChanged: (value) {
                                            setState(() {
                                              agr = value;
                                            });
                                          })),
                                  Expanded(
                                    child: Text("Agree",
                                        style: GoogleFonts.roboto()),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              agr == false
                                  ? Container()
                                  : Center(
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.pop(context, true);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text("Continue",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: primary,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
          if (result == true) {
            if (facility.length > 0) {
              page = true;
              setState(() {});
            } else {
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
                  furtherS.add(jsonEncode(speciality[i]));
                }
              });
              print(furtherS);

              i = -1;
              List furtherF = [];
              facilityColor.forEach((element) {
                ++i;
                if (element == true) {
                  furtherF.add(jsonEncode(facility[i]));
                }
              });
              print(qualif);
              print(furtherF);
              i = -1;
              List<String> langf = [];
              while (++i < lang.length) {
                if (lang[i] == true) langf.add(language[i]);
              }
              print(langf);
              String url =
                  "http://3.15.233.253:5000/doctorregister?name=${_nameController.text}&email=${_emailController.text}&dob=$selectedDate&gender=$_selectedgender&category=$_selectedcategory&practice=$_selectedpractice&qualification=$qualif&experience=${_experiencecontroller.text}&clinicname=${_clinicController.text}&city=$selectCity&address=${_addressController.text}&workingto=${selectedendTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&workingfrom=${selectedStartTime.toString().replaceAll(RegExp(r'TimeOfDay'), "")}&regno=${_regNumController.text}&mobilenumber=${mobileController.text}&modeofservices=$mode&latitude=${locationData.latitude}&longitude=${locationData.longitude}&accrediation=$furtherA&specialities=$furtherS&facility=$furtherF&language=$langf";
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
                String filePath = await FlutterAbsolutePath.getAbsolutePath(
                    element.identifier);
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

              setState(() {});
              checkDoctorExists();
            }
          }
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
                          style: GoogleFonts.roboto(),
                        ),
                      ),
                    ),
                  ));
        }
      },
      borderSide: BorderSide(color: primary),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text("Save",
          style:
              GoogleFonts.roboto(color: primary, fontWeight: FontWeight.bold)),
    );
  }
}
