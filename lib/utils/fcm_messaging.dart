import 'dart:convert';
import 'package:http/http.dart' as http;

// class FcmMessaging {
//   static final String _serverToken =
//       '42698344810'; // Replace with your server token

//   Future<void> sendNotification(
//       String recipientToken, String title, String body) async {
//     final url = 'https://fcm.googleapis.com/fcm/send';

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$_serverToken',
//     };

//     final data = {
//       'to': recipientToken,
//       'notification': {
//         'title': title,
//         'body': body,
//         'sound': 'default',
//         'badge': '1',
//       },
//       'priority': 'high',
//       'content_available': true,
//       'mutable_content': true,
//     };

//     final response = await http.post(Uri.parse(url),
//         headers: headers, body: jsonEncode(data));

//     if (response.statusCode == 200) {
//       print('Notification sent successfully.');
//     } else {
//       print('Failed to send notification. Error: ${response.reasonPhrase}');
//     }
//   }
// }

class FcmMessaging {
  void sendPushMessage(String token) async {
    try {
      http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAACfEFCWo:APA91bGN1Wly0orEqfvV95z6MHQOo9jjD8VeeMM-xtRTQD4BHUy8B5agRH6QFkGXsjS5-258pHMqHE23oi8PCI-CxNSLnZ4K9gEzUFAWeGsyiQuGEeLcjh59AhDdKdgueYEsV52BY319'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Test message',
              'title': 'title'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "/topics/$token",
          },
        ),
      );
      print('Hello Send successfull');
    } catch (e) {
      print("error push notification");
    }
  }
}
