import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference case_ref =
      FirebaseFirestore.instance.collection('cases');

  Future getCasesList() async {
    List items = [];

    try {
      QuerySnapshot querySnapshot = await case_ref.get();
      querySnapshot.docs.forEach((element) {
        items.add(element.data);
      });
      return items;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
