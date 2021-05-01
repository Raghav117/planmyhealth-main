import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:plan_my_health/model/Diagnosis.dart';
import 'package:plan_my_health/model/Diagnostics.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/Prescriptionfinal.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:plan_my_health/model/Wellness.dart';
import 'package:plan_my_health/model/findings.dart';
import 'package:plan_my_health/model/suspectedDisease.dart';

class ApiHelper {
  Dio dio = new Dio();

  Future getMedicinelist() async {
    Response response = await dio.get("http://3.15.233.253:5000/medicineslist");

    print(response.statusCode);
    if (response.statusCode == 200) {
      Medicines medicine = Medicines.fromJson(response.data);
      return medicine.medicinelist;
    } else {
      print(response.data.toString());
    }
  }

  Future getDiagnosislist() async {
    Response response =
        await dio.get("http://3.15.233.253:5000/diagnosticslist");

    if (response.statusCode == 200) {
      Diagnosis diagnosis = Diagnosis.fromJson(response.data);
      return diagnosis.diagnosislist;
    } else {
      print(response.data);
    }
  }

  Future getSpecialitieslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/specialities");

    if (response.statusCode == 200) {
      Specialities specialities = Specialities.fromJson(response.data);
      return specialities.specialitieslist;
    } else {
      print(response.data);
    }
  }

  Future getDiagnosticslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/diagnostics");

    if (response.statusCode == 200) {
      List diagnosticslist = <Diagnosticslist>[];
      for (int i = 0; i < response.data.length; ++i) {
        diagnosticslist.add(new Diagnosticslist.fromJson(response.data[i]));
      }
      return diagnosticslist;
    } else {
      print(response.data);
    }
  }

  Future getWellnesslist() async {
    Response response = await dio.get("http://3.15.233.253:5000/wellness");

    if (response.statusCode == 200) {
      Wellness wellness = Wellness.fromJson(response.data);
      return wellness.wellnesslist;
    } else {
      print(response.data);
    }
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
      List<Finding> findings,
      DateTime followupdata,
      List<SuspectedDisease> suspecteddisease,
      double ratings) async {
    try {
      String test = json.encode(selectMedicineList).toString();
      print(test);

      dio.options.contentType = Headers.formUrlEncodedContentType;
      Response response =
          await dio.post("http://3.15.233.253:5000/doctors/preceptionupdate",
              data: {
                "doctorid": id,
                "doctorname": name,
                "medicine": json.encode(selectMedicineList),
                "test": json.encode(selectTestList),
                "hospitalised": hospitalise.toString(),
                "specialist": specialitiesSelected.toString(),
                "wellness": json.encode(selectWellnessList),
                "remark": remark.toString(),
                "userid": drid,
                "diagnosis": json.encode(suspecteddisease),
                "followupdate": followupdata.toString(),
                "doctorcheckdate": DateTime.now(),
                "findings": json.encode(findings),
                "doctorfeedback": ratings
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
}
