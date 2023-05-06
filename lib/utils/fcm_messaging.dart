import 'dart:convert';
import 'package:http/http.dart' as http;

class FcmMessaging {
  static final String _serverToken =
      '42698344810'; // Replace with your server token

  Future<void> sendNotification(
      String recipientToken, String title, String body) async {
    final url = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverToken',
    };

    final data = {
      'to': recipientToken,
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
        'badge': '1',
      },
      'priority': 'high',
      'content_available': true,
      'mutable_content': true,
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  }
}
