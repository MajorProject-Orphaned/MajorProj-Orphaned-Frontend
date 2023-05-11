import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import './fcm_messaging.dart';

class MyDataProcessor {
  Future<void> processData(String url) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('cases');
    final QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      final Map<String, dynamic> data = documentSnapshot.data();

      // Sending API Reques to Model for Comparison

      // Check if the images match

// If the images match, send a notification to the police officer who registered the case
      if (true) {
        String policeUserId = data['policeUserId'];
        FcmMessaging fcmMessaging = FcmMessaging();
        await fcmMessaging.sendPushMessage(policeUserId);
        return;
      }
    }
  }
}
