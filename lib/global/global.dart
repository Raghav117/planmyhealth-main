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
      'Authorization':
          'key=AAAAX9twaH0:APA91bEC2eSMJX_nG8hRvOGtHuh0EUmoutTBzDZ-FjIa63r8ftGoZFZxaFgSEGo5-4SxxVBqcP1wsuSyksL9_TKAk3N2grwsatA9o0EXRlcf0MDwC4UPDn5t-pjHMExNW73cMR6sAVUZ',
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
  if (data != null) postDeviceToken();
  print(token);
}

postDeviceToken() async {
  await http.post("http://3.15.233.253:5000/doctordeviceidupdate",
      body: {"deviceid": token, "mobilenumber": data.mobile});
}

String agreement =
    '''The Company has set up a website http://www.planmyhealth.in/ , www.educure.online and http:// www.planmyhealth.co / (“Website”) whereby users of the website/Mobile app  can schedule appointments with and consult medical specialists/practitioners online and offline 

The Consultant is a Healthcare Professional and has approached the Company to list the Consultant on the Company’s Website and has offered to provide his expertise, experience, and skills as a Healthcare Professional to the subscribers/ patients enrolled with the Company on terms and conditions contained hereunder for mutual benefit.

NOW, THEREFORE, IT IS HEREBY AGREED BETWEEN THE PARTIES AS FOLLOWS:

CONSULTANT SERVICE
Subject to this Memorandum of Understanding, the Company hereby retains Consultant to perform the consulting service set out in Schedule A attached to this Memorandum of Understanding and made a part hereof (hereafter referred to as the “Services”), as said Schedule may be amended in writing from time to time, and Consultant agrees, subject to the this Memorandum of Understanding, render such services during the term of this Memorandum of Understanding. Such services shall be limited to the area of expertise described in Schedule A (the “Field”), as amended in writing from time to time. Consultant shall render services hereunder at such times and places as shall be mutually agreed by Company and Consultant.
It is expressly understood that Consultant has no fiduciary obligation to Company or any other third party, that Consultant’s role is to provide independent advice uninfluenced by commercial concern; and that service as a Consultant does not require him to be a represent for the Company or its products in any forum, public or private. Company expressly agrees that under no circumstances will this role be compromised or inaccurately represented.

PAYMENT
As an “Independent Contractor” doing work for Plan My Health, Consultant will be paid for the Services on a per case basis. Fee structure for each case may differ depending on the nature of the case assigned.
Collected by Company: Company shall pay total outstanding amount, on the 10th day of every month, (subject to tax as are applicable from time to time) subject to terms of this Memorandum of Understanding, for Services performed as will be confirmed by Plan My Health personnel. In order to ensure timely payment, Consultant will provide details in Schedule B in relation to payments. 

TERM AND TERMINATION 
This Memorandum of Understanding shall remain in effect for a term of twelve (12) months commencing on the date first written above, unless sooner terminated as herein provided, or unless extended by Memorandum of Understanding of the parties and the assent of the Plan My Health.
This Memorandum of Understanding may be terminated by either party, with or without cause, upon thirty (30) days prior written notice to the other; provided that if Consultant terminates this Memorandum of Understanding, Consultant shall, in accordance with the terms and conditions hereof. Notwithstanding anything elsewhere under the Memorandum of Understanding, Company shall have the right to terminate the Memorandum of Understanding forthwith, without giving any prior notice, in case of a statutory violation.

CONFIDENTIALITY 
Company shall provide Sensitive personal data and/or confidential information of the patients in physical or electronic way to Consultant in furtherance of this Memorandum of Understanding. Consultant acknowledges and agrees that consultant shall not use and/or disclose to any third party hereof and it shall return or destroy all sensitive personal data and/or confidential information upon the termination as mentioned in sub-clause 3.1 and 3.2 (subject to applicable law and, with respect to Company, its internal record-keeping requirements).

WARRANTIES 
Consultant represents and warrants to the Company that; (a) this MoU creates a binding and legally enforceable on Consultant, (b) Consultant has right to enter into and fully perform this MoU, (c) Consultant have not entered into, and during the term will not enter into, any MoU or agreement that would prevent Consultant from complying with this MoU; (d) Consultant will comply with all applicable laws in performance of this MoU, including holding and complying with all authorizations necessary to provide Services; (e) Consultant shall provide the Service(s) within the time lines specified from time to time; Consultant shall provide the Services in a diligent manner and keep herself abreast of the latest developments in the field.

INDEMNIFICATION
Except as covered under this Memorandum of Understanding, Company shall not become or be responsible for any other liability on any account. Consultant shall indemnify, defend and hold Company harmless from all actions, proceedings, complaints, claims, damages, demands, liabilities, costs, expenses, etc arising out of or in relation with: (a) contravention of act performed by the Consultant as mentioned in Confidentiality clause in 4 (b) any violation of confidentiality obligations; (c) any form of medical negligence; (d) any violation of the intellectual property rights of the Company; (e) any act of willful misconduct, gross negligence by the Consultant and/or its employees; (f) any statutory violation; (g) any other act which may have any form of legal impact on the company.

NO SERVICE GUARANTEE.
COMPANY DOES NOT GUARANTEE THE AVAILABILITY OF THE SERVICES BY PLAN MY HEALTH. FURTHER, THE PLAN MY HEALTH SERVICES MAY BE SUBJECT TO LIMITATIONS, DELAYS, AND OTHER PROBLEMS INHERENT IN THE USE OF THE INTERNET AND ELECTRONIC COMMUNICATIONS, AND COMPANY ARE NOT RESPONSIBLE FOR ANY DELAYS, DELIVERY FAILURES, OR OTHER DAMAGES, LIABILITIES OR LOSSES RESULTING FROM SUCH PROBLEMS.

No Waiver: 
The failure of either Party to require or enforce strict performance by the other Party of any provision of this MoU or to exercise any right under this MoU shall not be construed as a waiver or relinquishment to any extent of such Party's right to assert or rely upon any such provision or right in that or any other instance.

Governing Law and Jurisdiction
The Memorandum of Understanding shall be construed, interpreted and applied in accordance with and shall be governed by the laws applicable in India. The courts at Mumbai shall have the exclusive jurisdiction to entertain any dispute or proceeding arising out of or in relation to the Memorandum of Understanding.
''';
