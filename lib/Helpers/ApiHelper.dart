import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/Home.dart';
import 'package:plan_my_health/UI/VerifyNumber.dart';
import 'package:plan_my_health/model/Diagnosis.dart';
import 'package:plan_my_health/model/Diagnostics.dart';
import 'package:plan_my_health/model/LoginData.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/PatientList.dart';
import 'package:plan_my_health/model/Prescriptionfinal.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/SelectWellnessList.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:plan_my_health/model/Wellness.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  String _baseUrlDev = "";
  Dio dio = new Dio();

  Future<String> mobileLogin(BuildContext context, String number) async {
    try {
      print("Iam in");

//Instance level
      dio.options.contentType = Headers.formUrlEncodedContentType;
//or works once
      Response response =
          await dio.post("http://3.15.233.253:5000/doctors/sendotp",
              data: {"mobilenumber": number},
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
              ));
      print(response.statusMessage);
      print(response.statusCode);
      print(response.toString());
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyNumber(otp: response.toString())));
      } else {
        print(response.data);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Authentication Failed'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Plese check Credencial'),
                    Text('Invalid user name or password'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return "error";
      }
    } on DioError catch (e) {
      print(e);
    }
    return "error";
  }

  Future<LoginData> verifyNumber(BuildContext context, String otp) async {
    try {
      print("Iam in");

//Instance level
      dio.options.contentType = Headers.formUrlEncodedContentType;
//or works once
      Response response =
          await dio.post("http://3.15.233.253:5000/doctors/otpverify",
              data: {"mobilenumber": 8356928929, "otp": otp},
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
              ));
      print(response.statusMessage);
      print(response.statusCode);
      print(response);
      if (response.statusCode == 200) {
        LoginData loginData = LoginData.fromJson(response.data);

        return loginData;
      } else {
        print(response.data);

        return null;
      }
    } on DioError catch (e) {
      throw e;
    }
    return null;
  }

  Future<PatientList> getOderList() async {
    Response response = await dio.get("http://3.15.233.253:5000/orders");

    if (response.statusCode == 200) {
      print(response.data);
      PatientList orderList = PatientList.fromJson(response.data);
      return orderList;
    } else {
      print(response.data);
    }
  }

  Future<List<Medicinelist>> getMedicinelist() async {
    Response response = await dio.get("http://3.15.233.253:5000/medicineslist");

    // print("---------------------" + response.statusCode.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      Medicines medicine = Medicines.fromJson(response.data);
      return medicine.medicinelist;
    } else {
      print(response.data.toString());
    }
  }

  Future<List<Diagnosislist>> getDiagnosislist() async {
    Response response =
        await dio.get("http://3.15.233.253:5000/diagnosticslist");

    print("---------------------" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Diagnosis diagnosis = Diagnosis.fromJson(response.data);
      return diagnosis.diagnosislist;
    } else {
      print(response.data);
    }
  }

  Future<List<Specialitieslist>> getSpecialitieslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/specialities");

    print("---------------------" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Specialities specialities = Specialities.fromJson(response.data);
      return specialities.specialitieslist;
    } else {
      print(response.data);
    }
  }

  Future<List<Diagnosticslist>> getDiagnosticslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/diagnostics");
    print(response.data);

    print("---------------------" + response.statusCode.toString());
    if (response.statusCode == 200) {
      List diagnosticslist = new List<Diagnosticslist>();
      for (int i = 0; i < response.data.length; ++i) {
        diagnosticslist.add(new Diagnosticslist.fromJson(response.data[i]));
      }
      print("---------------------" + diagnosticslist[0].name);
      return diagnosticslist;
    } else {
      print(response.data);
    }
  }

  Future<List<Wellnesslist>> getWellnesslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/wellness");

    print("---------------------" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Wellness wellness = Wellness.fromJson(response.data);
      print("---------------------" + wellness.wellnesslist[0].wellnessname);
      return wellness.wellnesslist;
    } else {
      print(response.data);
    }
  }

  Future<Patient> getPatientDetails(String number) async {
    Response response = await dio
        .get("http://3.15.233.253:5000/getmember?mobileNumber=" + number);

    print("---------------------" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Patient patient = Patient.fromJson(response.data);
      print("---------------------" + patient.name);
      return patient;
    } else {
      print(response.data);
    }
  }

  // ignore: non_constant_identifier_names
  Future<FormData> FormData2() async {
    var formData = FormData();
    formData.fields
      ..add(MapEntry("doctorid", "5fc7d1b6999df38f1bc95368"))
      ..add(MapEntry("doctorname", "abc"));
    return formData;
  }

  Future<String> sendPrescription(
      String id,
      String name,
      String gender,
      String age,
      int number,
      String pass,
      String drid,
      String drname,
      List<SelectMedicineList> selectMedicineList,
      List<SelectTestList> selectTestList,
      bool hospitalise,
      String specialitiesSelected,
      List<Wellnesslist> selectWellnessList,
      String remark,
      List<SelectedDisease> selectedDiseaseList) async {
    try {
      print("Iam in");
      print("Dr Id" + drid);
      print("Iam in");
      print("Before encodeing json________________________________");
      String test = json.encode(selectMedicineList).toString();
      print(test);
      print("After encodeing json__________________________________");
      String test2 = json.encode(test).toString();
      print(json.encode(selectedDiseaseList));

      print("After replace \ with " "");

      print(test2.replaceAll("\\", ""));
      print("selected diagnosis ............................................");
      print(json.encode(selectedDiseaseList));
//Instance levelz

      //----new
      dio.options.contentType = Headers.formUrlEncodedContentType;
//or works once
      Response response =
          await dio.post("http://3.15.233.253:5000/doctors/preceptionupdate",
              data: {
                "doctorid": "5fc7d1b6999df38f1bc95367",
                "doctorname": "Dr Smit thakker",
                "medicine": json.encode(selectMedicineList),
                "test": json.encode(selectTestList),
                "hospitalised": hospitalise.toString(),
                "specialist": specialitiesSelected.toString(),
                "wellness": json.encode(selectWellnessList),
                "remark": remark.toString(),
                "userid": "aaaaacdcd",
                "diagnosis": json.encode(selectedDiseaseList),
              },
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
              ));
      print(response.statusMessage);
      print(response.statusCode);
      print(response);
      if (response.statusCode == 200) {
        Prescriptionfinal prescriptionfinal =
            Prescriptionfinal.fromJson(response.data);

        return prescriptionfinal.filename.filename;
      } else {
        print(response.data);

        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<LoginData> sendPrescriptiontest(
      String id,
      String name,
      String gender,
      String age,
      int number,
      String pass,
      String drid,
      String drname,
      String selectMedicineList,
      String selectTestList,
      bool hospitalise,
      String specialitiesSelected,
      String selectWellnessList,
      String remark) async {
    try {
      print("Dr Id" + drid);
      print("Iam in");
      print('value is--> ' + json.encode(selectMedicineList));
      dio.options.contentType = Headers.formUrlEncodedContentType;
//or works once
      Response response =
          await dio.post("http://3.15.233.253:5000/doctors/preceptionupdate",
              data: {"mobilenumber": 8356928929},
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                },
              ));
    } catch (e) {
      print(e);
    }
  }
}
