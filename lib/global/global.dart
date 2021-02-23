import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:plan_my_health/model/doctor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

TextEditingController mobileController = TextEditingController();

Data data;
bool online = false;
bool chat = false;
bool home_visit = false;
bool video = false;
bool center = false;
bool call = false;
bool save = false;

// Replace with server token from firebase console settings.
final String serverToken =
    'AAAAX9twaH0:APA91bEC2eSMJX_nG8hRvOGtHuh0EUmoutTBzDZ-FjIa63r8ftGoZFZxaFgSEGo5-4SxxVBqcP1wsuSyksL9_TKAk3N2grwsatA9o0EXRlcf0MDwC4UPDn5t-pjHMExNW73cMR6sAVUZ';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'this is a body',
          'title': 'this is a title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': await firebaseMessaging.getToken(),
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );

  return completer.future;
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String token;
getToken() async {
  token = await _firebaseMessaging.getToken();
  postDeviceToken();
  print(token);
}

postDeviceToken() async {
  await http.post("http://3.15.233.253:5000/doctordeviceidupdate",
      body: {"deviceid": token, "mobilenumber": data.mobile});
}
